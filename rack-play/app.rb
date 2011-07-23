require "./lamework"

class MyApp < Lamework
  def initialize()
    get("index", :quote => "Hello world")
  end
end