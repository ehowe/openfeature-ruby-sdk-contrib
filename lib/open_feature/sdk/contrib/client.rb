# frozen_string_literal: true

require "openfeature/sdk/client"

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
      end
    end
  end
end
