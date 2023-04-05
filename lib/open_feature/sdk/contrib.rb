# frozen_string_literal: true

require_relative "contrib/client"
require_relative "contrib/version"
require_relative "contrib/providers/common"
require_relative "contrib/providers/file_provider"

module OpenFeature
  module SDK
    module Contrib
      InvalidReturnValueError = Class.new(StandardError)
    end
  end
end
