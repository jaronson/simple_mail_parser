module Email
  class Parser
    attr_accessor :content
    attr_reader :message

    def self.message_from_file(file)
      message_from_string(file.read())
    end

    def self.message_from_string(email)
      parser = Parser.new
      parser.content = email
      parser.parse
    end

    def initialize
      @content = ''
    end

    def parse
      parse_part(@content)
    end

    
    protected
    def parse_header_block(content)
      result = {}
      if content.nil? || content.empty?
        return result
      end
      
      header_arr = content.split("\r\n")
      current_key = false
      extra = false
      
      header_arr.each_with_index do |v,i|
        tuple = header_arr[i].split(":", 2)
        if v =~ /^\s+/ || tuple.size < 2
          if current_key and v =~ /^\s+/
            result[current_key] += ' ' + v.strip
          else
            puts "Invalid header #{v}"
          end
          next
        end
      
        key = tuple[0].downcase
        current_key = key
        result[key] = tuple[1] 
      end

      result.each do |k, v|
        result[k] = parse_header(v)
      end
      result
    end

    def parse_header(header)
      result = HeaderTuple.new
      extra = false

      header = header.split(";")
      result.value = header.shift.strip

      header.each_with_index do |h, i|
        next if h == ''

        extra = true
        tuple = header[i].split("=", 2)
        h_name = tuple[0].strip
        if tuple.size == 2
          result.opts[h_name] = tuple[1].strip.gsub(/^"/, '').gsub(/"$/, '')
        else
          result.opts[h_name] = nil
        end
      end
      return result
    end

    def parse_body_block(content, headers)
      if !headers['content-type'] and !headers['content-type']['value']
        headers['content-type'] = HeaderTuple.new( :value => 'text/plain' )
      end
      case headers['content-type'].value
        when 'text/plain', 'text/html'
          return content
        when 'multipart/mixed', 'multipart/alternative'
          content = parse_multitype(content, headers['content-type'].opts['boundary'])
        when 'image/png', 'image/jpg'
          content = content.gsub(/\r\n/m, '')
      end
      return content
    end

    def parse_multitype(content, boundary)
      unless content and boundary
        return false
      end

      if content.slice(0, boundary.length + 2) != ("--#{boundary}")
        puts "Invalid multipart"
        return false
      end

      content = content.split("--#{boundary}\r\n").collect{|c| c unless c.nil? || c.empty? }.compact
      0.upto(content.size-1) do |i|
        content[i] = parse_part(content[i])
        content[i] = content[i].gsub("--#{boundary}", "")
      end
      return content
    end

    def parse_part(content)
      msg = Message.new
      content = content.split("\r\n\r\n", 2)
      msg.headers  = parse_header_block(content[0])
      if content.size == 2
        msg.body = parse_body_block(content[1], msg.headers)
      else
        msg.body = ''
      end
      return msg
    end
  end
end
