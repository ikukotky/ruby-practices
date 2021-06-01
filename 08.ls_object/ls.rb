#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
options = ARGV.getopts('alr')

files = if options['a'] && options['r']
          Dir.glob('*', File::FNM_DOTMATCH).sort.reverse
        elsif options['a']
          Dir.glob('*', File::FNM_DOTMATCH).sort
        elsif options['r']
          Dir.glob('*').sort.reverse
        else
          Dir.glob('*').sort
        end

def l_ftype(ftype)
  {
    "file": '-',
    "directory": 'd',
    "characterSpecial": 'c',
    "fifo": 'f',
    "link": 'l',
    "socket": 's'
  }[ftype.to_sym]
end

def l_pms(pms)
  {
    "7": 'rwx',
    "6": 'rw-',
    "5": 'r-x',
    "4": 'r--',
    "3": '-wx',
    "2": '-w-',
    "1": '--x',
    "0": '---'
  }[pms.to_sym]
end

def l_option(l_file)
  puts "total #{l_file.count}"
  l_file.each do |x|
    file_stat = File::Stat.new(x)
    md_num = format('%o', file_stat.mode)
    print l_ftype(file_stat.ftype).to_s + "#{l_pms(md_num[-3])}#{l_pms(md_num[-2])}#{l_pms(md_num[-1])}"
    print "  #{file_stat.nlink.to_s.rjust(3)}"
    print "  #{Etc.getpwuid(file_stat.uid).name}"
    print "  #{Etc.getgrgid(file_stat.gid).name}"
    print "  #{file_stat.size.to_s.rjust(5)}  #{file_stat.mtime.strftime('%m %d %k:%M')}  #{x}\n"
  end
end

def not_l_opt(files)
  case files.length % 3
  when 1
    2.times { files << ' ' }
  when 2
    files << ' '
  end

  files.each_slice(files.size / 3).to_a.transpose.each do |file|
    print "#{file[0]}#{' ' * (20 - file[0].size)}#{file[1]}#{' ' * (20 - file[1].size)}#{file[2]}\n"
  end
end

if options['l']
  l_option(files)
else
  not_l_opt(files)
end
