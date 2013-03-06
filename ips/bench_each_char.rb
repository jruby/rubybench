# encoding: UTF-8

require 'benchmark/ips'

Benchmark.ips do |bm|
  usascii_str = "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm".force_encoding('US-ASCII')
  utf8_str = "µµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµµ"
  utf16_str = utf8_str.encode('UTF-16')
  utf32_str = utf8_str.encode('UTF-32')
  bm.report("each_char USASCII") do |n|
    i = 0
    while i < n
      usascii_str.each_char {|c| c}
      i+=1
    end
  end
  bm.report("each_char UTF-8") do |n|
    i = 0
    while i < n
      utf8_str.each_char {|c| c}
      i+=1
    end
  end
  bm.report("each_char UTF-16") do |n|
    i = 0
    while i < n
      utf16_str.each_char {|c| c}
      i+=1
    end
  end
  bm.report("each_char UTF-32") do |n|
    i = 0
    while i < n
      utf32_str.each_char {|c| c}
      i+=1
    end
  end
end
