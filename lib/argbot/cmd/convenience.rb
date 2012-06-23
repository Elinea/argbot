#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'argbot/http'

module ARGBot
  module ConvenienceCommands
    def cv_shorten(m, args)
      shorten = ->(url) {
        ret = nil
        response = AB::HTTP.get(:host => 'tinyurl.com', :path => '/api-create.php', :query => URI.encode_www_form('url' => URI.escape(url =~ /^http(s)?:\/\// ? url : "http://#{url}")))
        if response.is_a?(Net::HTTPSuccess)
          ret = response.body unless response.body.downcase == 'error'
        end
        ret
      }

      m.reply "Shortened: #{args.split.collect{|e| shorten.call(e) || '<error>'}.join(' ')}"
    end
  end
  
  cmd :convenience, :cv_shorten, [:shorten, :t], 'Shortens a link', '%s <url> ...'
end
