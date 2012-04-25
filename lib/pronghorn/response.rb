module Pronghorn
  class Response

    attr_accessor :headers

    attr_accessor :body

    attr_accessor :status

    def initialize(status = 200, headers = {"Content-Type" => "text/plain"}, body = [""])
      @status = status
      @headers = headers
      @body = body
    end

    def head
      lines = []
      lines << "HTTP/1.1 #{@status}\r\n"
      lines += generate_header_lines(@headers)
      lines << "\r\n"
      lines.join
    end

    def close
      @body.close if @body.respond_to?(:close)
    end

    def each
      yield head
      @body.each { |chunk| yield chunk }
    end

    private

    def generate_header_lines(headers)
      output = []
      headers.each do |header, value|
        output << "#{header}: #{value}\r\n"
      end
      output
    end

  end
end
