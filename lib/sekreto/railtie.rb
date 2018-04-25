require 'rails'

module Sekreto
  # Rails Railtie to set up the Sekreto configuration
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      app_name = ::Rails.application.class.to_s.split('::').first.downcase

      Sekreto.setup do |setup|
        setup.secrets_manager = Aws::SecretsManager::Client.new
        setup.prefix = [app_name, ::Rails.env.downcase].join('-')
        setup.is_allowed_env = -> { %w[production staging].include?(::Rails.env) }
      end
    end
  end
end
