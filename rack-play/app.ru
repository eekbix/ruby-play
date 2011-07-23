require "haml"
require "./quote" # ugly. does this video predate Ruby 1.9?

class Lamework
  
  def initialize
    @response = ""
  end
  
  def get(template, locals)
    @response = haml("index", locals)
  end
  
  def haml(template_name, locals)
    template = File.open("views/#{template_name}.haml").read
    engine = Haml::Engine.new(template)    
    # ugh, more ugliness... "String does not respond to each"
    [].push(engine.render(Object.new, locals))
  end
  
  def call(env)    
    ["200", {"Content-Type" => "text/html"}, @response]
  end
end

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

class MyApp < Lamework
  def initialize()
    get("index", :quote => "Hello world")
  end
end


use QuoteFilter
run MyApp.new
