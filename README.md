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
    "value"    => "medium",
    "enabled"  => true },
  { "name"     => "example_invalid_named_number",
    "kind"     => "number",
    "variants" => { "small" => "a string", "medium" => "a string", "large" => "a string" },
    "value"    => "medium",
    "enabled"  => true },
  { "name"     => "example_disabled_named_number",
    "kind"     => "number",
    "variants" => { "small" => 8, "medium" => 128, "large" => 2048 },
    "value"    => "medium",
    "enabled"  => false },
  { "name"     => "example_named_float",
    "kind"     => "float",
    "variants" => { "pi" => 3.141592653589793, "e" => 2.718281828459045, "phi" => 1.618033988749894 },
    "value"    => "e",
    "enabled"  => true },
  { "name"     => "example_invalid_named_float",
    "kind"     => "float",
    "variants" => { "pi" => "a string", "e" => "a string", "phi" => "a string" },
    "value"    => "e",
    "enabled"  => true },
  { "name"     => "example_disabled_named_float",
    "kind"     => "float",
    "variants" => { "pi" => 3.141592653589793, "e" => 2.718281828459045, "phi" => 1.618033988749894 },
    "value"    => "e",
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

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ehowe/openfeature-ruby-sdk-contrib.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
