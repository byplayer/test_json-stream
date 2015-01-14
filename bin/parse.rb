require 'bundler/setup'
require 'json/stream'

# JSON streaming parser sample
class MyParser
  INDENT_WORD = '  '
  
  def initialize
    my = self
    @parser = JSON::Stream::Parser.new do
      start_document { my.start_document }
      end_document   { my.end_document }
      start_object   { my.start_object }
      end_object     { my.end_object }
      start_array    { my.start_array }
      end_array      { my.end_array }
      key            { |k| my.key(k) }
      value          { |v| my.value(v) }
    end

    @indent = 0
  end

  def <<(data)
    @parser << data
  end

  def start_document
    with_indent 'start document'
    @indent += 1
  end

  def end_document
    with_indent 'end document'
    @indent -= 1
  end

  def start_object
    with_indent 'start object'
    @indent += 1
  end

  def end_object
    with_indent 'end object'
    @indent -= 1
  end

  def start_array
    with_indent 'start array'
    @indent += 1
  end

  def end_array
    with_indent 'end array'
    @indent -= 1
  end

  def key(k)
    with_indent "key: #{k}"
  end

  def value(v)
    with_indent "value: #{v}"
  end

  def with_indent(msg)
    print(INDENT_WORD * @indent)
    puts msg
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
