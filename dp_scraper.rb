# Scrape posts from /r/dailyprogrammer
# SovietKetchup
# v0.0.0

require 'net/http'
require 'json'

# Sleep to prevent spamming of Reddit's
sleep(2)

# Function to get .json of page
def get url
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri, {"User-Agent" => "My Ruby Script"})
  http.use_ssl = true if uri.scheme.eql?("https")
  response = http.request(request)
end


raw_json = get("https://www.reddit.com/r/dailyprogrammer.json").body
#File.open("js/raw_json.json", 'w') {|f| f.write(raw_json) }

raw_data = JSON.parse(raw_json)
#File.open("js/raw_data.json", 'w') {|f| f.write(raw_data) }

pretty_data = JSON.pretty_generate(raw_data)
#File.open("js/pretty_data.txt", 'w') {|f| f.write(pretty_data) }

raw_posts = (raw_data["data"]["children"])
raw_posts.delete_at(0)
#File.open("js/raw_posts.json", 'w') {|f| f.write(raw_posts) }

pretty_posts = JSON.pretty_generate(raw_posts)
#File.open("js/pretty_posts.txt", 'w') {|f| f.write(pretty_posts) }
