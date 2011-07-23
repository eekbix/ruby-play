require "haml"

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