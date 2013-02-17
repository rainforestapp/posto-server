class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_sampled_config

  CONFIG_SEED_HEADER = "X-posto-config-seed"

  def set_sampled_config
    if request.headers[CONFIG_SEED_HEADER]
      @sampled_config = CONFIG.to_sampled_config(request.headers[CONFIG_SEED_HEADER].to_i)
    else
      @sampled_config = CONFIG.to_sampled_config(0)
    end
  end
end
