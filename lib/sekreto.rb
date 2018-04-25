require 'aws-sdk-secretsmanager'
require 'multi_json'

require 'sekreto/version'
require 'sekreto/config'

require 'sekreto/railtie' if defined?(Rails)

# Sekreto holds configuration and interface for getting secrets
module Sekreto
  class << self
    def setup
      yield config if block_given?
    end

    def get_value(secret_id)
      return config.fallback_lookup.call(secret_id) unless config.is_allowed_env.call
      response = secrets_manager.get_secret_value(secret_id: secret_name(secret_id))
      response.secret_string
    end

    def get_json_value(secret_id)
      response = get_value(secret_id)
      MultiJson.load(response)
    end

    def config
      @config ||= Config.new
    end

    private

    def secret_name(secret_id)
      [config.prefix, secret_id].join('/')
    end

    def secrets_manager
      config.secrets_manager
    end
  end
end
