#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'date'

module ARGBot
  module GeneralCommands
    def ge_about(m, args)
      m.reply "#{AB::IDENT} by Dovahkiin"
      m.reply "Fork me on Github: http://github.com/integ3r/argbot"
    end
    
    def ge_help(m, args)
      m.user.msg AB::IDENT
      m.user.msg "Commands can be entered in the forms !arg<cmd> or !a<cmd>."
      @commands.each {|k, v| m.user.msg "#{((v[:usage] || '%s') % k.collect{|e| e.to_s}.join(', '))}: #{v[:desc]}"}
    end

    def ge_rules(m, args)
      m.user.msg "Try to stay on topic, for the love of god. For example: Dinnerbone is a prettycoolguy and ZOMG MOJANG but that is not the purpose of this channel!"
      m.user.msg "Try to type with at least 3 words per line. It really cuts down on spam. \"hello\" or \"lol\" are not good uses of lines."
      m.user.msg "Don't ask to ask something, don't ask to say something, and post proof whenever you say something vaguely breaking; e.g. \"TF2 just updated for me, here's a screenshot of the changelog\" etc."
      m.user.msg "Jokes/off topic/speculation coming out of 4chan/\"I haven't been here for the last hour, what's going on?\" --> #valvearg3. #valvearg2 is for SOLVING and IMPORTANT RELEVANT DISCUSSION, not anything interesting you might want to say."
    end

    def ge_links(m, args)
      m.user.msg "Wiki: http://valvearg.com/tfhunt"
      m.user.msg "IRC Rules: http://valvearg.com/tfhunt/IRC_Rules"
      m.user.msg "TF2: http://www.tf2.com"
      m.user.msg "TF2 Wiki: http://wiki.tf"
      m.user.msg "TF2 Wiki ARG Page: http://wiki.tf/wiki/ARG"
    end

    def ge_hl3(m, args)
      @transient[:hl3_target] ||= Date.today.next
      @transient[:hl3_target] = @transient[:hl3_target].next_month
      m.reply "Half-Life 3 delayed by one month. Current release target: #{@transient[:hl3_target].strftime('%F')}"
    end
  end

  cmd :general, :ge_about, [:about, :a], 'Displays ARGBot info'
  cmd :general, :ge_help, [:help, :h], 'Displays ARGBot help'
  cmd :general, :ge_rules, [:rules, :r], 'Displays IRC rules'
  cmd :general, :ge_links, [:links, :l], 'Displays relevant links'
  cmd :general, :ge_hl3, [:hl3, :ep3], 'Try it to find out!'
end