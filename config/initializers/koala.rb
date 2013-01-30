# Ubuntu
#(Koala.http_service.http_options[:ssl] ||= {})[:ca_path] = '/etc/ssl/certs'
# Mac OS X 
(Koala.http_service.http_options[:ssl] ||= {})[:ca_file] = '/opt/local/share/curl/curl-ca-bundle.crt'

