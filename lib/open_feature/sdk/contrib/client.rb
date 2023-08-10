# frozen_string_literal: true

require "openfeature/sdk/client"

module OpenFeature
  module SDK
    module Contrib
      class Client < OpenFeature::SDK::Client
        def all_flags
          @provider.read_all_values_with_cache
        end
      end
    end
  end
end
