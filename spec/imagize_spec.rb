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
    urls[0].should == "http://img.youtube.com/vi/B5IgPI9Dc7A/0.jpg"
    
    urls = @imagizer.imagize("Hallo bnfgjfdgbfd http://www.youtube.com/watch?v=NPahxS10HkY Fiets")
    urls[0].should == "http://img.youtube.com/vi/NPahxS10HkY/0.jpg"
    
    urls = @imagizer.imagize("Hallo bnfgjfdgbfd http://www.youtube.com/watch?v=ogZ9WXNNdIc Fiets")
    urls[0].should == "http://img.youtube.com/vi/ogZ9WXNNdIc/0.jpg"
       
    urls = @imagizer.imagize("RT @bartligthart - V0.5 of the hezoo screencast! http://www.youtube.com/watch?v=XGV0rKvtEwc #mtnw #tutorial")
    urls[0].should == "http://img.youtube.com/vi/XGV0rKvtEwc/0.jpg"
    

    urls = @imagizer.imagize("Thumbs up! #NHLhogeschool #lipdub. #cmdlwd Echt goed gedaan hoor! www.youtube.com/watch?v=kX1Mc0e2fBA")
    urls[0].should == "http://img.youtube.com/vi/kX1Mc0e2fBA/0.jpg"

    
    
  end    
  
  it "should recognize tweetphoto" do
    urls= @imagizer.imagize("Hallo bnfgjfdgbfd http://tweetphoto.com/16793555 Fiets")
    urls.should include("http://tweetphotoapi.com/api/TPAPI.svc/imagefromurl?size=big&url=http://tweetphoto.com/16793555")       
  end  

  it "should recognize plixi" do
    urls= @imagizer.imagize("Hallo bnfgjfdgbfd http://plixi.com/p/44815082 Fiets")

    urls.should include("http://api.plixi.com/api/tpapi.svc/imagefromurl?size=big&url=http://plixi.com/44815082")       
  end  
  
  it "should recognize lockerz" do
    urls= @imagizer.imagize("Hallo bnfgjfdgbfd http://lockerz.com/s/104968649 Fiets")

    urls.should include("http://api.plixi.com/api/tpapi.svc/imagefromurl?size=big&url=http://lockerz.com/s/104968649")       
  end  
  


  it "should recognize multiple images" do    
    urls= @imagizer.imagize("MitchBHavin @themdudez http://yfrog.com/16y0 @KarenWuvsYou http://twitpic.com/h5uhc - This is so cool:)! lol")
    urls.size.should ==2
    urls.should include("http://yfrog.com/16y0:iphone")    
    urls.should include"http://twitpic.com/show/large/h5uhc"
  end                 
      
  it "should recognize shortened youtube urls" do
    urls= @imagizer.imagize "Long text... http://youtu.be/1acVM7_rWw4 and more text"
    urls.size.should == 1
    
    urls[0].should == "http://img.youtube.com/vi/1acVM7_rWw4/0.jpg"
  end       
  
  it "should extract twitgoo" do
    urls= @imagizer.imagize "Komt toch bij mij over als een kippenoep met identiteitscrisis. http://twitgoo.com/1qg60x"        
    urls.size.should == 1
    
    urls[0].should == "http://twitgoo.com/show/img/1qg60x"
  end         
  it "should extract img.ly" do
    urls= @imagizer.imagize "http://img.ly/2oii #porrauol Que falha é essa na página principal...?"        
    urls.size.should == 1
    
    urls[0].should == "http://img.ly/show/full/2oii"
  end      
  
  it "should extract instagram" do
    urls= @imagizer.imagize "hsadfbkasdfkab http://instagr.am/p/LdVQg/ #porrauol Que falha é essa na página principal...?"        
    urls.size.should == 1
    
    urls[0].should == "http://instagr.am/p/LdVQg/media/?size=l"
  end     
  it "should extract moby.to" do
    urls= @imagizer.imagize "Thats Ma Cock pa...RT @SirKumNflex @kingkong it look like u like #teamuncut u rep it or u just like it? http://moby.to/40p2s4"        
    urls.size.should == 1
    
    urls[0].should == "http://moby.to/40p2s4:full"
  end  
  it "should create normal urls" do
    @imagizer.make_url(:twitpic, "hi").should == "http://twitpic.com/show/large/hi"
    @imagizer.make_url(:yfrog, "hi").should == "http://yfrog.com/hi:iphone"
  end                
     
  it "should extract urls of shorteners" do
    @imagizer.extract_shortener("http://bit.ly/3EgFOY").should == "http://www.nu.nl"
    @imagizer.extract_shortener("http://bit.ly/cxGTkx").should == "http://www.facebook.com/XL1067/posts/116716535027115"    
    @imagizer.extract_shortener("http://j.mp/3EgFOY").should == "http://www.nu.nl"    
    @imagizer.extract_shortener("http://is.gd/bSCVo").should == "http://www.nu.nl"  
    @imagizer.extract_shortener("http://goo.gl/VdHct").should == "http://www.nu.nl/"  
    # @imagizer.extract_shortener("http://lyt.sr/k5aub").should == "http://www.nu.nl"  
    
    
    urls = @imagizer.imagize("bla http://goo.gl/qs5Z6 bla", true)
    urls[0].should == "http://twitpic.com/show/large/38aduk"   
      
  end
  
  it "should extract  image in shortened url" do
    @imagizer.imagize("http://bit.ly/92mRwT", true).should include("http://twitpic.com/show/large/h5uhc")
  end
  
  
  it "should recognize jpg/gif" do
    @imagizer.imagize("This is some message http://www.hi.com/x.jpg").size.should ==1
    @imagizer.imagize("This is some message http://www.hi.com/1/2/3/x.jpg").size.should ==1    
    @imagizer.imagize("This is some message http://www.hi.com/1/2/3/x.gif").should include "http://www.hi.com/1/2/3/x.gif"
    @imagizer.imagize("This is some message http://bit.ly/bxjNbr but shortened", true).should include "http://www.hi.com/1/2/3/x.gif"    
    @imagizer.imagize("This is some message http://bit.ly/bxjNbr but shortened", true).should include "http://www.hi.com/1/2/3/x.gif"    
    @imagizer.imagize("This is some message http://is.gd/bSD5l but shortened", true).should include "http://www.hi.com/1/2/3/x.gif"       
  end                
  
       
end