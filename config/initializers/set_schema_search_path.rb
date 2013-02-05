if ActiveRecord::Base.configurations
   ActiveRecord::Base.configurations[Rails.env] &&
   ActiveRecord::Base.configurations[Rails.env]["host"] != "127.0.0.1"
   puts ActiveRecord::Base.configurations.inspect
  #ActiveRecord::Base.connection.schema_search_path = "posto0"
end
