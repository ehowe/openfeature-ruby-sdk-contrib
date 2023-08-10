# frozen_string_literal: true

RSpec.shared_context "with raw feature flags" do
  let(:raw_flags) do
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
        "variant" => "medium",
        "enabled" => false },
      { "name"     => "example_named_number",
        "kind"     => "number",
        "variants" => { "small" => 8, "medium" => 128, "large" => 2048 },
        "variant"  => "medium",
        "enabled"  => true },
      { "name"     => "example_invalid_named_number",
        "kind"     => "number",
        "variants" => { "small" => "a string", "medium" => "a string", "large" => "a string" },
        "variant"  => "medium",
        "enabled"  => true },
      { "name"     => "example_disabled_named_number",
        "kind"     => "number",
        "variants" => { "small" => 8, "medium" => 128, "large" => 2048 },
        "variant"  => "medium",
        "enabled"  => false },
      { "name"     => "example_named_float",
        "kind"     => "float",
        "variants" => { "pi" => 3.141592653589793, "e" => 2.718281828459045, "phi" => 1.618033988749894 },
        "variant"  => "e",
        "enabled"  => true },
      { "name"     => "example_invalid_named_float",
        "kind"     => "float",
        "variants" => { "pi" => "a string", "e" => "a string", "phi" => "a string" },
        "variant"  => "e",
        "enabled"  => true },
      { "name"     => "example_disabled_named_float",
        "kind"     => "float",
        "variants" => { "pi" => 3.141592653589793, "e" => 2.718281828459045, "phi" => 1.618033988749894 },
        "variant"  => "e",
        "enabled"  => false }
    ]
  end
end

RSpec.shared_context "with deeply nested raw feature flags" do
  include_context "with raw feature flags"

  let(:deeply_nested_raw_flags) do
    {
      "deeply" => {
        "nested" => raw_flags
      }
    }
  end
end

RSpec.shared_context "with yaml feature flags" do
  include_context "with raw feature flags"

  let(:flags) { YAML.dump(raw_flags) }
end

RSpec.shared_context "with json feature flags" do
  include_context "with raw feature flags"
  let(:flags) { JSON.dump(raw_flags) }
end

RSpec.shared_context "with deeply nested yaml feature flags" do
  include_context "with deeply nested raw feature flags"

  let(:flags) { YAML.dump(deeply_nested_raw_flags) }
end

RSpec.shared_context "with deeply nested json feature flags" do
  include_context "with deeply nested raw feature flags"
  let(:flags) { JSON.dump(deeply_nested_raw_flags) }
end
