require 'bundler/setup'
require 'json/stream'

# JSON streaming parser sample
class MyParser
  def initialize
    my = self
    @parser = JSON::Stream::Parser.new do
      start_document { my.start_document }
      end_document   { puts 'end document' }
      start_object   { puts 'start object' }
      end_object     { puts 'end object' }
      start_array    { puts 'start array' }
      end_array      { puts 'end array' }
      key            { |k| puts "key: #{k}" }
      value          { |v| puts "value: #{v}" }
    end
  end

  def <<(data)
    @parser << data
  end

  def start_document
    puts 'start document'
  end
end

def parse_file(path)
  puts "parse file:#{path}"

  parser = MyParser.new

  File.foreach(path) do |line|
    parser << line
  end
end

if ARGV.length == 1
  parse_file(ARGV[0])
else
  puts 'usage: parse.rb target_file'
end
