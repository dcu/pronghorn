module Pronghorn
  class Server

    attr_accessor :app

    attr_reader :host

    attr_reader :port

    def initialize(app, &block)
      @app = app
      @app = Rack::Builder.new(&block).to_app if block
      @connections = []
    end

    def start(host, port)
      @host = host
      @port = port
      starter = proc do
        @signature = EventMachine.start_server @host, @port, Connection, &method(:initialize_connection)
        @running = true
      end

      Signal.trap("INT")  { stop }
      Signal.trap("TERM") { stop }

      puts "Proghorn #{::Pronghorn::VERSION} starting..."
      puts "* Listening on http://#{@host}:#{@port}"

      EventMachine.error_handler{ |error|
        puts error.message
      }

      if EventMachine.reactor_running?
        starter.call
      else
        EventMachine.run(&starter)
      end
    end

    def stop
      puts "* Stopping server"
      return unless @running
      @running = false
      EventMachine.stop_server(@signature)
      EventMachine.stop if EventMachine.reactor_running?
    end

    def finish_connection(connection)
      @connections.delete(connection)
    end

    private
    def initialize_connection(connection)
      connection.app = @app
      connection.server = self
      @connections << connection
    end
  end
end
