# Scrape posts from /r/dailyprogrammer
# SovietKetchup
# v0.3.0

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


stages = []
def write_stages s
  File.open("js/raw_json.json", 'w')           {|f| f.write(s[0]) }
  File.open("js/raw_data.json", 'w')           {|f| f.write(s[1]) }
  File.open("js/pretty_data.txt", 'w')         {|f| f.write(s[2]) }
  File.open("js/raw_posts.json", 'w')          {|f| f.write(s[3]) }
  File.open("js/pretty_posts.txt", 'w')        {|f| f.write(s[4]) }
  File.open("js/raw_posts_simple.json", 'w')   {|f| f.write(s[5]) }
  File.open("js/pretty_posts_simple.txt", 'w') {|f| f.write(s[6]) }
end

raw_json = get("https://www.reddit.com/r/dailyprogrammer.json").body
raw_data = JSON.parse(raw_json)
pretty_data = JSON.pretty_generate(raw_data)
raw_posts = (raw_data["data"]["children"])
raw_posts.delete_at(0)
pretty_posts = JSON.pretty_generate(raw_posts)

posts_arr = eval(raw_posts.inspect)
c = 0
raw_posts_simple = []
posts_arr.each do |post|
  post = post["data"]
  po = Hash.new
  # Post data
  po[:title] = post["title"]
  po[:url] = post["url"]
  po[:permalink] = post["permalink"]
  po[:score] = post["score"]
  po[:comments] = post["num_comments"]
  po[:description] = post["selftext"]
  raw_posts_simple[c] = po
  c += 1
end

pretty_posts_simple = JSON.pretty_generate(raw_posts_simple)

# Print each stage to files
# stages = [raw_json]
# stages << raw_data
# stages << pretty_data
# stages << raw_posts
# stages << pretty_posts
# stages << raw_posts_simplified
# stages << pretty_posts_simplified
# write_stages(stages)
