if ActiveRecord::Base.configurations &&
   ActiveRecord::Base.configurations[Rails.env] &&
   ActiveRecord::Base.configurations[Rails.env]["host"] != "127.0.0.1"
  ActiveRecord::Base.connection.schema_search_path = "posto0"
end
