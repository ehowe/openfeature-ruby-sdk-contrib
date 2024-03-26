# frozen_string_literal: true

require "open_feature/sdk/client"

module OpenFeature
  module SDK
    module Contrib
      class Client < OpenFeature::SDK::Client
        def all_flags
          @provider.read_all_values_with_cache
        end

        def fetch_float_value(flag_key:, default_value:, evaluation_context: nil)
          result = @provider.fetch_float_value(flag_key: flag_key, default_value: default_value, evaluation_context: evaluation_context)
          result.value
        end

        def fetch_raw_flag(flag_key:)
          @provider.fetch_raw_key(flag_key: flag_key)
        end
      end
    end
  end
end
