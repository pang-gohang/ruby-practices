# frozen_string_literal: true

require 'optparse'

def main
  options = OptionParser.new.getopts(ARGV, 'lwc')
  args = ARGV
  option_count = options.values.count(true)

  if args.empty?
    with_stdin($stdin.read, options, option_count)
  else
    with_file_path(args, options, option_count)
  end
end

def count_lines(content)
  content.lines.count
end

def count_words(content)
  content.split(/\s+/).count
end

def calc_bytesize(content)
  content.bytesize
end

def output_one_line_with_name(option_count, output, name)
  case option_count
  when 3
    printf("%<lines>8d%<words>8d%<chars>8d %<filename>s\n", lines: output[0], words: output[1], chars: output[2], filename: name)
  when 2
    printf("%<lines>8d%<words>8d %<filename>s\n", lines: output[0], words: output[1], filename: name)
  when 1
    printf("%<lines>8d %<filename>s\n", lines: output[0], filename: name)
  else
    puts 'エラーです。'
    exit
  end
end

def with_file_path(args, options, option_count)
  total = [0, 0, 0]
  args.each do |arg|
    content = File.read(arg)
    filename = arg
    output = []
    output.push(count_lines(content)) if options['l']
    output.push(count_words(content)) if options['w']
    output.push(calc_bytesize(content)) if options['c']
    output.map.with_index do |count, index|
      total[index] += count
    end
    output_one_line_with_name(option_count, output, filename)
  end
  output_one_line_with_name(option_count, total, 'total') if args.size > 1
end

def with_stdin(content, options, option_count)
  output = []
  output.push(count_lines(content)) if options[:l]
  output.push(count_words(content)) if options[:w]
  output.push(calc_bytesize(content)) if options[:c]
  output_one_line_without_name(option_count, output)
end

def output_one_line_without_name(option_count, output)
  case option_count
  when 3
    printf("%<lines>8d%<words>8d%<chars>8d\n", lines: output[0], words: output[1], chars: output[2])
  when 2
    printf("%<lines>8d%<words>8d\n", lines: output[0], words: output[1])
  when 1
    printf("%<lines>8d\n", lines: output[0])
  else
    puts 'エラーです。'
    exit
  end
end

main
