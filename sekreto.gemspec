# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sekreto/version'

Gem::Specification.new do |spec|
  spec.name          = 'sekreto'
  spec.version       = Sekreto::VERSION
  spec.authors       = ['Autolist Engineering']
  spec.email         = %w[dev@autolist.com]

  spec.summary       = 'AwsSecretsManager for Ruby'
  spec.description   = 'Manage AWS Secrets from Ruby'
  spec.homepage      = 'https://github.com/autolist/sekreto'
  spec.license       = 'MIT'
  spec.files         = Dir.glob('{bin,lib}/**/*') + %w[README.md]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'aws-sdk-secretsmanager'
  spec.add_dependency 'multi_json'

  spec.add_development_dependency 'autocop', '>= 0.4.2'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.12.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-mocks', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.19.0'
  spec.add_development_dependency 'stub_env', '~> 1.0'
  spec.add_development_dependency 'yard', '~> 0.9.11'
end
