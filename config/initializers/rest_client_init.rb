if Rails.env == "development"
  RC = RestClient::Resource.new('http://posto.dev')

  RC.class.class_eval do
    { :sget => :get, :spost => :post, :sput => :put, :sdelete => :delete }.each do |s_method, method|
      define_method s_method do |*args|
        params ||= {}
        params = args.last if args.last.kind_of?(Hash)
        headers = {}
        headers[:authorization] = 'Token token="thisisabackdoor"'
        headers[:content_type] = 'application/json'

        if method == :get
          self.send(method, params.merge(headers))
        else
          self.send(method, params, headers)
        end
      end
    end
  end
end
