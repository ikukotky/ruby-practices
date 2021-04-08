#!/usr/bin/env ruby

require "date"
require "optparse"

params = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")

year = params.values[0].to_i
month = params.values[1].to_i

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_date.wday

last_date.day.times do |n|
  date = first_date + n
  day = date.day
  if date.sunday? && day != 1
    print "\n"
  end
  print day.to_s.rjust(2) + " "
end
print "\n"
