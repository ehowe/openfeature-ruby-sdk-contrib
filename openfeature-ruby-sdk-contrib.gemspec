# frozen_string_literal: true

require_relative "lib/open_feature/sdk/contrib/version"

Gem::Specification.new do |spec|
  spec.name    = "openfeature-ruby-sdk-contrib"
  spec.version = OpenFeature::SDK::Contrib::VERSION
  spec.authors = ["Eugene Howe"]
  spec.email   = ["eugene.howe@protonmail.com"]

  spec.summary               = "Providers and Hooks for the OpenFeature Ruby SDK"
  spec.homepage              = "https://github.com/ehowe/openfeature-ruby-sdk-contrib"
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "openfeature-sdk", "~> 0.1"

  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "rubocop", "~> 1.48"
  spec.add_development_dependency "rubocop-performance", "~> 1.15"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.19"
  spec.add_development_dependency "standard", "~> 0.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
