namespace :cron do
  task :run => :environment do
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains["posto-#{Rails.env == "production" ? "prod" : "dev"}"]
    workflow_type = domain.workflow_types['CronSchedulerWorkflow.runCron', 
                                          CONFIG.for_app(App.babygrams).cron_workflow_version]
    workflow_id = "cron-#{SecureRandom.hex}"

    repeat = true
    input = ["[Ljava.lang.Object;", []].to_json
    workflow_type.start_execution input: input, workflow_id: workflow_id, tag_list: []
  end
end
