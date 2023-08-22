# frozen_string_literal: true

def file_names
  ls_option = ARGV
  if ls_option.include?('-a')
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end
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

ls_command
