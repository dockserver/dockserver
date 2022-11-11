require 'net/http'
require 'json'

if ARGV.length != 1 then
  puts "Expected only one argument: ENDPOINT_URL"
  exit 1
end

for i in 0..10
  response = Net::HTTP.get_response(URI(ARGV[0]))
  if response.code == "200"
    puts JSON.parse(response.body)["title"]
    exit 0
  end
end

puts "Had an issue calling endpoint...%s %s %s" % [response, response.message, response.body]
exit 1