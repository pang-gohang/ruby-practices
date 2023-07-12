require "date"
require "optparse"

# 引数として-m, -y
options = ARGV.getopts('m:','y:')

# 月と年を指定。制御が必要? m:, y:
# @に表示月と年を代入する。
if options['m']
    @this_month = options['m'].to_i
else
    @this_month = Date.today.month
end

if options['y']
    @this_year = options['y'].to_i
else
    @this_year = Date.today.year
end

# 曜日出力用データ
day_of_week = ["日", "月", "火", "水", "木", "金", "土"]

first_day = Date.new(@this_year, @this_month, 1) #ついたち
last_day = Date.new(@this_year, @this_month, -1) # 月末
day_count = last_day.day #日数

# 月の日数データを配列に入れるdays = [1.2.3...31]
days = []
(0...day_count).each do |i|
    days << first_day + i
end

#空白を入れる head_brank = [" ", " ", " ", " ", " "]
#ついたちの曜日を取得 日曜なら空白０個、土曜なら６個。
first_day_wday = first_day.wday
head_brank = []
first_day_wday.times { head_brank << " "}
#日数データの頭に空白を入れて、曜日の縦列を合わせる
days = head_brank + days

##ここから出力
puts "#{@this_year}年 #{@this_month}月"
puts day_of_week.join(" ")
days.each do |d|
    #daysにはdateクラスと空白のデータがあるので、分岐
    if d.class == Date
        #今日なら色を変える
        if d == Date.today
            print "\e[31m#{d.day.to_s.rjust(3)}\e[0m "
        else
            print "#{d.day.to_s.rjust(3)}"
        end
        #土曜日なら改行
        if d.wday == 6
            puts
        end
    #dateクラスじゃなかったら空白なのでそのまま出力
    else
        print "#{d.rjust(3)}"
    end
end
#最後の改行は大事
puts
