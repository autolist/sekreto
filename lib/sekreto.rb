# frozen_string_literal: true

require 'aws-sdk-secretsmanager'
require 'multi_json'

require 'sekreto/version'
require 'sekreto/config'

require 'sekreto/railtie' if defined?(Rails)

# Sekreto allows you to interact with the AWS Secrets Manager to
# retrieve your secrets from Ruby. This exposes a thin wrapper around
# the AWS SecretsManager SDK.
module Sekreto
  class << self
    ##
    # Set up the Sekreto gem configuration
    #
    # @yieldreturn [Sekreto::Config]
    #
    # @example Configuring Sekreto
    #   Sekreto.setup do |setup|
    #     setup.prefix = 'app-prefix'
    #   end
    def setup
      yield config if block_given?
    end

    ##
    #
    # Get the value given a secret
    #
    # @param secret_id [String] - The secret ID to get the value for
    # @param prefix [String] - An optional override of the prefix
    # @return [String] - The value of the stored secret
    def get_value(secret_id, prefix = nil)
      raise 'Not allowed env' unless config.is_allowed_env.call

      secrets_manager.get_secret_value(
        secret_id: secret_name(secret_id, prefix)
      ).secret_string
    rescue StandardError => e
      logger.warn("[Sekreto] Failed to get value!\n#{e}")
      config.fallback_lookup.call(secret_id)
    end

    ##
    #
    # Get the JSON value of a secret
    #
    # @param secret_id [String] - The secret ID to get the value for
    # @param prefix [String] - An optional override of the prefix
    # @return [Hash] - The parsed JSON value of the secret
    def get_json_value(secret_id, prefix = nil)
      response = get_value(secret_id, prefix)
      MultiJson.load(response)
    end

    ##
    #
    # Get the configuration for Sekreto
    #
    # @return [Sekreto::Config] - The configuration
    def config
      @config ||= Config.new
    end

    private

    def secret_name(secret_id, prefix = nil)
      [config.prefix_name(prefix), secret_id].compact.join('/')
    end

    def secrets_manager
      config.secrets_manager
    end

    def logger
      config.logger
    end
  end
end
