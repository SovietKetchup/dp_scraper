# Scrape posts from /r/dailyprogrammer
# SovietKetchup
# v1.1.0

# # # # # # # # # # # # # # # # # # # #
#https://www.reddit.com/r/dailyprogrammer.json?
#https://www.reddit.com/r/dailyprogrammer.json?after=aftervalue
#https://www.reddit.com/r/dailyprogrammer.json?limit=200
#https://www.reddit.com/r/dailyprogrammer.json?limit=200&after=aftervalue
# # # # # # # # # # # # # # # # # # # #


require 'net/http'
require 'json'
require 'colorize'
require 'date'

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

# stages = []
# def write_stages s
#   File.open("js/raw_json.json", 'w')           {|f| f.write(s[0]) }
#   File.open("js/raw_data.json", 'w')           {|f| f.write(s[1]) }
#   File.open("js/pretty_data.txt", 'w')         {|f| f.write(s[2]) }
#   File.open("js/raw_posts.json", 'w')          {|f| f.write(s[3]) }
#   File.open("js/pretty_posts.txt", 'w')        {|f| f.write(s[4]) }
#   File.open("js/raw_posts_simple.json", 'w')   {|f| f.write(s[5]) }
#   File.open("js/pretty_posts_simple.txt", 'w') {|f| f.write(s[6]) }
# end

count = 0

while true do

  # raw_json = ""
  # raw_data = ""
  # pretty_data = ""
  # raw_posts = ""
  # pretty_posts = ""
  # posts_arr = ""
  # raw_posts_simple = ""
  # pretty_posts_simple = ""
  # c = 0
  # challenge = ""
  # loc = ""

  sleep(2)

  3.times { puts count.to_s.red }

  if count == 0
    link = "https://www.reddit.com/r/dailyprogrammer.json?limit=100"
  else
    link = "https://www.reddit.com/r/dailyprogrammer.json?limit=100&after=" + $next_link

    #raise link.inspect
  end

  raw_json = get(link).body
  raw_data = JSON.parse(raw_json)
  $next_link = raw_data["data"]["after"]
  pretty_data = JSON.pretty_generate(raw_data)
  raw_posts = (raw_data["data"]["children"])
  raw_posts.delete_at(0) if count == 0
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
    po[:score] = post["score"].to_s
    po[:comments] = post["num_comments"].to_s
    po[:description] = post["selftext"]
    po[:time] = post["created_utc"]
    raw_posts_simple[c] = po
    c += 1
  end

  pretty_posts_simple = JSON.pretty_generate(raw_posts_simple)

  # Format each post
  raw_posts_simple.each do |post|

    puts post[:title].blue

    # Format of final document
    challenge = "# DETAILS\nTitle      : #{post[:title]}\nURL        : #{post[:url]}\nPerma-Link : #{post[:permalink]}\nScore      : #{post[:score]}\nComments   : #{post[:comments]}\n\n# DESCRIPTION\n#{post[:description]}"

    title = post[:title].downcase
    #raise post[:time].to_s.inspect
    post_date = DateTime.strptime(post[:time].to_s, "%s")
    post_date = post_date.to_s[0,10] + " "

    if title.include? "challenge"

      # Get challenge number
      if title.include? "#"
        a = title.split("#")[1]
        b = a.split(" ")[0]
        number = "##{b}"
      else
        number = "#000"
      end

      # Challenge difficulty
      if title.include? "easy"
        loc = "easy"
      elsif title.include? "intermediate"
        loc = "intermediate"
      elsif title.include? "hard" or title.include? "difficult"
        loc = "hard"
      else
        loc = "other"
      end

      # Challenge title
      if title.include? "]"
        t = title.split("]")[-1]
      else
        t = "UNKNOWN"
      end

      doc_title = post_date + number + t

    elsif title.include? "weekly"

      loc = "weekly"

      # Get challenge number
      if title.include? "#"
        a = title.split("#")[1]
        b = a.split("]")[0]
        number = "##{b}"
      else
        number = "#00"
      end

      # Challenge title
      if title.include? "]"
        t = title.split("]")[-1]
      else
        t = "UNKNOWN"
      end

      doc_title = post_date + number + t

    elsif title.include? "meta" or title.include? "psa" or title.include? "mod post"

      number = ""
      loc = "meta"
      t = title.split("]")[-1]

    else

      loc = "other"
      t = post[:title]
      number = ""

    end

    doc_title = post_date + number + t.capitalize

    doc_title.tr!("*", "-"); doc_title.tr!(".", "-"); doc_title.tr!("/", "-")
    doc_title.tr!("\\", "-"); doc_title.tr!("[", "-"); doc_title.tr!("]", "-")
    doc_title.tr!(":", "-"); doc_title.tr!(";", "-"); doc_title.tr!("|", "-")
    doc_title.tr!("=", "-"); doc_title.tr!("=", "-"); doc_title.tr!(",", "-")

    puts (loc+"/"+doc_title).green

    File.open("posts/" + loc + "/" + doc_title + ".md", 'w+') {|f| f.write(challenge) }

    # # Decide file location
    # if title.include? "[Easy"
    #   location = "posts/easy/"
    # elsif title.include? "[Intermediate]"
    #   location = "posts/intermediate/"
    # elsif title.include? "[Hard]"
    #   location = "posts/hard/"
    # elsif title.include? "[Weekly"
    #   location = "posts/weekly/"
    # else
    #   location = "posts/other/"
    # end
    #
    # # Make the filename characters Windows friendly
    # title.tr!("*", "-"); title.tr!(".", "-"); title.tr!("/", "-")
    # title.tr!("\\", "-"); title.tr!("[", "-"); title.tr!("]", "-")
    # title.tr!(":", "-"); title.tr!(";", "-"); title.tr!("|", "-")
    # title.tr!("=", "-"); title.tr!("=", "-"); title.tr!(",", "-")
    #
    #
    #
    # File.open(location + title + ".md", 'w+') {|f| f.write(challenge) }

  end

  count += 1
end










# # Print each stage to files (un)comment to (not) run
# stages = [raw_json]
# stages << raw_data
# stages << pretty_data
# stages << raw_posts
# stages << pretty_posts
# stages << raw_posts_simplified
# stages << pretty_posts_simplified
# write_stages(stages)
