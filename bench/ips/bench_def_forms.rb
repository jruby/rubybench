require 'benchmark/ips'

# form #1: normal def
module Form1
  def self.form1(a, b, c)
    a + b + c
  end
end

# form #2: class eval string
module Form2
  class_eval "
    def self.form2(a, b, c)
      a + b + c
    end
  "
end

# form #3: define_method
module Form3
  class << self
    define_method :form3 do |a, b, c|
      a + b + c
    end
  end
end

# form #4: function object in def
module Form4
  Function = Object.new.instance_eval do
    def form4(a, b, c)
      a + b + c
    end
    self
  end

  def self.form4(a, b, c)
    Function.form4(a, b, c)
  end
end

# form #5: function object in define_method
module Form5
  Function = Object.new.instance_eval do
    def form5(a, b, c)
      a + b + c
    end
    self
  end

  class << self
    define_method :form5 do |a, b, c|
      Function.form5(a, b, c)
    end
  end
end

# form #6: function object method in def
module Form6
  Function = Object.new.instance_eval do
    def form6(a, b, c)
      a + b + c
    end
    self
  end.method(:form6)

  def self.form6(a, b, c)
    Function.(a, b, c)
  end
end

# form #7: function object method in define_method
module Form7
  Function = Object.new.instance_eval do
    def form7(a, b, c)
      a + b + c
    end
    self
  end.method(:form7)
  
  class << self
    define_method :form7 do |a, b, c|
      Function.(a, b, c)
    end
  end
end

# form #8: function object method bound via define method
module Form8
  Function = Object.new.instance_eval do
    def form8(a, b, c)
      a + b + c
    end
    self
  end.method(:form8)

  class << self
    define_method :form8, &Function
  end
end

# form #9: function object unbound method via define method
module Form9
  def self.form9_unbound(a, b, c)
    a + b + c
  end
  Function = Form9.method(:form9_unbound).unbind

  class << self
    define_method :form9, Function
  end
end

# form #10: function object bound method via define method
# The bound method form is a prototype in JRuby
module Form10
  Function = Object.new.instance_eval do
    def form10(a, b, c)
      a + b + c
    end
    self
  end.method(:form10)

  class << self
    define_method :form10, Function
  end
end if RUBY_ENGINE == 'jruby'

Benchmark.ips do |bm|
  bm.report('control loop') do |n|
    x = 0
    while n > 0
      x += 1 + 2 + n
      n-=1
    end
    x
  end

  bm.report('#1: normal def') do |n|
    x = 0
    while n > 0
      x += Form1.form1(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#2: class_eval') do |n|
    x = 0
    while n > 0
      x += Form2.form2(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#3: d_m') do |n|
    x = 0
    while n > 0
      x += Form3.form3(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#4: func obj in def') do |n|
    x = 0
    while n > 0
      x += Form4.form4(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#5: func obj in d_m') do |n|
    x = 0
    while n > 0
      x += Form5.form5(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#6: method in def') do |n|
    x = 0
    while n > 0
      x += Form6.form6(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#7: method in d_m') do |n|
    x = 0
    while n > 0
      x += Form7.form7(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#8: d_m proc method') do |n|
    x = 0
    while n > 0
      x += Form8.form8(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#9: d_m unbound method') do |n|
    x = 0
    while n > 0
      x += Form9.form9(1, 2, n)
      n-=1
    end
    x
  end

  bm.report('#10: d_m bound method') do |n|
    x = 0
    while n > 0
      x += Form10.form10(1, 2, n)
      n-=1
    end
    x
  end if RUBY_ENGINE == 'jruby'
end
