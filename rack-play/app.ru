class HelloWorld
  def call(env)
    # Note that in Ruby 1.9, string does not respond to each. The
    # TekPub example needs to be tweaked to use an array.
    out = []
    env.keys.each {|key| out.push("<li>#{key} = #{env[key]}</li>")}
    ["200", {"Content-Type" => "text/html"}, out]
  end  
end

run HelloWorld.new
