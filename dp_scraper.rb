# Scrape posts from /r/dailyprogrammer
# SovietKetchup
# v1.3.1

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

count = 0

while true do

  sleep(2)

  1.times { puts count.to_s.red }

  if count == 0
    link = "https://www.reddit.com/r/dailyprogrammer.json?limit    #raise post[:time].to_s.inspect=100"
  else
    link = "https://www.reddit.com/r/dailyprogrammer.json?limit=100&after=" + $next_link
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
    post_date = DateTime.strptime(post[:time].to_s, "%s")
    post_date = post_date.to_s[0,10] + " "

    if (post_date == "2014-08-27 " and title.include? "contest") or post_date == "2016-02-11 "

      number = ""
      loc = "challenges"
      t = post[:title]

    elsif title.include? "meta" or title.include? "psa" or title.include? "mod post" or title.include? "[ann]"

      number = ""
      loc = "other"
      t = title.split("]")[-1]

    elsif title.include? "challenge" or title.include? "challange"

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
      elsif title.include? "intermediate" or title.include? "medium"
        loc = "intermediate"
      elsif title.include? "hard" or title.include? "difficult"
        loc = "hard"
      elsif title.include? "weekly"
        loc = "weekly"
      elsif (title.include? "week-long" and post_date != "2013-04-16 ") or title.include? "this isn't a challenge, just a thank you"
        loc = "other"
      elsif title.include? "all" or title.include? "practical exercise" or title.include? "monthly" or title.include? "bonus" or (post_date == "2014-08-27 " and title.include? "contest")
        loc = "challenges"
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

    elsif title.include? "easy"

      loc = "easy"
      t = post[:title]
      number = ""

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

  end

  count += 1
end
