require 'rack/handler'
require 'pronghorn'

module Rack
  module Handler
    module Pronghorn
      DEFAULT_OPTIONS = {
        :Host => '0.0.0.0',
        :Port => 8080,
        :Verbose => false
      }

      def self.run(app, options = {})
        options  = DEFAULT_OPTIONS.merge(options)

        if options[:Verbose]
          app = Rack::CommonLogger.new(app, STDOUT)
        end
        server = ::Pronghorn::Server.new(app)
        yield server if block_given?
        server.start(options[:Host], options[:Port])
      end

      def self.valid_options
        {
          "Host=HOST"       => "Hostname to listen on (default: localhost)",
          "Port=PORT"       => "Port to listen on (default: 8080)"
        }
      end
    end

    register :pronghorn, Pronghorn
  end
end
