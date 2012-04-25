module Pronghorn
  class Connection < EventMachine::Connection

    attr_accessor :request

    attr_accessor :response

    attr_accessor :app

    attr_accessor :server

    def post_init
      @request  = Request.new
      @response = Response.new
      @request.parser.on_message_complete = method(:process)
    end

    def receive_data(data)
      @request.parser << data
    end

    def process
      send_response(process_request)
    end

    def process_request
      @request.set_environment({
        "REMOTE_ADDR" => remote_address,
        "SERVER_PORT" => @server.port.to_s
      })
      response = @app.call(@request.env)
    end

    def send_response(result)
      return unless result
      result = result.to_a
      @response.status, @response.headers, @response.body = *result
      @response.each do |chunk|
        send_data chunk
      end
      @response.close
      post_init
    end

    def unbind
      @server.finish_connection(self)
    end

    def remote_address
      Socket.unpack_sockaddr_in(get_peername)[1]
    rescue
      nil
    end
  end
end
