# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenFeature::SDK::Contrib::Providers::HttpProvider do
  let(:uri) { URI("http://some_url/flags") }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:deep_keys) { [] }

  before do
    allow(Faraday).to receive(:new).and_return(conn)

    stubs.get(uri.path) do
      [
        200,
        { 'Content-Type': file_format == :yaml ? 'application/yaml' : 'application/json' },
        flags
      ]
    end
  end

  shared_examples_for "url tests" do |ctx|
    let(:instance) { described_class.new(source: uri.to_s, format: file_format, deep_keys: deep_keys) }

    context "with boolean values #{ctx}" do
      it_behaves_like "reading the value", :fetch_boolean_value, "example_boolean", true

      it_behaves_like "returning nil", :fetch_boolean_value, "not_a_value"
      it_behaves_like "returning nil", :fetch_boolean_value, "example_disabled_boolean"

      it_behaves_like "returning the default value", :fetch_boolean_value, "not_a_value", true
      it_behaves_like "returning the default value", :fetch_boolean_value, "example_disabled_boolean", true

      it_behaves_like "raising an invalid type error", :fetch_boolean_value, "example_invalid_boolean"
      it_behaves_like "raising an invalid type error", :fetch_boolean_value, "not_a_value", "a string"

      it_behaves_like "reading from the cache", :fetch_boolean_value, "example_boolean", true
    end

    context "with string values #{ctx}" do
      it_behaves_like "reading the value", :fetch_string_value, "example_named_string", "medium"

      it_behaves_like "returning nil", :fetch_string_value, "not_a_value"
      it_behaves_like "returning nil", :fetch_string_value, "example_disabled_named_string"

      it_behaves_like "returning the default value", :fetch_string_value, "not_a_value", "medium"
      it_behaves_like "returning the default value", :fetch_string_value, "example_disabled_named_string", "medium"

      it_behaves_like "raising an invalid type error", :fetch_string_value, "example_invalid_named_string"
      it_behaves_like "raising an invalid type error", :fetch_string_value, "not_a_value", true

      it_behaves_like "reading from the cache", :fetch_string_value, "example_named_string", "medium" do
        before do
          expect(conn).not_to receive(:get)
        end
      end
    end

    context "with number values #{ctx}" do
      it_behaves_like "reading the value", :fetch_number_value, "example_named_number", 128

      it_behaves_like "returning nil", :fetch_number_value, "not_a_value"
      it_behaves_like "returning nil", :fetch_number_value, "example_disabled_named_number"

      it_behaves_like "returning the default value", :fetch_number_value, "not_a_value", 128
      it_behaves_like "returning the default value", :fetch_number_value, "example_disabled_named_number", 128

      it_behaves_like "raising an invalid type error", :fetch_number_value, "example_invalid_named_number"
      it_behaves_like "raising an invalid type error", :fetch_number_value, "not_a_value", true

      it_behaves_like "reading from the cache", :fetch_number_value, "example_named_number", 128
    end

    context "with float values #{ctx}" do
      it_behaves_like "reading the value", :fetch_float_value, "example_named_float", 2.718281828459045

      it_behaves_like "returning nil", :fetch_float_value, "not_a_value"
      it_behaves_like "returning nil", :fetch_float_value, "example_disabled_named_float"

      it_behaves_like "returning the default value", :fetch_float_value, "not_a_value", 2.718281828459045
      it_behaves_like "returning the default value", :fetch_float_value, "example_disabled_named_float", 2.718281828459045

      it_behaves_like "raising an invalid type error", :fetch_float_value, "example_invalid_named_float"
      it_behaves_like "raising an invalid type error", :fetch_float_value, "not_a_value", true

      it_behaves_like "reading from the cache", :fetch_float_value, "example_named_float", 2.718281828459045
    end
  end

  it_behaves_like "url tests", "for yaml" do
    include_context "with yaml feature flags"

    let(:file_format) { :yaml }
    let(:raw) { raw_flags }
  end

  it_behaves_like "url tests", "for json" do
    include_context "with json feature flags"

    let(:file_format) { :json }
    let(:raw) { raw_flags }
  end

  it_behaves_like "url tests", "for deeply nested yaml" do
    include_context "with deeply nested yaml feature flags"

    let(:deep_keys) { %w[deeply nested] }
    let(:file_format) { :yaml }
    let(:raw) { deeply_nested_raw_flags }
  end

  it_behaves_like "url tests", "for deeply nested json" do
    include_context "with deeply nested json feature flags"

    let(:deep_keys) { %w[deeply nested] }
    let(:file_format) { :json }
    let(:raw) { deeply_nested_raw_flags }
  end
end
