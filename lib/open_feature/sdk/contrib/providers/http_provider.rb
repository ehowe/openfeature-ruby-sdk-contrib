require "openfeature/sdk"
require "faraday"

module OpenFeature
  module SDK
    module Contrib
      module Providers
        # Read feature flags from a URL.
        #
        # To use <tt>FileProvider</tt>, it can be set during the configuration of the SDK. The `extra_options` hash can be anything passed to `Faraday.new``
        #
        #   OpenFeature::SDK.configure do |config|
        #     config.provider = OpenFeature::SDK::Contrib::Providers::HttpProvider.new(source: http://path_to_flags, extra_options: { headers: { Auhorization: "token" }})
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
        class HttpProvider
          include Common

          NAME = "Http Provider".freeze

          def read_and_parse_flags
            headers = extra_options.fetch(:headers, {})
            uri = URI(source)
            base_url = "#{uri.scheme}://#{uri.host}:#{uri.port}"

            if format == :yaml
              headers["Content-Type"] ||= "application/yaml"
            elsif format == :json
              headers["Content-Type"] ||= "application/json"
            end

            client = Faraday.new(url: base_url, **extra_options, headers: headers)
            res = client.get(uri.request_uri)

            return custom_parser.call(res.body) if custom_parser

            begin
              @flag_contents = if format == :yaml
                                 YAML.safe_load(res.body)
                               else
                                 JSON.parse(res.body)
                               end
            rescue
              @flag_contents = {}
            end

            @flag_contents
          end
        end
      end
    end
  end
end