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
    :youtube => {
      :url => "http://youtu.be/",    
      :convert => "http://img.youtube.com/vi/§ID§/0.jpg"      
    },  
    :tweetphoto => {
      :url => "http://tweetphoto.com/",
      :convert => "http://tweetphotoapi.com/api/TPAPI.svc/imagefromurl?size=big&url=http://tweetphoto.com/§ID§"
    }
  }       
  SHORTENERS = {
    :bitly => {
      :url=> "http://bit.ly/"
    }
  }    
  
  IMAGE_URL  = /http:\/\/[.\w]*\/[\/\w]*/
  JPG_FINDER = /#{IMAGE_URL}.jpg/
  GIF_FINDER = /#{IMAGE_URL}.gif/
  PNG_FINDER = /#{IMAGE_URL}.png/       
  
  IMAGE_FINDERS = [JPG_FINDER, GIF_FINDER, PNG_FINDER]
  
  class Imagizer
  
    def imagize(message)   
      tweet = message.clone
      images = Array.new
      
      #find shortened content
      SHORTENERS.each do |service, details|   
        currentService = details[:url]      
        tweet.scan /#{currentService}\w*/ do |current|        
          tweet = tweet.sub (current, extract_shortener(current))
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