require 'helper'

class TestSimpleMailParser < Test::Unit::TestCase
  context "email parser" do
    setup do
      @parser = Email::Parser.new
      @email  = email_fixture('email')
    end

    should "parse a multipart email" do
      @parser.content = @email
      message = @parser.parse

      assert message.is_a?(Email::Message)
      assert message.headers.is_a?(Hash)

      assert message.to == 'testymctestervich@gmail.com'
      assert message.from == 'jparonson@gmail.com'
      assert message.subject == 'Fwd: Test message'
      assert message.headers['content-type'].value == 'multipart/alternative'
      
      assert message.body.is_a?(Array)
      assert message.body.size == 2

      message.body.each do |part|
        assert part.is_a?(Email::Message)
        assert ['text/plain', 'text/html'].include?(part.send("content-type"))
        assert part.body.is_a?(String)
      end
    end
  end
end
