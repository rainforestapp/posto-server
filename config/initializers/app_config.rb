CONFIG = {}
CONFIG.merge! YAML.load(File.read(File.expand_path('../../app/private.yml', __FILE__)))

env_file = File.expand_path("../../app/#{Rails.env}.yml", __FILE__)
CONFIG.merge! YAML.load(env_file) if File.exists?(env_file)

CONFIG.symbolize_keys!
