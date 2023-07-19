require 'date'
require 'optparse'

options = ARGV.getopts('m:', 'y:')

@this_month =
  if options['m']
    options['m'].to_i
  else
    Date.today.month
  end

@this_year =
  if options['y']
    options['y'].to_i
  else
    Date.today.year
  end

day_of_week = %w[日 月 火 水 木 金 土]

first_day = Date.new(@this_year, @this_month, 1)
last_day = Date.new(@this_year, @this_month, -1)
day_count = last_day.day

days = (0...day_count).map { |i| first_day + i }

# 一日（ついたち）の曜日を空白で合わせる
first_day_wday = first_day.wday
head_brank = []
first_day_wday.times { head_brank << ' ' }
days = head_brank + days

puts "#{@this_year}年 #{@this_month}月"
puts day_of_week.join(' ')
days.each do |d|
  if d.instance_of?(Date)
    if d == Date.today # 今日なら色を変える
      print "\e[31m#{d.day.to_s.rjust(3)}\e[0m"
    else
      print d.day.to_s.rjust(3)
    end
    puts if d.wday == 6 # 土曜日なら改行
  else
    print d.rjust(3)
  end
end

puts
