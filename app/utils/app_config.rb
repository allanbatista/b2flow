##
# AppConfig is responsible to make a helper to access configurations and set default if necessary
# #
# to make any environment variable available, is needed to start variable with "B2FLOW__"
module AppConfig
  ##
  # defaults values from variables config that are defined in config/application.yml
  defaults = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env] || {}

  ##
  # Define all variables as methods
  #
  # @Examples
  #
  # > AppConfig.B2FLOW__TOKEN_SECRET
  # oUyCzW5GnSs9p4g2CdBQHX4kK1lXZKNMAetaRQfti...
  (ENV.keys + defaults.keys).uniq.uniq.each do |key|
    if key.to_s.starts_with?("B2FLOW__")
      define_singleton_method(key) do
        ENV.fetch(key.to_s, defaults[key.to_s])
      end
    end
  end
end