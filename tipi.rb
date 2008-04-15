#!/usr/bin/env ruby
# TPG Usage Checker

require 'net/https'
require 'open-uri'
require 'date' # to allow Date.parse

def as_percent(a,b, precision = 2)
  c = a.to_f / b.to_f
  c = c * 100
  begin
    "%01.#{precision}f%%" % c
  rescue
    "#{c.round}%"
  end
rescue
  -1
end

class Tipi
  def initialize
    @url = URI.parse("https://cyberstore.tpg.com.au/your_account/index.php?function=checkaccountusage")
    @client = Net::HTTP.new(@url.host, @url.port)
    @client.use_ssl = true
  end
  
  def set_auth(user, pass)
    @form_data = {
      "check_username" => user,
      "password" => pass,
      "Submit" => "GO!"
    }
  end
  
  def check_usage    
    # @url.request_uri (@url.path does not include query string)
    req = Net::HTTP::Post.new(@url.request_uri)
    req.set_form_data(@form_data)
    
    result = @client.request(req)
    
    case result
    when Net::HTTPSuccess
      content = result.body

      # <b>Package Type:</b> ADSL2+/40GB+110GB Super</td>
      plan = content.match(/<b>Package Type:<\/b> (.*?)<\/td>/)[1]

      # <BR>Peak Download used: 4646.314 MB<br>
      peak = content.match(/<BR>Peak Download used: (\d+\.\d+) MB<br>/)[1]

      # <br>Off-Peak Download used: 5149.513 MB</td>
      offpeak = content.match(/<br>Off-Peak Download used: (\d+\.\d+) MB<\/td>/)[1]

      # <b>Expiry Date:</b> 05 Apr 2008</td>
      exp = content.match(/<b>Expiry Date:<\/b> (.*?)<\/td>/)[1]
      # exp = Time.parse(exp).strftime("%a, %d %b %Y")    
      exp = Date.parse(exp)
      
      t = Time.now

      { :plan => plan,
        :expiry_date => exp,
        :current => (t.hour < 3 or t.hour > 8) ? :on : :off,
        :on => peak, :off => offpeak,
        :pon => as_percent(peak, 40000), 
        :poff => as_percent(offpeak, 110000) }
    else
      nil
    end
  rescue
    nil
  end
end