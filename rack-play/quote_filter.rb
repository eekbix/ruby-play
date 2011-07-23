require "./quote"

class QuoteFilter
  def initialize(app = nil)  
    @app = app
  end
   
  def call(env)
    status, headers, @response = @app.call(env) 
    
    # This is *way* too clever. Since the response will have "each"
    # called on it, just implement "each" on this instance and pass
    # "self".     
    [status, headers, self]       
  end
  
  # I still don't understand: what is the block passed in here?  
  def each(&block)
    block.call("<p>#{Quote.new.random}</p>")
    @response.each(&block) 
  end
end