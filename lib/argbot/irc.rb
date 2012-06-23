#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_| 

require 'cinch'

require 'argbot/plugin'

module ARGBot
  class IRC
    def start!(username, real_name, server, channels)
      @bot = Cinch::Bot.new do
        configure do |c|
          c.user = c.nick = username
          c.realname = real_name
          c.server = server
          c.channels = (channels.is_a?(Array) ? channels : [channels])
          c.plugins.plugins = [ARGBot::Plugin]
        end
      end
      @bot.start
    end
    
    def cmd(klass, method, aliases, description, usage)
      c = AB.const_get("#{klass.to_s.capitalize}Commands")
      AB::Plugin.send(:include, c) unless AB::Plugin.ancestors.include?(c)
      AB::Plugin.cmd(aliases, {:method => method, :desc => description, :usage => usage})
    end
  end
end