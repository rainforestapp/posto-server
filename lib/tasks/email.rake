namespace :email do
  task :nightly => :environment do
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains["posto-#{Rails.env == "production" ? "prod" : "dev"}"]
    workflow_type = domain.workflow_types['OutgoingEmailWorkflow.sendOutgoingEmails', CONFIG.for_app(App.babygrams).outgoing_email_workflow_version]
    workflow_id = "outgoing-emails-#{SecureRandom.hex}"

    input = ["[Ljava.lang.Object;", []].to_json
    workflow_type.start_execution input: input, workflow_id: workflow_id, tag_list: []
  end
end
