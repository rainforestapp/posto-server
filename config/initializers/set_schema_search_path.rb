if ActiveRecord::Base.connection.raw_connection.host
  ActiveRecord::Base.connection.schema_search_path = "posto0"
end
