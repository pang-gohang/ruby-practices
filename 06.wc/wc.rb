# frozen_string_literal: true

def main
  options = {
    l: false,
    w: false,
    c: false
  }

  args = ARGV

  if args[0]&.start_with?('-')
    option = args.shift  # 最初の引数を取り出し、オプションとして扱う
    options[:l] = option.include?('l')
    options[:w] = option.include?('w')
    options[:c] = option.include?('c')
  else
    options[:l] = options[:w] = options[:c] = true
  end

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

def count_characters(content)
  content.length
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
  args.map do |arg|
    content = File.read(arg)
    filename = arg
    output = []
    output.push(count_lines(content)) if options[:l]
    output.push(count_words(content)) if options[:w]
    output.push(count_characters(content)) if options[:c]
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
  output.push(count_characters(content)) if options[:c]
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
