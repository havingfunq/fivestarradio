# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 1.minute do
  @url = []
  doc = Nokogiri::HTML(open("http://boards.4chan.org/mu/"))

  doc.xpath("//a[@class=\"replylink\"]").each { |node|
    thread = Nokogiri::HTML(open("http://boards.4chan.org/mu/" + node["href"]))

    thread.xpath("//blockquote[@class=\"postMessage\"]").each { | mu_post |
    
      mu_post.text.scan(/www\.youtube\.com\/watch\?v=(([a-zA-Z0-9]){11})/).each { | yt |
        @url << Regexp.last_match[1] if Regexp.last_match
      }    
    }
  }
  
  
end

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
