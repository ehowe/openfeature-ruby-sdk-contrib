# frozen_string_literal: true

require "open_feature/sdk"
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

          NAME = "Http Provider"

          def read_and_parse_flags
            options                 = extra_options.clone
            headers                 = options.fetch(:headers, {})
            uri                     = URI(source)
            base_url                = "#{uri.scheme}://#{uri.host}:#{uri.port}"
            authentication_strategy = options.delete(:authentication_strategy)
            logger                  = options.delete(:logger)

            if format == :yaml
              headers["Content-Type"] ||= "application/yaml"
            elsif format == :json
              headers["Content-Type"] ||= "application/json"
            end

            client = Faraday.new(url: base_url, **options, headers: headers) do |conn|
              conn.request(*authentication_strategy) if authentication_strategy
              conn.response(:logger, logger) if logger
            end

            res = client.get(uri.request_uri)

            return custom_parser.call(res.body) if custom_parser

            begin
              @flag_contents = if format == :yaml
                                 YAML.safe_load(res.body)
                               else
                                 JSON.parse(res.body)
                               end
            rescue StandardError
              @flag_contents = {}
            end

            @flag_contents
          end
        end
      end
    end
  end
end
