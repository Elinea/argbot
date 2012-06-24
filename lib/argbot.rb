#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'argbot/irc'

module ARGBot
  VERSION = '0.3.5-alpha'
  IDENT = "ARGBot #{VERSION}"
  
  @@irc = ARGBot::IRC.new

  def self.start!(username, real_name, server, channels, exit_message)
    trap 'INT' do
      @@irc.stop!
    end
    
    @@irc.start!(username, real_name, server, channels, exit_message)
  end
  
  def self.cmd(klass, method, aliases, description, usage = nil)
    @@irc.cmd(klass, method, aliases, description, usage)
  end
end

AB = ARGBot

require 'argbot/cmd/analysis'
require 'argbot/cmd/convenience'
require 'argbot/cmd/crypto'
require 'argbot/cmd/general'
#require 'argbot/cmd/irb'
require 'argbot/cmd/translate'
require 'argbot/cmd/wiki'
