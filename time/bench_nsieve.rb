# Adapted for JRuby benchmarking based on...
#
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# contributed by Glenn Parker, March 2005
# modified by Evan Phoenix, Sept 2006
require 'benchmark'

if RUBY_VERSION =~ /1\.8/
  def sieve(m)
    flags = Flags.dup[0,m]
    count = 0
    pmax = m - 1
    p = 2
    while p <= pmax
      unless flags[p].zero?
	count += 1
	mult = p
	while mult <= pmax
	  flags[mult] = 0
	  mult += p
	end
      end
      p += 1
    end
    count
  end
else
  def sieve(m)
    flags = Flags.dup[0,m]
    count = 0
    pmax = m - 1
    p = 2
    while p <= pmax
      unless flags.getbyte(p).zero?
	count += 1
	mult = p
	while mult <= pmax
	  flags.setbyte(mult, 0)
	  mult += p
	end
      end
      p += 1
    end
    count
  end
end

n = (ARGV[0] || 2).to_i

Flags = "\x1" * ( 2 ** n * 10_000)

puts Benchmark.measure {
n.downto(n-2) do |exponent|
  break if exponent < 0
  m = (1 << exponent) * 10_000
  # m = (2 ** exponent) * 10_000
  count = sieve(m)
  printf "Primes up to %8d %8d\n", m, count
end
}

puts Benchmark.measure {
n.downto(n-2) do |exponent|
  break if exponent < 0
  m = (1 << exponent) * 10_000
  # m = (2 ** exponent) * 10_000
  count = sieve(m)
  printf "Primes up to %8d %8d\n", m, count
end
}
