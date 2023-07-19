# frozen_string_literal: true

input_score = ARGV[0]
scores = input_score.split(',')
shots = scores.map do |score|
  if score == 'X' # ストライク
    10
  else
    score.to_i
  end
end

point = 0 # 出力するスコア。フレームごとにshotsより加算していく。
shot = 0 # 〇投目。分岐内で加算され、shotsを出力するのに使用。

(1..10).each do |frame|
  if frame == 10 # 10フレームのみ単純合計を加算
    point += shots[shot..].sum
    break
  end

  if shots[shot] == 10 # strike
    point += 10 + shots[shot + 1] + shots[shot + 2]
    shot += 1 # shotを1投分(1フレーム相当分)加算
  elsif shots[shot] + shots[shot + 1] == 10 # spare
    point += 10 + shots[shot + 2]
    shot += 2 # shotを2投分(1フレーム相当)加算
  else
    point += shots[shot] + shots[shot + 1]
    shot += 2 # shotを2投分(1フレーム相当)加算
  end
end

puts point

# テスト用データ
# ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
# 139
# ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X
# 164
# ruby bowling.rb 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4
# 107
# ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0
# 134
# ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8
# 144
# ruby bowling.rb X,X,X,X,X,X,X,X,X,X,X,X
# 300
# ruby bowling.rb X,0,0,X,0,0,X,0,0,X,0,0,X,0,0
# 50
