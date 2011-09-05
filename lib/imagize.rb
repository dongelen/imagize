require "rubygems"
require "net/http"
require "uri"
require 'cloudapp_api' 


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
    # :youtube_long => {
    #   :url => "http://www.youtube.com/watch",
    #   :convert => "http://img.youtube.com/vi/§ID§/0.jpg"
    # }, 
    :tweetphoto => {
      :url => "http://tweetphoto.com/",
      :convert => "http://tweetphotoapi.com/api/TPAPI.svc/imagefromurl?size=big&url=http://tweetphoto.com/§ID§"
    },
    :lockerz => {
      :url => "http://lockerz.com/s/",
      :convert => "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=big&url=http://lockerz.com/s/§ID§"
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
    },        
    :instagram => {
      :url => "http://instagr.am/p/",
      :convert => "http://instagr.am/p/§ID§/media/?size=l"      
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
    },
    :lytsr=>{
      :url=>"http://lyt.sr/"
    },
    :google=>{
      :url=>"http://goo.gl/"
    }
  }    
  
  IMAGE_URL  = /http:\/\/[.\w]*\/[\/\w]*/
  # IMAGE_URL  = /http:\/\/[.\w]*\/[\/\w]*[\b.jpg\b|\b\.gif\b|\b\.jp\b|]+/
  JPG_FINDER = /#{IMAGE_URL}.jpg/
  GIF_FINDER = /#{IMAGE_URL}.gif/
  PNG_FINDER = /#{IMAGE_URL}.png/       
  
  IMAGE_FINDERS = [JPG_FINDER, GIF_FINDER, PNG_FINDER]
  YOUTUBE_LONG_URL="www.youtube.com/watch"  
  YOUTUBE_LONG_CONVERT_URL="http://img.youtube.com/vi/§ID§/0.jpg"
  
  CLOUD_APP = "http://cl.ly/"
  
  class Imagizer
  
    def imagize(message, extract_shorteners=false)   
      tweet = message.clone
      images = Array.new
      
      
      #find shortened content
      if extract_shorteners
        SHORTENERS.each do |service, details|   
          currentService = details[:url]      
          tweet.scan /#{currentService}\w*/ do |current|        
            tweet = tweet.sub(current, extract_shortener(current))
          end                 
        end     
      end
          
      #find image services
      URL_DEFINITIONS.each do |service, details|   
        currentService = details[:url]                 
        tweet.scan /#{currentService}\w*/ do |current| 
          code = current.sub(currentService, "")      
          images <<  make_url(service, code)
        end                 
      end                                
      
      
      #Find cl.ly 
      tweet.scan /#{CLOUD_APP}\w*/ do |current|
        p "Current is " + current
        code = current.sub(CLOUD_APP, "")    
        p code
        
        add_cloud_app_image images, code


      end   

      #Find shorteners that use cl.ly
      # Resolv.getaddress "dirk.si"      
    
           
      # long youtube                
      tweet.scan /#{YOUTUBE_LONG_URL}\?v=\w*/ do |current|
        p "Current is " + current
        code = current.sub(YOUTUBE_LONG_URL+"?v=", "")    
        p code
        
        images <<  make_youtube_url(code)      

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
    
    def make_youtube_url (code)
      YOUTUBE_LONG_CONVERT_URL.gsub "§ID§", code
    end       
    
    def add_cloud_app_image(images, code)
      drop = CloudApp::Drop.find code
      if drop.image?
        images << drop.remote_url
      end
    end
  end
end