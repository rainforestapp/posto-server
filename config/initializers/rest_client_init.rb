if Rails.env == "development"
  RC = RestClient::Resource.new('http://posto.dev')

  RC.class.class_eval do
    { :sget => :get, :spost => :post, :sput => :put, :sdelete => :delete }.each do |s_method, method|
      define_method s_method do |*args|
        params ||= {}
        params = args.last if args.last.kind_of?(Hash)
        params["authorization"] = 'Token token="thisisabackdoor"'

        self.send(method, params)
      end
    end
  end
end
