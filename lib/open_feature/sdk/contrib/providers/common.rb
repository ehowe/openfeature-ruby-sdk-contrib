module OpenFeature
  module SDK
    module Contrib
      module Providers
        module Common
          ResolutionDetails = Struct.new(
            :enabled,
            :error_code,
            :error_message,
            :reason,
            :value,
            :variant,
            keyword_init: true
          )

          # @return [Hash]
          attr_reader :extra_options

          # @return [String]
          attr_reader :source

          # @return [Metadata]
          attr_reader :metadata

          # @return [Symbol]
          attr_reader :format

          # @return [Array<String>]
          attr_reader :deep_keys

          # @return [Integer]
          attr_accessor :cache_duration

          # @return [#call<String>]
          attr_reader :custom_parser

          # Initialize the provider
          #
          # @param source [String] a path to the file, will be evaluated with expand_path
          # @param file_format [:json, :yaml, :custom] format of the file. Can be one of [:yaml, :json]
          # @param deep_keys [Array<String>] heirarchy of keys to traverse in the parsed config to get to your feature
          #   flags Array. Defaults to <tt>[]</tt> which will evaluate to the root of the file
          # @param cache_duration [Integer, Float::INFINITY] how long (in seconds) to cache the file contents before reading the file from disk again.
          #   If Float::INFINITY is passed, the file will not be reread.
          # @param custom_parser [#call<String>] If your file is not JSON or YAML you can pass a custom parser as a lambda here which will be used to parse the file instead.
          #   Even if your file is YAML or JSON you can pass this option if you opt to use a parser other than <tt>YAML.load</tt> or <tt>JSON.parse</tt>.
          #   The raw file contents will be passed to this Proc.
          def initialize(source:, format: :yaml, deep_keys: [], cache_duration: Float::INFINITY, custom_parser: nil, extra_options: {})
            @source         = source
            @format         = format
            @deep_keys      = deep_keys
            @cache_duration = cache_duration
            @extra_options  = extra_options
            @metadata       = Metadata.new(name: self.class::NAME).freeze

            if format == :yaml && !custom_parser
              require "yaml"
            elsif format == :json && !custom_parser
              require "json"
            end
          end

          # Returns a boolean value for the key specified
          #
          # @param flag_key [String] flag key to search for
          # @param default_value [Boolean] optional default value if one is not found in the file
          #
          # @return [Boolean, NilClass]
          def fetch_boolean_value(flag_key:, default_value: nil, evaluation_context: nil)
            source_value = read_value_with_cache(flag_key: flag_key, type: "boolean")

            assert_type(value: source_value, default_value: default_value, return_types: [TrueClass, FalseClass])
          end

          # Returns a String value for the key specified
          #
          # @param flag_key [String] flag key to search for
          # @param default_value [String] optional default value if one is not found in the file
          #
          # @return [String, NilClass]
          def fetch_string_value(flag_key:, default_value: nil, evaluation_context: nil)
            source_value = read_value_with_cache(flag_key: flag_key, type: "string")

            assert_type(value: source_value, default_value: default_value, return_types: [String])
          end

          # Returns an integer value for the key specified
          #
          # @param flag_key [String] flag key to search for
          # @param default_value [Integer] optional default value if one is not found in the file
          #
          # @return [Integer, NilClass]
          def fetch_number_value(flag_key:, default_value: nil, evaluation_context: nil)
            source_value = read_value_with_cache(flag_key: flag_key, type: "number")

            assert_type(value: source_value, default_value: default_value, return_types: [Integer])
          end

          # Returns a Float value for the key specified
          #
          # @param flag_key [String] flag key to search for
          # @param default_value [Float] optional default value if one is not found in the file
          #
          # @return [Float, nil]
          def fetch_float_value(flag_key:, default_value: nil, evaluation_context: nil)
            source_value = read_value_with_cache(flag_key: flag_key, type: "float")

            assert_type(value: source_value, default_value: default_value, return_types: [Float])
          end

          # Returns a hash value for the key specified
          #
          # @param flag_key [String] flag key to search for
          # @param default_value [Hash] optional default value if one is not found in the file
          #
          # @return [Hash, NilClass]
          def fetch_object_value(flag_key:, default_value: nil, evaluation_context: nil)
            source_value = read_value_with_cache(flag_key: flag_key, type: "float")

            assert_type(value: source_value, default_value: default_value, return_types: [Hash])
          end

          def read_all_values_with_cache
            now = Time.now.to_i

            read_from_cache = if !@flag_contents
                                false
                              elsif !@last_cache
                                false
                              elsif cache_duration == Float::INFINITY
                                true
                              else
                                now - @last_cache < cache_duration
                              end

            unless read_from_cache
              read_and_parse_flags
              @last_cache = Time.now.to_i
            end

            (deep_keys.empty? ? @flag_contents : @flag_contents.dig(*deep_keys) || [])
          end

          private

          # Returns a value for the requested flag_key
          #
          # @param flag_key [String] requested flag key
          # @param type ["boolean", "number", "float", "string"]
          def read_value_with_cache(flag_key:, type:)
            read_all_values_with_cache.detect { |f| f["kind"] == type && f["name"] == flag_key }
          end

          def read_and_parse_flags
            raise NotImplmentedError
          end

          def assert_type(value:, default_value:, return_types:)
            actual_value = if value && value["enabled"]
                             value
                           elsif defined?(default_value)
                             { "value" => default_value, "enabled" => true }
                           end

            return ResolutionDetails.new(value: nil) if actual_value.nil?

            return_types  = Array(return_types) + [NilClass]
            variant_value = actual_value["variants"] ? actual_value["variants"][actual_value["value"]] : actual_value["value"]

            raise OpenFeature::SDK::Contrib::InvalidReturnValueError, "Invalid flag value found: #{variant_value} is not in #{return_types.join(', ')}" unless return_types.include?(variant_value.class)

            ResolutionDetails.new(value: variant_value, enabled: actual_value["enabled"], variant: actual_value["variant"])
          end
        end
      end
    end
  end
end
