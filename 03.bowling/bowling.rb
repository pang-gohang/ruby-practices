# frozen_string_literal: true

# 引数をとる

input_score = ARGV[0] # 引数のデータを1投ごとに分割し、scoreに追加。
scores = input_score.split(',') # 1 投ごとの倒したピンの数が入った配列。インスタンスを跨ぐので@
@shots = []

scores.each do |score|
  @shots << if score == 'X' # ストライク
              10
            else
              score.to_i
            end
end

frame = 1 # フレーム。1 - 10。分岐内で加算し、10になると最終処理をし、ループを抜ける。
point = 0 # 出力するスコア。フレームごとにshotsより加算していく。
shot = 0 # 〇投目。分岐内で加算され、shotsを出力するのに使用。

while frame <= 10
  if frame == 10 # 10フレームのみ単純合計を加算
    while @shots[shot]
      point += @shots[shot]
      shot += 1
    end
    break
  else # 通常フレーム
    if @shots[shot] == 10 # strike
      point += 10 + @shots[shot + 1] + @shots[shot + 2] # 10 + 次回2投分のスコア加算
      shot += 1 # shotを1投分(1フレーム相当分)加算
    elsif @shots[shot] + @shots[shot + 1] == 10 # spare
      point += 10 + @shots[shot + 2] # 10 + 次回のスコアを加算
      shot += 2 # shotを2投分(1フレーム相当)加算
    else
      point += @shots[shot] + @shots[shot + 1] # 通常。1フレーム相当の2投分を加算。
      shot += 2 # shotを2投分(1フレーム相当)加算
    end

    frame += 1 # frame加算
  end
end

puts point
# テスト用データ
# ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
# 139
# ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X
# 164
# ./bowling.rb 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4
# 107
# ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0
# 134
# ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8
# 144
# ./bowling.rb X,X,X,X,X,X,X,X,X,X,X,X
# 300
# ./bowling.rb X,0,0,X,0,0,X,0,0,X,0,0,X,0,0
# 50
