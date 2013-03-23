require "statsd"
STATSD = Statsd.new("statsd.lulcards.com")
STATSD.namespace = "posto"
hostname = `hostname`.chomp

ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
  path = "#{payload[:controller].gsub(/Api::V.::/, "").gsub(/Controller$/, "").underscore}.#{payload[:action]}"
  total_time = ((finish - start) * 1000).floor

  ["controller.all.", "controller.#{hostname}."].each do |prefix|
    STATSD.increment("#{prefix}#{path}.count")
    STATSD.timing("#{prefix}#{path}.total_time", total_time)

    if payload[:view_runtime]
      STATSD.timing("#{prefix}#{path}.view_time", payload[:view_runtime].floor)
    end

    if payload[:db_runtime]
      STATSD.timing("#{prefix}#{path}.db_time", payload[:db_runtime].floor)
    end
  end
end
