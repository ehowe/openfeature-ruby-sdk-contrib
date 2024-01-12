# OpenFeature::SDK::Contrib

This gem describes a provider for OpenFeature using the following:

A feature flag format of:

```
[
  { "name" => "example_boolean", "kind" => "boolean", "value" => true, "enabled" => true },
  { "name" => "example_invalid_boolean", "kind" => "boolean", "value" => "a string", "enabled" => true },
  { "name" => "example_disabled_boolean", "kind" => "boolean", "value" => true, "enabled" => false },
  { "name"    => "example_named_string",
    "kind"    => "string",
    "value"   => "medium",
    "enabled" => true },
  { "name"    => "example_invalid_named_string",
    "kind"    => "string",
    "value"   => true,
    "enabled" => true },
  { "name"    => "example_disabled_named_string",
    "kind"    => "string",
    "value"   => "medium",
    "enabled" => false },
  { "name"     => "example_named_number",
    "kind"     => "number",
    "variants" => { "small" => 8, "medium" => 128, "large" => 2048 },
    "variant"    => "medium",
    "enabled"  => true },
  { "name"     => "example_invalid_named_number",
    "kind"     => "number",
    "variants" => { "small" => "a string", "medium" => "a string", "large" => "a string" },
    "variant"    => "medium",
    "enabled"  => true },
  { "name"     => "example_disabled_named_number",
    "kind"     => "number",
    "variants" => { "small" => 8, "medium" => 128, "large" => 2048 },
    "variant"    => "medium",
    "enabled"  => false },
  { "name"     => "example_named_float",
    "kind"     => "float",
    "variants" => { "pi" => 3.141592653589793, "e" => 2.718281828459045, "phi" => 1.618033988749894 },
    "variant"    => "e",
    "enabled"  => true },
  { "name"     => "example_invalid_named_float",
    "kind"     => "float",
    "variants" => { "pi" => "a string", "e" => "a string", "phi" => "a string" },
    "variant"    => "e",
    "enabled"  => true },
  { "name"     => "example_disabled_named_float",
    "kind"     => "float",
    "variants" => { "pi" => 3.141592653589793, "e" => 2.718281828459045, "phi" => 1.618033988749894 },
    "variant"    => "e",
    "enabled"  => false }
]
```

This can be read from a file using the `OpenFeature::SDK::Contrib::FileProvider` class or from a URL using the `UrlProvider` class.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add openfeature-ruby-sdk-contrib

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install openfeature-ruby-sdk-contrib

## Usage

If you are using rails, this code will go in an initializer. If you aren't, replace the assignments for `Rails.application.config.openfeature_provider` and `Rails.application.config.openfeature_client` with constants that you will have access to application-wide.

### File Provider

```
require "open_feature/sdk/contrib"

Rails.application.config.openfeature_provider = OpenFeature::SDK::Contrib::Providers::FileProvider.new(
cache_duration: 300,
deep_keys: ["flags"], # If your flags are nested inside of a response, this array is a list of keys that will get to the array where the actual flags are defined
format: :yaml, # json or yaml
source: "/path/to/file.yml"
)

Rails.application.config.openfeature_client = OpenFeature::SDK::Contrib::Client.new(
client_options: { name: "your arbitrary client name" },
provider: Rails.application.config.openfeature_provider
)
```

### HTTP Provider

```
require "open_feature/sdk/contrib"

Rails.application.config.openfeature_provider = OpenFeature::SDK::Contrib::Providers::HttpProvider.new(
  cache_duration: 300,
  deep_keys: ["flags"], # If your flags are nested inside of a response, this array is a list of keys that will get to the array where the actual flags are defined
  extra_options: { Authorization: "Bearer <some token>" }, # This object can be anything that gets passed to Faraday.new
  format: :json, # json or yaml
  source: "https://some.url/feature-flags"
)

Rails.application.config.openfeature_client = OpenFeature::SDK::Contrib::Client.new(
  client_options: { name: "your arbitrary client name" },
  provider: Rails.application.config.openfeature_provider
)
```

#### Custom Auth Strategy

Some applications may require more finesse to authenticate, for example, an OAuth Flow. To use this style flow, the `extra_options` key that is passed to `HttpProvider.new` accepts an `authentication_strategy` key. This key gets passed to the internal Faraday client as a middleware, so it can be anything usable as a Faraday middleware. Example:

```
  module FaradayMiddleware
    class MyCustomMiddleware < Faraday::Middleware
      def initialize(args)
        # do stuff
      end

      def call(env)
        @app.call(env)
      end
    end

    Faraday::Request.register_middleware my_custom_middleware: -> { MyCustomMiddleware }
  end

  Rails.application.config.openfeature_provider = OpenFeature::SDK::Contrib::Providers::HttpProvider.new(
    extra_options: {
      authentication_strategy: [:my_custom_middleware, my_custom_middleware_arguments]
    }
  )
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ehowe/openfeature-ruby-sdk-contrib.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
