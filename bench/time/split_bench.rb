require 'benchmark'

# few ways to do this:

# by @goozzik
def each_char_next(string)
  string.each_char {|e| string[string.index(e)] = e.next}
end

# by @Matthias
def each_next!(string)
  string.split('').each {|s| s.next! }
end

# by @zlw
def split_map_join(string)
  string.split('').map(&:next).join
end

# by @zlw
def gsub(string)
  string.gsub(/[a-z]?/) {|m| m.next}
  # even shorter:
  # string.gsub(/[a-z]?/, &:next)
end


# helper method
def alphabet(n=1)
  ('a'..'z').to_a.join * n
end


# benchmark
Benchmark.bmbm(15) do |bm|
  [1000, 10_000, 100_000].each do |n|
    alphabet = alphabet n
    bm.report ("each_char_next (#{n}):") { each_char_next alphabet } if n == 1000
    bm.report ("each_next!     (#{n}):") { each_next!     alphabet }
    bm.report ("split_map_join (#{n}):") { split_map_join alphabet }
    bm.report ("gsub           (#{n}):") { gsub           alphabet }
  end  
end
