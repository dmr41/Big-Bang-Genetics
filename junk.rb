mappings = {
  '?_?' => ->(row){ puts row },
  '??' => ->(row){ puts "first" },
  '__' => ->(row){ puts "first" },
}

foo = "asdfasdf  ?_? asdfasdfasdf"
f = mappings.detect do |key, value|
  foo.include?(key)
end

p f.last.call("w00t!")

#----------------

class Foo1
  def self.matches?(ob)
    ob == 'foo'
  end

  def run(thing)
  end
end

class Foo2
  def self.matches?(ob)
    ob == 'bar'
  end

  def run(thing)
  end
end

class Foo3
  def self.matches?(ob)
    ob == 'bar'
  end

  def get_attributes
    {
      foo: 'bar'
    }
  end
end

klass = [Foo1, Foo2, Foo3].detect{|k| k.matches?(input) }
klass.new(input).run
