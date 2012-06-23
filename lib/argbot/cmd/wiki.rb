#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'argbot/mediawiki'

module ARGBot
  module WikiCommands
    @@wiki = AB::MediaWiki.new('valvearg.com', '/tfhunt_w')
    def wk_status(s, args)
      focus = @@wiki.get_page('Current_Focus')
      s.reply "Current focus: #{focus.strip}" unless focus.nil?
    end

    def wk_news(s, args)
      news = @@wiki.get_page('Template:News')
      s.reply "Latest news: #{news.match(/^\s*?\*(?<news>.+)\s*$/)[1].gsub(/'+/, '')}" unless news.nil?
    end
  end
  
  cmd :wiki, :wk_status, [:status, :s], 'Displays ARG status'
  cmd :wiki, :wk_news, [:news, :n], 'Displays the latest ARG news entry'
end
