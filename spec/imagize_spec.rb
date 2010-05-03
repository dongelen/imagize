require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Imagize

describe "Imagize" do      
  before (:all) do
    @imagizer = Imagize::Imagizer.new
  end               

  it "should recognize twitpic" do
    urls= @imagizer.imagize("@KarenWuvsYou http://twitpic.com/h5uhc - This is so cool:)! lol")
    urls.size.should ==1
    urls[0].should ==  "http://twitpic.com/show/large/h5uhc"
    
    urls= @imagizer.imagize("YG family outing y'all!!! http://twitpic.com/h71ip")
    urls.size.should ==1
    urls[0].should ==  "http://twitpic.com/show/large/h71ip"
  end                
  
  it "should recognize yfrog" do
    urls= @imagizer.imagize("MitchBHavin @themdudez http://yfrog.com/16y0")
    urls.size.should ==1
    urls[0].should ==  "http://yfrog.com/16y0:iphone"    
    
  
    urls= @imagizer.imagize("sekkatf @sekkatf hi cutie how r u? (via @SuzySlaouiC4) fine thank you, here is a pic for you to remember me. http://yfrog.com/0raejwj")
    urls.size.should ==1
    urls[0].should ==  "http://yfrog.com/0raejwj:iphone"    
  end   
  
  it "should recognize youtube" do
    urls= @imagizer.imagize("Hallo bnfgjfdgbfd http://youtu.be/B5IgPI9Dc7A?a\n Fiets")
    urls.should include("http://img.youtube.com/vi/B5IgPI9Dc7A/0.jpg")       
  end    

  it "should recognize tweetphoto" do
    urls= @imagizer.imagize("Hallo bnfgjfdgbfd http://tweetphoto.com/16793555 Fiets")
    urls.should include("http://tweetphotoapi.com/api/TPAPI.svc/imagefromurl?size=big&url=http://tweetphoto.com/16793555")       
  end  
  
  
  
  it "should recognize multiple images" do    
    urls= @imagizer.imagize("MitchBHavin @themdudez http://yfrog.com/16y0 @KarenWuvsYou http://twitpic.com/h5uhc - This is so cool:)! lol")
    urls.size.should ==2
    urls.should include("http://yfrog.com/16y0:iphone")    
    urls.should include"http://twitpic.com/show/large/h5uhc"
  end                 
  
  it "should recognize shortened youtube urls" do
    urls= @imagizer.imagize "Long text... youtu.be/1acVM7_rWw4 and more text"
    urls.size.should == 1
    
    urls[0].should == "http://img.youtube.com/vi/1acVM7_rWw4/0.jpg"
  end                
  
  it "should create normale urls" do
    @imagizer.make_url(:twitpic, "hi").should == "http://twitpic.com/show/large/hi"
    @imagizer.make_url(:yfrog, "hi").should == "http://yfrog.com/hi:iphone"
  end                
     

  # it "should recognize jpg" do
  #   @imagizer.imagize("x.jpg").size.should ==1
  # end                
  
  
end
