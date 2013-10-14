namespace :cron do
  task :run => :environment do
    [["CronSchedulerWorkflow.runCron", "nightly"], ["PeriodicWorkflow.runPeriodic", "periodic"]].each do |info|
      workflow_execute_method = info[0]
      workflow_id_prefix = info[1]
      
      swf = AWS::SimpleWorkflow.new
      domain = swf.domains["posto-#{Rails.env == "production" ? "prod" : "dev"}"]
      workflow_type = domain.workflow_types[workflow_execute_method, 
                                            CONFIG.for_app(App.babygrams).cron_workflow_version]
      workflow_id = "#{workflow_id_prefix}-#{SecureRandom.hex}"

      repeat = true
      input = ["[Ljava.lang.Object;", []].to_json
      workflow_type.start_execution input: input, workflow_id: workflow_id, tag_list: []
    end
  end
end
