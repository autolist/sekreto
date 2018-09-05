require 'logger'

module Sekreto
  ##
  # Config class for setting up Sekreto for usage
  class Config
    DEFAULT_PREFIX = 'secrets'.freeze

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
      @prefix = DEFAULT_PREFIX
      @is_allowed_env = -> { true }
      @fallback_lookup = ->(secret_id) { ENV[secret_id] }
      @secrets_manager = nil
      @logger = Logger.new(STDOUT)
    end

    ##
    #
    # Get the prefix name to use when looking up secrets
    #
    # @param prefix_path [String,NilClass,FalseClass] - The path to use for the prefix
    #
    # @return [String] prefix path
    #
    # @example If a nil is passed it defaults to the config.prefix.
    #          When a false is passed then no prefix is used. (Not recommended)
    def prefix_name(prefix_path = nil)
      return nil if prefix_path == false
      prefix_path || prefix
    end
  end
end
