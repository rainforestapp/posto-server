class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_pgsql_search_path

  def set_pgsql_search_path
    ActiveRecord::Base.connection.schema_search_path = "posto0"
  end
end
