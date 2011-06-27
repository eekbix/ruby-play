class MegaGreeter
	attr_accessor :names

	def initialize(names="World")
		@names = names
	end

	def say_hi
		if @names.nil?
			puts "..."
		elsif @names.respond_to?("each")
			# @names is a list of some kind, iterate
			@names.each do |name|
				puts "Hello #{name}"
			end
		else
			puts "Hello #{@names}!"
		end	
	end

	def say_bye
		if @names.nil?
			puts "..."
		elsif @names.respond_to?("join")
			# Join the list with commas
			puts "Goodbye #{@names.join(", ")}."
		else
			puts "Goodbye #{@names}."
		end
	end
end


if __FILE__ == $0
	mg = MegaGreeter.new
	mg.say_hi
	mg.say_bye

	# Change to a single name
	mg.names = "Zack"
	mg.say_hi
	mg.say_bye

	# Change to an array of names
	mg.names = ["Zack", "Matt", "Pat", "Jack"]
	mg.say_hi
	mg.say_bye
end

