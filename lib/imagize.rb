require "net/http"
require "uri"

module Imagize     

                     
  URL_DEFINITIONS = {
    :twitpic => {
      :url => "http://twitpic.com/",
      :convert => "http://twitpic.com/show/large/§ID§"
    },
    :yfrog =>{
      :url => "http://yfrog.com/",    
      :convert => "http://yfrog.com/§ID§:iphone"
    },  
    :youtube_short => {
      :url => "http://youtu.be/",    
      :convert => "http://img.youtube.com/vi/§ID§/0.jpg"      
    },            
    :youtube_long => {
      :url => "http://www.youtube.com/watch",
      :convert => "http://img.youtube.com/vi/§ID§/0.jpg"
    },
    :tweetphoto => {
      :url => "http://tweetphoto.com/",
      :convert => "http://tweetphotoapi.com/api/TPAPI.svc/imagefromurl?size=big&url=http://tweetphoto.com/§ID§"
    },
    :plixi => {
      :url => "http://plixi.com/p/",
      :convert => "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=big&url=http://plixi.com/§ID§"
    },
    :twitgoo => {
      :url => "http://twitgoo.com/",
      :convert => "http://twitgoo.com/show/img/§ID§"
    },
    :imgly =>{
      :url => "http://img.ly/",
      :convert => "http://img.ly/show/full/§ID§"      
    },
    :mobyto => {
      :url => "http://moby.to/",
      :convert => "http://moby.to/§ID§:full"      
    }        

  }       
  SHORTENERS = {
    :bitly => {
      :url=> "http://bit.ly/"
    },
    :jmp => {
      :url=> "http://j.mp/"
    },            
    :isgd =>{
      :url=>"http://is.gd/"
    },
    :twitter=>{
      :url=>"http://t.co/"
    }

  }    
  
  IMAGE_URL  = /http:\/\/[.\w]*\/[\/\w]*/
  # IMAGE_URL  = /http:\/\/[.\w]*\/[\/\w]*[\b.jpg\b|\b\.gif\b|\b\.jp\b|]+/
  JPG_FINDER = /#{IMAGE_URL}.jpg/
  GIF_FINDER = /#{IMAGE_URL}.gif/
  PNG_FINDER = /#{IMAGE_URL}.png/       
  
  IMAGE_FINDERS = [JPG_FINDER, GIF_FINDER, PNG_FINDER]
  YOUTUBE_LONG_URL="http://www.youtube.com/watch"  
  
  class Imagizer
  
    def imagize(message, extract_shorteners=false)   
      tweet = message.clone
      images = Array.new
      
      
      #find shortened content
      if extract_shorteners
        SHORTENERS.each do |service, details|   
          currentService = details[:url]      
          tweet.scan /#{currentService}\w*/ do |current|        
            tweet = tweet.sub (current, extract_shortener(current))
          end                 
        end     
      end
          
      #find image services
      URL_DEFINITIONS.each do |service, details|   
        currentService = details[:url]                 
        tweet.scan /#{currentService}\w*/ do |current| 
          code = current.sub(currentService, "")      
          images <<  make_url (service, code)
        end                 
      end          
           
      # long youtube                
      tweet.scan /#{YOUTUBE_LONG_URL}\?v=\w*/ do |current|
        code = current.sub(YOUTUBE_LONG_URL+"?v=", "")      
        images <<  make_url (:youtube_long, code)      
      end   
      
      IMAGE_FINDERS.each do |finder|
        images += tweet.scan(finder)
      end

    
      images
    end                 
    
    def extract_shortener (short_url)
      uri = URI.parse(short_url)

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)  
      response['location']
    end 
  
    def make_url (servicename, code)
      URL_DEFINITIONS[servicename][:convert].gsub "§ID§", code
    end       
    
  end
end