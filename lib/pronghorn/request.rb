module Pronghorn
  class Request

    attr_reader :parser

    attr_reader :env

    PROTO_ENV = {
      "SERVER_SOFTWARE".freeze   => "PragHorn #{::Pronghorn::VERSION}".freeze,
      "SERVER_NAME".freeze       => "localhost",
      "SERVER_PROTOCOL".freeze   => "HTTP/1.1",
      "HTTP_VERSION".freeze      => "HTTP/1.1",
      "SCRIPT_NAME".freeze       => "",
      "QUERY_STRING".freeze      => "",
      "GATEWAY_INTERFACE"        => "CGI/1.2",

      "rack.url_scheme".freeze   => "http",
      "rack.errors".freeze       => STDERR,
      "rack.multithread".freeze  => false,
      "rack.multiprocess".freeze => false,
      "rack.run_once".freeze     => false,
      "rack.version".freeze      => Rack::VERSION
    }

    def initialize
      @parser = Http::Parser.new
      @parser.on_body = proc do |chunk|
        @body << chunk
      end
      @parser.on_headers_complete = proc do |headers|
        @headers = headers
      end

      initial_body = ''
      initial_body.encode!(Encoding::ASCII_8BIT) if initial_body.respond_to?(:encode!)
      @body = StringIO.new(initial_body.dup)
    end

    def set_environment(env_vars = {})
      @env = PROTO_ENV.dup
      @env.merge!({
        "REQUEST_METHOD".freeze  => @parser.http_method,
        "REQUEST_URI".freeze     => @parser.request_url,
        "REQUEST_PATH".freeze    => @parser.request_path,
        "QUERY_STRING".freeze    => @parser.query_string,
        "PATH_INFO".freeze       => @parser.request_path,
        "rack.input".freeze      => @body
      })
      @env["FRAGMENT"] = @parser.fragment if @parser.fragment
      if @headers.key?("Content-Length")
        @env["CONTENT_LENGTH"] = @headers.delete("Content-Length").to_i
      end
      if @headers.key?("Content-Type")
        @env["CONTENT_TYPE"] = @headers.delete("Content-Type")
      end
      @headers.each{|k, v| @env["HTTP_#{k.upcase.gsub('-','_')}"] = v}
      @env.merge!(env_vars)
    end
  end
end
