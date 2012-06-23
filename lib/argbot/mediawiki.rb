#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'argbot/http'
require 'json'

module ARGBot
  class MediaWiki
    def initialize(host, path)
      @host = host
      @path = path
    end

    def get_page(page)
      content = nil
      res = HTTP.get(:host => @host, :path => "#{@path}/api.php", :query => URI.encode_www_form('format' => 'json', 'action' => 'query', 'titles' => page, 'prop' => 'revisions', 'rvprop' => 'content'))
      if res.is_a?(Net::HTTPSuccess)
        begin
          obj = JSON.parse(res.body)
          page = obj['query']['pages'].values.first
          content = page['revisions'].first['*']
        rescue JSON::ParserError
          content
        end
      end

      content
    end
  end
end
