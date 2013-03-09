namespace :worker do
  def decode_from_java(data)
    if data[1].kind_of?(Array)
      data[1].map { |v| decode_from_java(v) }
    elsif data[1].kind_of?(Hash)
      data[1]
    else
      if data.kind_of?(Array)
        data[1]
      else
        data
      end
    end
  end

  def encode_to_java(data)
    java_type = nil
    value = data

    if data.kind_of?(Hash)
      ["java.util.Map", value]
    elsif data.kind_of?(Array)
      ["java.util.List", data.map { |v| encode_to_java(v) }]
    elsif data.kind_of?(Fixnum)
      ["java.lang.Long", data]
    elsif data.kind_of?(Float)
      ["java.lang.Double", data]
    #elsif data.kind_of?(String)
    #  java_type = "java.lang.String"
    #elsif data.nil?
    #  java_type = "java.lang.Object"
    else
      value
    end
  end

  task :start => :environment do
    logger = Rails.logger
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains[Rails.env == "production" || Rails.env == "princess" ? "posto-prod" : "posto-dev"]

    @finished = false
    @processing = false
    @mutex = Mutex.new

    trap("SIGINT") do
      @mutex.synchronize do
        exit 0 unless @processing
      end

      begin
        Timeout::timeout(60) do
          loop do
            @mutex.synchronize do
              exit 0 unless @processing
            end
            
            sleep 5
          end
        end
      rescue Exception => e
        exit 1
      end
    end
    
    trap("SIGTERM") do
      @mutex.synchronize do
        exit 0 unless @processing
      end

      begin
        Timeout::timeout(60) do
          loop do
            @mutex.synchronize do
              exit 0 unless @processing
            end
            
            sleep 5
          end
        end
      rescue Exception => e
        exit 1
      end
    end

    loop do 
      begin
        activity_task = domain.activity_tasks.poll_for_single_task("posto-worker")

        if activity_task
          begin
            @mutex.synchronize do
              @processing = true
            end

            class_name, activity_method = activity_task.activity_type.name.split(".")
            activity_method = activity_method.underscore
            args = decode_from_java(JSON.parse(activity_task.input))
            logger.info "[#{$$}] Activity Task: #{activity_task.activity_type.name}(#{activity_task.input})"
            worker = Kernel.const_get(class_name.to_sym).new
            worker.task_token = activity_task.task_token if worker.respond_to?(:task_token=)
            is_manual = worker.respond_to?(:manual?) && worker.manual?
            is_execute_once = worker.respond_to?(:execute_once?) && worker.execute_once?
            result = nil

            if is_execute_once
              execution = ActivityExecution.where(method: activity_method, worker:class_name,
                                                  arguments: YAML.dump({ args: args })).first

              unless execution
                result = worker.send(activity_method.to_sym, *args)
              end
            else
              result = worker.send(activity_method.to_sym, *args)
            end

            unless execution
              ActivityExecution.create!(method: activity_method, worker:class_name, arguments: { args: args })
            end

            unless is_manual
              begin
                activity_task.complete!(result: encode_to_java(result).to_json)
              rescue Exception => e
                logger.error "[#{$$}] Activity Task Completion Mark Failed #{e.message}"
              end
            end
          rescue AWS::SimpleWorkflow::ActivityTask::CancelRequestedError
            activity_task.cancel! unless activity_task.responded?
          rescue StandardError => e
            unless activity_task.responded?
              reason = "UNTRAPPED ERROR #{e.message}"
              details = e.message + "\n" + e.backtrace.join("\n")
              logger.error "[#{$$}] Activity Task Failed: #{reason} #{details}"
              activity_task.fail!(:reason => reason[0..200], :details => details)

              Airbrake.notify_or_ignore(e, parameters: { reason: reason, details: details }, cgi_data: ENV) rescue nil
            end
          ensure
            @mutex.synchronize do
              @processing = false
            end
          end
        end
      rescue Timeout::Error
        retry
      end
    end
  end
end
