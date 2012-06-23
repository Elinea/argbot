#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'net/http'

module ARGBot
  class HTTP
    USER_AGENT = AB::IDENT.gsub(/\s+/, '/')
    def self.get(url = {})
      uri = URI::HTTP.build(url)
      req = Net::HTTP::Get.new(uri.request_uri)
      req['User-Agent'] = USER_AGENT
      Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req)}
    end
  end
end
