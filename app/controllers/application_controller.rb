class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setup_config

  CONFIG_SEED_HEADER = "X-posto-config-seed"

  def setup_config
    if request.headers[CONFIG_SEED_HEADER]
      @config = CONFIG.to_sampled_config(request.headers[CONFIG_SEED_HEADER].to_i)
    else
      @config = CONFIG.to_sampled_config(0)
    end

    if params[:app_id]
      bind_to_app!(App.by_name(params[:app_id]))
    elsif params[:app]
      bind_to_app!(App.by_name(params[:app]))
    end
  end

  def bind_to_app!(app)
    @config = CONFIG.for_app(app)
  end

  def mobile_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPad|iPod|BlackBerry|Android)/]
  end
end
