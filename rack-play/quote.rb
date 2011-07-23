class Quote
  def initialize
    @quotes = [
     "It's all in the game", 
     "Winter is coming",
     "Yadda yadda yadda",
     "D'oh",
     "Woo-hoo!"
    ]    
  end
  def random
    index = rand(@quotes.length)
    @quotes[index]
  end
end
