# simple_mail_parser

## Usage

Use the class methods to parse emails and return an Simplemail::Message object:

    Simplemail::Parser.message_from_string(content) 
    Simplemail::Parser.message_from_file(File.open('email.eml'))

Or, take the long approach and create a new parser

    parser = Simplemail::Parser.new
    parser.content = File.read('email.eml')
    msg = parser.parse

## Contributing to simple_mail_parser
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Josh Aronson. See LICENSE.txt for
further details.
