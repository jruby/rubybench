require 'benchmark'
require 'tempfile'

puts "Benchmark chmod performance, 1000x changing mode"

file = Tempfile.new('bench_chmod')
path = file.path

5.times {
  puts Benchmark.measure {
    1000.times { File.chmod(0622, path) }
  }
}
