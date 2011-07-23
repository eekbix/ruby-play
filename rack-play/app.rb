require "./lamework"
require "./models/quote"

class QuotesApp < Lamework
  def initialize()
    get("index", :quote => Quote.new.random)
  end  
end

class HelloApp < Lamework
  def initialize()
    get("index", :quote => "Hello world")
  end  
end