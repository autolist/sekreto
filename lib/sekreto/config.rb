module Sekreto
  class Config
    attr_accessor :prefix
    attr_accessor :is_allowed_env
    attr_accessor :fallback_lookup
    attr_accessor :secrets_manager

    def initialize
      @prefix = 'secrets'
      @is_allowed_env = -> { true }
      @fallback_lookup = ->(secret_id) { ENV[secret_id] }
      @secrets_manager = nil
    end
  end
end
