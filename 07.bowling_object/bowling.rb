#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = Array.new(0, 0)
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, i|
  # 10フレームを場合分け
  if i >= 9
    point += frame.sum
  elsif frame[0] == 10
    # ストライクの処理(2回以上続くかで場合分け)
    point += 10 + frames[i + 1].sum if frames[i + 1][0] < 10
    point += 10 + frames[i + 1][0] + frames[i + 2][0] if frames[i + 1][0] == 10
    # スペアの場合の処理
  elsif frames[i].sum == 10
    point += 10 + frames[i + 1][0]
  else
    point += frame.sum
  end
end
p point
