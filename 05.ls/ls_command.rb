# frozen_string_literal: true

require 'etc'

def file_names
  Dir.glob('*')
end

def ls_command
  names = file_names
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

def stat_permission(file_path = '.')
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

  stat = one_stat(file_path)
  file_type = stat.directory? ? 'd' : '-'
  permission = stat.mode.to_s(8)[-3, 3].chars.map(&:to_i).map { |p| permission_map[p] }.join('')
  file_type + permission
end

def count_link(file_path = '.')
  stat = one_stat(file_path)
  stat.nlink
end

def user_id(file_path = '.')
  stat = one_stat(file_path)
  Etc.getpwuid(stat.uid).name
end

def group_id(file_path = '.')
  stat = one_stat(file_path)
  Etc.getgrgid(stat.gid).name
end

def calc_size(file_path = '.')
  stat = one_stat(file_path)
  stat.size
end

def mtime(file_path = '.')
  stat = one_stat(file_path)
  stat.mtime.strftime('%_m %_d %H:%M')
end

def file_name(file_path = '.')
  File.basename(file_path)
end

def total_block_size(names)
  total = 0
  names.map do |name|
    total += one_stat(name).directory? ? 0 : (calc_size(name) / 512.00 / 8).ceil * 8
  end
  total
end

def one_ls_l_command(file_path = '.', adjust = [8, 2, 8, 5, 7])
  permissions = stat_permission(file_path)
  hard_links = count_link(file_path)
  owner = user_id(file_path)
  group = group_id(file_path)
  size = calc_size(file_path)
  m_time = mtime(file_path)
  name = file_name(file_path)

  output = "#{permissions.rjust(adjust[0])} " \
  "#{hard_links.to_s.rjust(adjust[1])} " \
  "#{owner.ljust(adjust[2])} " \
  "#{group.ljust(adjust[3])} " \
  "#{size.to_s.rjust(adjust[4])} " \
  "#{m_time.rjust(11)} " \
  "#{name}"
  puts output
end

def ls_command_l_option
  names = file_names
  total = total_block_size(names)
  puts "total #{total}"
  adjust_space = adjust_space(names)
  names.each do |stat|
    one_ls_l_command(stat, adjust_space)
  end
end

def adjust_space(file_names)
  max_permission = file_names.map { |name| stat_permission(name).length }.max
  max_hard_links = file_names.map { |name| count_link(name).to_s.length }.max
  max_owner = file_names.map { |name| user_id(name).length }.max
  max_group = file_names.map { |name| group_id(name).length }.max
  max_size = file_names.map { |name| calc_size(name).to_s.length }.max

  [max_permission, max_hard_links + 1, max_owner + 1, max_group + 1, max_size]
end

ls_command_l_option
