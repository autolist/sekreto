require 'logger'

module Sekreto
  ##
  # Config class for setting up Sekreto for usage
  class Config
    attr_accessor :prefix
    attr_accessor :is_allowed_env
    attr_accessor :fallback_lookup
    attr_accessor :secrets_manager
    attr_accessor :logger

    ##
    #
    # Initialize a new Config
    #
    # @return [Sekreto::Config]
    def initialize
      @prefix = 'secrets'
      @is_allowed_env = -> { true }
      @fallback_lookup = ->(secret_id) { ENV[secret_id] }
      @secrets_manager = nil
      @logger = Logger.new(STDOUT)
    end
  end
end
