# frozen_string_literal: true

module Sekreto
  # Rails Railtie to set up the Sekreto configuration
  #
  # Defaults the secrets Manager to Aws::SecretsManager::Client.new
  # Defaults the prefix to Rails app name and Rails.env e.g. foo-staging
  # Defaults allowed envs to check Rails.env is production or staging
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      app_name = ::Rails.application.class.to_s.split('::').first.downcase

      Sekreto.setup do |setup|
        setup.secrets_manager = Aws::SecretsManager::Client.new
        setup.prefix = [app_name, ::Rails.env.downcase].join('-')
        setup.is_allowed_env = -> { %w[production staging].include?(::Rails.env) }
      end
    end
  end
end
