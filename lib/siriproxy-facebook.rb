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

  listen_for /test facebook/i do
          userjson = HTTParty.get("https://graph.facebook.com/#{self.username}").body rescue nil
          user = JSON.parse(userjson) rescue nil

            say "User name: #{user['name']}", spoken: "If your name is #{user['name']} then Facebook is set up correctly!"
            say ""

          request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  listen_for /what's my favorite quote/i do
          quotejson = HTTParty.get("https://graph.facebook.com/#{self.username}?fields=quotes&access_token=#{self.access_token}&format=json").body rescue nil
          quote = JSON.parse(quotejson) rescue nil
          quoteText = "#{quote['quotes']}" rescue nil

            say "Here is your quote"
            #show_rich_response do
            #    image "http://cl.ly/CXNm/Screen%20Shot%202011-12-11%20at%2011.26.52%20AM.png"
            #    text "Favorite Quote:"
            #    text "#{quote['quotes']}"
            #end
            object = SiriAddViews.new
            object.make_root(last_ref_id)
            answer = SiriAnswer.new("Favorite Quote", [
                                SiriAnswerLine.new('logo','http://cl.ly/CXNm/Screen%20Shot%202011-12-11%20at%2011.26.52%20AM.png'), # facebook logo
                                SiriAnswerLine.new(quoteText)
                                ])
            object.views << SiriAnswerSnippet.new([answer])
            send_object object

            #say "Reading quote...", 
            say "", spoken: "#{quote['quotes']}"             
   # say "Sometimes I don't write what I say", spoken: "Sometimes I don't say what I write"
              

          request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  listen_for /check facebook/i do
    
          page = HTTParty.get("https://api.facebook.com/method/notifications.getList?access_token=#{self.access_token}&format=json").body rescue nil
          
          notifications = JSON.parse(page) rescue nil
          count = 0
          
          say "Checking Facebook..."
            
          unless notifications.nil?
            notifications['notifications'].each do
              count = count + 1
            end
          end
            
            if count == 1
              say "You have #{count} new notification."
              notifications['notifications'].each do |item|
                say item['title_text']
              end
            end
            if count > 1
              say "You have #{count} new notifications."
              notifications['notifications'].each do |item|
                say item['title_text']
              end
            end
            
            if count == 0
              say "You have no new notifications."
            end
  
          request_completed #always complete your request! Otherwise the phone will "spin" at the user!
    end
    
    listen_for /kill proxy/i do
           2*kill*proxy
           
        request_completed #always complete your request! Otherwise the phone will "spin" at the user!
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
