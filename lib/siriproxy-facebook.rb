require 'cora'
require 'siri_objects'
require 'httparty'
require 'json'

class SiriProxy::Plugin::Facebook < SiriProxy::Plugin
  attr_accessor :access_token
  attr_accessor :username
  
  def initialize(config)  
    self.access_token = config["access_token"] 
    self.username = config["username"]  
  end


listen_for /facebook status (.+)/i do |facebookText|
    say "Here is your status:"
    
        # Preview of the Status update
        object = SiriAddViews.new
        object.make_root(last_ref_id)
        answer = SiriAnswer.new("Facebook Status", [
                            SiriAnswerLine.new('logo','http://cl.ly/CXNm/Screen%20Shot%202011-12-11%20at%2011.26.52%20AM.png'), # facebook logo
                            SiriAnswerLine.new(facebookText)
                            ])
        object.views << SiriAnswerSnippet.new([answer])
        send_object object

          
            
    if confirm "Ready to send it?"
        say "Posting to Facebook..."
        Thread.new {
            begin
                page = HTTParty.post(
                                     "https://graph.facebook.com/me/feed",
                                     :query => {
                                     :message => (facebookText),
                                     :access_token => (access_token)
                                     }
                                     )
                say "Your status has been updated."
                rescue Exception
                pp $!
                say "Sorry, I encountered an error: #{$!}"
                ensure
                request_completed
            end
        }
        else
        say "Ok I won't send it."
        request_completed
    end
end
end
