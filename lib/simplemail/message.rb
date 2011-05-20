module Simplemail
  class Message
    attr_accessor :headers, :body

    def subject
      @headers['subject'].value rescue nil
    end

    def from(opts={})
      get_header_address('from', opts) 
    end

    def to(opts={})
      get_header_address('to', opts)
    end

    def to_json(*args)
      { :headers => self.headers, :body => self.body }.to_json
    end

    def method_missing(*args)
      @headers[args.first.to_s].value rescue nil
    end

    protected
    def get_header_address(key, opts)
      begin
        addr = @headers[key].value
      rescue NoMethodError => e
        return nil
      end
      addr = parse_address_line(addr) if addr =~ />$/
      addr
    end

    def parse_address_line(line)
      matches = line.scan(/<([^,\s]+)>/).flatten
      return nil if matches.size == 0
      matches.size == 1 ? matches.first : matches
    end
  end
end
