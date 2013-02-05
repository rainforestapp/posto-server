if ActiveRecord::Base.configurations[Rails.env]["host"] &&
   ActiveRecord::Base.configurations[Rails.env]["host"] != "127.0.0.1"
  ActiveRecord::Base.connection.schema_search_path = "posto0"
end
