require 'open-uri'
require 'nokogiri'

arr = []
doc = Nokogiri::HTML(open("http://boards.4chan.org/mu/"))

doc.xpath("//a[@class=\"replylink\"]").each { |node|
    thread = Nokogiri::HTML(open("http://boards.4chan.org/mu/" + node["href"]))

    thread.xpath("//blockquote[@class=\"postMessage\"]").each { | mu_post |
        mu_post.text.scan(/www\.youtube\.com\/watch\?v=(([a-zA-Z0-9]){11})/).each { | yt |
            arr << Regexp.last_match[1] if Regexp.last_match
            
        }    
    }
}

print "www.youtube.com/watch?v=" + arr.sample