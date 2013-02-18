namespace :worker do
  def decode_from_java(data)
    if data[1].kind_of?(Array)
      data[1].map { |v| decode_from_java(v) }
    elsif data[1].kind_of?(Hash)
      data[1]
    else
      data[1]
    end
  end

  def encode_to_java(data)
    java_type = nil
    value = data

    if data.kind_of?(Hash)
      java_type = "java.util.Map"
    elsif data.kind_of?(Array)
      java_type = "java.util.List"
      value = data.map { |v| encode_to_java(v) }
    elsif data.kind_of?(Fixnum)
      java_type = "java.lang.Long"
    elsif data.kind_of?(Float)
      java_type = "java.lang.Double"
    elsif data.kind_of?(String)
      java_type = "java.lang.String"
    elsif data.nil?
      java_type = "java.lang.Object"
    else
      puts "Can't convert to java: #{data}"
    end

    [java_type, value]
  end

  task :start => :environment do
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

    domain.activity_tasks.poll("posto-worker") do |activity_task|
      begin
        @mutex.synchronize do
          @processing = true
        end

        class_name, activity_method = activity_task.activity_type.name.split(".")
        args = decode_from_java(JSON.parse(activity_task.input))
        worker = Kernel.const_get(class_name.to_sym).new
        worker.task_token = activity_task.task_token if worker.respond_to?(:task_token=)
        result = worker.send(activity_method.underscore.to_sym, args)
        activity_task.complete!(result: encode_to_java(result).to_json)
      ensure
        @mutex.synchronize do
          @processing = false
        end
      end
    end
  end
end
