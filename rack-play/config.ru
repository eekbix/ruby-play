require "./app"

map '/' do
  run QuotesApp.new  
end

map '/hello' do
  run HelloApp.new  
end

