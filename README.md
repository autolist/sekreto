# Sekreto

[![Gem Version](https://badge.fury.io/rb/sekreto.svg)](https://badge.fury.io/rb/sekreto)
[![Build Status](https://travis-ci.org/autolist/sekreto.svg?branch=master)](https://travis-ci.org/autolist/sekreto)
[![Maintainability](https://api.codeclimate.com/v1/badges/3f03647e9b305f1626de/maintainability)](https://codeclimate.com/github/autolist/sekreto/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3f03647e9b305f1626de/test_coverage)](https://codeclimate.com/github/autolist/sekreto/test_coverage)
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=autolist/sekreto)](https://dependabot.com)

Use AWS Secrets Manager from Ruby, with rails support

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sekreto'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sekreto

## Usage

### Configuration

Configuration will happen automatically in a Rails environment to set defaults
that make integrating easy. The defaults look like

```ruby
Sekreto.setup do |setup|
  # Default secrets manager is a new client
  setup.secrets_manager = Aws::SecretsManager::Client.new

  # Prefix of secrets set to Rails app name and RAILS_ENV
  setup.prefix = 'railsappname-staging'

  # Allowed environments to use secrets is set to production/staging
  # Any block can be given that responds to #call and returns a true or false
  # that will use secrets calls if allowed and use the fallback if not
  setup.is_allowed_env = -> { %w[production staging].include?(::Rails.env) }

  # Default fallback is to look up the secret in the ENV if it is not an
  # allowed env to use the secret manager
  setup.fallback_lookup = ->(secret_id) { ENV[secret_id] }
end
```

You can use an initializer to customize any of the defaults

_config/initializers/sekreto.rb_
```ruby
Sekreto.setup do |setup|
  setup.secrets_manager = Aws::SecretsManager::Client.new
  setup.prefix = 'some/other/prefix'
  setup.is_allowed_env = -> { ENV.fetch('USE_SECRETS', false) }
  setup.fallback_lookup = ->(secret_id) { Secrets.where(name: secret_id).pluck(:value).first }
end
```

Only use Aws::SecretsManager in specific environments

_config/initializers/sekreto.rb_
```ruby
Sekreto.setup do |setup|
  setup.secrets_manager = %w[production staging].include?(::Rails.env) ? Aws::SecretsManager::Client.new : nil
  setup.prefix = 'sparkecommerce'
  setup.is_allowed_env = -> { %w[production staging].include?(::Rails.env) }
  setup.fallback_lookup = ->(secret_id) { ENV[secret_id] }
end
```

### Retrieving Secrets

Getting plain text secrets:

```ruby
# Will query for "#{prefix}/my-secret"
secret = Sekreto.get_value('my-secret')
puts secret
# Output: asdf124asdf134asdf1243asdf
```

Getting JSON secrets will return the parsed value

```ruby
# Will query for "#{prefix}/my-secret-config"
secret = Sekreto.get_json_value('my-secret-config')
puts secret
# Output: { some: 'json', data: 'here' }
```

Getting secrets with a custom prefix. Useful for shared secrets or secrets
across apps, namespaces, etc.

```ruby
# Will query for "shared-secrets/MY-SECRET-CONFIG"
secret = Sekreto.get_json_value('MY-SECRET-CONFIG', 'shared-secrets')
puts secret
# Output: { some: 'json', data: 'here' }
```

If you want to skip prefixes all together you can pas `false` to either
get value methods. **Not recommended**

```ruby
# Will query for "MY-SECRET-CONFIG"
secret = Sekreto.get_json_value('MY-SECRET-CONFIG', false)
puts secret
# Output: { some: 'json', data: 'here' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/autolist/sekreto. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sekreto project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sekreto/blob/master/CODE_OF_CONDUCT.md).
