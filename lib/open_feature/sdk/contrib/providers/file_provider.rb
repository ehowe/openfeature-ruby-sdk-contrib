require "openfeature/sdk"

module OpenFeature
  module SDK
    module Contrib
      module Providers
        # Read feature flags from a file.
        #
        # To use <tt>FileProvider</tt>, it can be set during the configuration of the SDK
        #
        #   OpenFeature::SDK.configure do |config|
        #     config.provider = OpenFeature::SDK::Contrib::FileProvider.new(file_path: "/path/to/file")
        #   end
        #
        # Within the <tt>FileProvider</tt>, the following methods exist
        #
        # * <tt>fetch_boolean_value</tt> - Retrieve feature flag boolean value from the file
        #
        # * <tt>fetch_string_value</tt> - Retrieve feature flag string value from the file
        #
        # * <tt>fetch_number_value</tt> - Retrieve feature flag number value from the file
        #
        # * <tt>fetch_object_value</tt> - Retrieve feature flag object value from the file
        class FileProvider
          include Common

          NAME = "File Provider".freeze

          def read_and_parse_flags
            file_contents = File.read(File.expand_path(source))

            return custom_parser.call(file_contents) if custom_parser

            @flag_contents = if format == :yaml
                               YAML.safe_load(file_contents)
                             else
                               JSON.parse(file_contents)
                             end

            @flag_contents
          end
        end
      end
    end
  end
end
