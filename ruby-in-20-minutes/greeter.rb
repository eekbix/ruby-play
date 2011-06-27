class Greeter
	def initialize(name="World")
		@name = name
	end

	def say_hi()
		puts "Hello #{@name}"
	end

	def say_bye()
		puts "Bye #{@name}"
	end
end

g = Greeter.new("bob")
g.say_hi()
g.say_bye()

# metaprogramming / reflection

puts g.respond_to?("name")
puts g.respond_to?("say_hi")

# change a class after it has been defined (!)

class Greeter
	attr_accessor :name
end

# "getter/setter methods" now exist
puts g.respond_to?("name")
puts g.respond_to?("name=")

g.name = "world"
g.say_hi()
