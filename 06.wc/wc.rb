# frozen_string_literal: true

require 'optparse'

def main
  options = OptionParser.new.getopts(ARGV, 'lwc')
  options.transform_values! { true } if options.values.all?(false) # オプション未指定の場合

  output_data = []
  if ARGV.empty? # 標準入力の場合
    output_data.push(calc_one_document($stdin.read, options))
  elsif ARGV.size == 1 # ファイルが１つの場合
    args = ARGV.join('')
    content = File.read(args)
    output_data.push(calc_one_document(content, options, args))
  else # ファイルが複数の場合
    output_data = calc_many_documents(ARGV, options)
  end
  format_string = create_output_format(output_data[-1], options)
  output_data.each do |data|
    output_line(data, format_string)
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

def calc_one_document(string, options, filename = nil)
  output = {}
  output['l'] = count_lines(string) if options['l']
  output['w'] = count_words(string) if options['w']
  output['c'] = calc_bytesize(string) if options['c']
  output['filename'] = filename if filename
  output
end

def output_line(document_infomation, format_string)
  output = {
    lines: document_infomation['l'] || nil,
    words: document_infomation['w'] || nil,
    chars: document_infomation['c'] || nil,
    name: document_infomation['filename'] || nil
  }
  printf format(format_string, output)
  puts
end

def create_output_format(output_data, options)
  line_format = []
  line_length = output_data['l'].to_s.length <= 8 ? 8 : output_data['l'].to_s.length + 1
  word_length = output_data['w'].to_s.length <= 8 ? 8 : output_data['w'].to_s.length + 1
  char_length = output_data['c'].to_s.length <= 8 ? 8 : output_data['c'].to_s.length + 1

  output_format = {
    'l' => "%<lines>#{line_length}d",
    'w' => "%<words>#{word_length}d",
    'c' => "%<chars>#{char_length}d",
    'name' => ' %<name>s'
  }

  options.each do |key, value|
    line_format.push(output_format[key]) if value
  end
  line_format.push(output_format['name'])
  line_format.join('')
end

def calc_many_documents(args, options)
  output = []
  total = { 'l' => 0, 'w' => 0, 'c' => 0, 'filename' => 'total' }
  args.each do |arg|
    content = File.read(arg)
    subtotal = calc_one_document(content, options, arg)
    output.push(subtotal)
    total['l'] += subtotal['l'] || 0
    total['w'] += subtotal['w'] || 0
    total['c'] += subtotal['c'] || 0
  end
  output.push(total)
  output
end

main
