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
  
  class Imagizer
  
    def imagize(message)   
      tweet = message.clone
      images = Array.new
    
      URL_DEFINITIONS.each do |service, details|   
        currentService = details[:url]      
        tweet.scan /#{currentService}\w*/ do |current|        
          code = current.sub(currentService, "")   
          puts code
          images <<  make_url (service, code)
        end

      end
    
      images
    end
  
    def make_url (servicename, code)
      URL_DEFINITIONS[servicename][:convert].gsub "§ID§", code
    end       
  end
end