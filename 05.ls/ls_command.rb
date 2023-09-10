# frozen_string_literal: true

require 'etc'

def file_names(options)
  glob_option = options[:a] ? File::FNM_DOTMATCH : 0
  names = Dir.glob('*', glob_option)
  options[:r] ? names.reverse : names
end

def multi_column_vertical_sort(options)
  names = file_names(options)
  max_name_length = names.map(&:length).max || 0

  num_columns = 3
  num_rows = (names.size + num_columns - 1) / num_columns

  num_rows.times do |row_index|
    num_columns.times do |col_index|
      file_index = row_index + col_index * num_rows
      file_name = names[file_index]
      print file_name&.ljust(max_name_length + 7)
    end
    puts
  end
end

# 以下-l optionで使用
def one_stat(file_path = '.')
  File.stat(file_path)
end

def stat_permission(stat)
  permission_map = {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }

  file_type = stat.directory? ? 'd' : '-'
  permission = stat.mode.to_s(8)[-3, 3].chars.map(&:to_i).map { |p| permission_map[p] }.join('')
  file_type + permission
end

def count_link(stat)
  stat.nlink
end

def user_id(stat)
  Etc.getpwuid(stat.uid).name
end

def group_id(stat)
  Etc.getgrgid(stat.gid).name
end

def calc_size(stat)
  stat.size
end

def mtime(stat)
  stat.mtime.strftime('%_m %_d %H:%M')
end

def file_name(file_path = '.')
  File.basename(file_path)
end

def total_block_size(names)
  names.sum do |name|
    stat = one_stat(name)
    stat.directory? ? 0 : (calc_size(stat) / 512.00 / 8).ceil * 8
  end
end

def one_ls_l_command(stat, file_name, adjust = {
  permissions: 8,
  hard_links: 2,
  owner: 8,
  group: 5,
  size: 7
})
  permissions = stat_permission(stat)
  hard_links = count_link(stat)
  owner = user_id(stat)
  group = group_id(stat)
  size = calc_size(stat)
  m_time = mtime(stat)
  name = file_name(file_name)

  output = [
    permissions.rjust(adjust[:permissions]),
    hard_links.to_s.rjust(adjust[:hard_links]),
    owner.ljust(adjust[:owner]),
    group.ljust(adjust[:group]),
    size.to_s.rjust(adjust[:size]),
    m_time.rjust(11),
    name
  ].join(' ')

  puts output
end

def long_format(options)
  names = file_names(options)
  total = total_block_size(names)
  puts "total #{total}"
  adjust_space = adjust_space(names)
  names.each do |name|
    stat = one_stat(name)
    one_ls_l_command(stat, name, adjust_space)
  end
end

def adjust_space(file_names)
  max_values = {
    permissions: 0,
    hard_links: 0,
    owner: 0,
    group: 0,
    size: 0
  }

  file_names.each do |name|
    stat = File.stat(name)
    max_values[:permissions] = [max_values[:permissions], stat_permission(stat).length].max
    max_values[:hard_links] = [max_values[:hard_links], count_link(stat).to_s.length].max
    max_values[:owner] = [max_values[:owner], user_id(stat).length].max
    max_values[:group] = [max_values[:group], group_id(stat).length].max
    max_values[:size] = [max_values[:size], calc_size(stat).to_s.length].max
  end
  max_values[:hard_links] += 1
  max_values[:owner] += 1
  max_values[:group] += 1
  max_values
end

def main
  options = {
    l: false,
    a: false,
    r: false
  }
  option = ARGV.join('')
  options[:l] = option.include?('l')
  options[:a] = option.include?('a')
  options[:r] = option.include?('r')

  options[:l] ? long_format(options) : multi_column_vertical_sort(options)
end

main
