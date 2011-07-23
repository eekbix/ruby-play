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
    #get("index", :quote => Quote.new.random)
    @app = app
  end
  
  def call(env)
    response = []
    if (@app)
      response = @app.call(env)[2]
    end
    response.push("<p>#{Quote.new.random}</p>")
    ["200", {"Content-Type" => "text/html"}, response]    
  end
end

class MyApp < Lamework
  def initialize()
    get("index", :quote => "Hello world")
  end
end

use QuoteFilter
run MyApp.new()
