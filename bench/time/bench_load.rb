require 'benchmark'

DIR = File.expand_path(File.dirname(__FILE__))
DATA_FILE1 = File.join(File.expand_path(File.dirname(__FILE__)), "load_data.rb")

DATA_FILE1_COMP = File.join(File.expand_path(File.dirname(__FILE__)), "load_data_compiled.class")

DATA_FILE2 = File.join(ENV_JAVA['jruby.home'], "lib/ruby/#{RUBY_VERSION[0..2]}", "csv.rb")

(ARGV[0] || 1).to_i.times do
  Benchmark.bm(35) do |bm|
    # useful to see how we're doing during startup,
    # when lots of cold require calls are made.
    bm.report("  1 load 'fileutils-like'") {
        load DATA_FILE1
    }

    bm.report(" 1K load 'fileutils-like'") {
      1_000.times {
        load DATA_FILE1
      }
    }

    # jruby-specific benchmark
    if defined?(JRUBY_VERSION)
      bm.report(" 100 load compiled 'fileutils-like'") {
        100.times {
          load DATA_FILE1_COMP
        }
      }
    end

    bm.report(" 1K load 'rational'") {
      1_000.times {
        begin
          load DATA_FILE2, true
        rescue LoadError
          p "ERROR: can't load #{DATA_FILE2}"
        end
      }
    }

    bm.report("10K require 'non-existing'") {
      (1..10_000).each { |i|
        begin
          require 'stuff' + i.to_s
        rescue LoadError
        end
      }
    }
  end
end
