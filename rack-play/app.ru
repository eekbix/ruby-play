require "haml"
require "./quote" # ugly. does this video predate Ruby 1.9?


# An example of middleware. Think ASP.NET Tracing.
class EnvironmentOutput
  def initialize(app = nil)
    @app = app
  end
  
  def call(env)
    # Note that in Ruby 1.9, string does not respond to each. The
    # TekPub example needs to be tweaked to use an array.
    out = []
    
    # Call the passed-in app.
    unless (@app.nil?)
      response = @app.call(env)[2]  # [status, headers, response-body]
      out.push(response)
    end
        
    env.keys.each {|key| out.push("<li>#{key} = #{env[key]}</li>")}
    # Observation: ...body must be a type that implements "each", which string does not.
    ["200", {"Content-Type" => "text/html"}, out]
  end  
end

class MyApp
  def call(env)
    quote = Quote.new.random
    template = File.open("views/index.haml").read
    engine = Haml::Engine.new(template)
    
    # engine.render(scope, params...)
    out = engine.render(Object.new, :quote => quote)  

    # Observation: ...body must be string type here
    ["200", {"Content-Type" => "text/html"}, out]
  end
end

use EnvironmentOutput
run MyApp.new
