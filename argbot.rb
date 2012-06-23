require 'cinch'
require 'date'
require 'open-uri'
require 'digest/md5'
require 'base64'

module ValveARG
  VERSION = '0.1.0'

  class Plugin
    include Cinch::Plugin
    
    listen_to :channel, :private

    def listen(m)
      regex = if m.events.include?(:channel)
                /^!a(rg)?(?<cmd>\w+)\s*(?<args>.*)$/
              else
                /^((!)?arg)?(?<cmd>\w+)\s*(?<args>.*)$/
              end
      matches = m.message.strip.match(regex)
      fn = "arg_#{matches[:cmd].downcase}".to_sym if !matches.nil? && !matches[:cmd].nil?
      @transient ||= {}

      if !matches.nil? && !matches[:cmd].nil? && self.respond_to?(fn)
        @transient[fn] ||= {}
        @transient[fn] = self.send(fn, m, matches[:args], @transient[fn])
      elsif !matches.nil? && !matches[:cmd].nil? && !self.respond_to?(fn)
        m.user.msg "Invalid !a(rg) command."
        self.arg_help(m, '', {})
      end
    end
    
    def arg_status(m, args, transient)
      m.reply "#{m.user.nick}, the Pyro has torched EVERYTHING. Hang on."
      transient
    end
    
    def arg_about(m, args, transient)
      m.reply "ARGBot #{VERSION} by Dovahkiin"
    end
    
    def arg_help(m, args, transient)
      m.user.msg "Valid commands: #{ValveARG::Plugin.instance_methods.collect{|e| (e.to_s.match(/^arg_(?<cmd>\w+)$/) || {})[:cmd]}.reject{|e| e.nil?}.sort.join(', ')}"
    end

    def arg_rules(m, args, transient)
      m.user.msg "Try to stay on topic, for the love of god. For example: Dinnerbone is a prettycoolguy and ZOMG MOJANG but that is not the purpose of this channel!"
      m.user.msg "Try to type with at least 3 words per line. It really cuts down on spam. \"hello\" or \"lol\" are not good uses of lines."
      m.user.msg "Don't ask to ask something, don't ask to say something, and post proof whenever you say something vaguely breaking; e.g. \"TF2 just updated for me, here's a screenshot of the changelog\" etc."
      m.user.msg "Jokes/off topic/speculation coming out of 4chan/\"I haven't been here for the last hour, what's going on?\" --> #valvearg3. #valvearg2 is for SOLVING and IMPORTANT RELEVANT DISCUSSION, not anything interesting you might want to say."
    end

    def arg_links(m, args, transient)
      m.user.msg "Wiki: http://valvearg.com/tfhunt"
      m.user.msg "IRC Rules: http://valvearg.com/tfhunt/IRC_Rules"
    end

    def arg_hex(m, args, transient)
      m.reply "In hex: #{args.split.collect{|e| '0x' + e.gsub(/[^0-9]/, '').to_i.to_s(16)}.join(' ')}"
    end

    def arg_dec(m, args, transient)
      m.reply "In decimal: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').hex.to_s}.join(' ')}"
    end

    def arg_shorten(m, args, transient)
      shorten = ->(url) {
        ret = nil
        begin
          url = "http://#{url}" if !url.match(/^http(s)?:\/\//)
          url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
          ret = url if url != "Error"
        rescue OpenURI::HTTPError
        end
        ret
      }

      m.reply "Shortened: #{args.split.collect{|e| shorten.call(e) || '<error>'}.join(' ')}"
    end

    def arg_hl3(m, args, transient)
      transient[:target] ||= Date.today.next
      transient[:target] = transient[:target].next_month
      m.reply "Half-Life 3 delayed by one month. Current release target: #{transient[:target].strftime('%F')}"
      transient
    end

    def arg_count(m, args, transient)
      args = args.split.collect{|e| e.downcase.gsub(/[^a-z0-9]/, '').length}
      m.reply "Character counts: #{args.join(' ')} (total: #{args.inject{|sum, x| sum + x }})"
    end

    def arg_wc(m, args, transient)
      m.reply "Word count: #{args.split.count}"
    end

    def arg_md5(m, args, transient)
      m.reply "MD5(\"#{args}\"): #{Digest::MD5.hexdigest(args)}"
    end

    def arg_base64(m, args, transient)
      m.reply "BASE64(\"#{args}\"): #{Base64.encode64(args)}"
    end

    def arg_base64d(m, args, transient)
      m.reply "ASCII(\"#{args}\"): #{Base64.decode64(args)}"
    end

    def arg_rot13(m, args, transient)
      m.reply "ROT13(\"#{args}\"): #{args.tr 'A-Za-z', 'N-ZA-Mn-za-m'}"
    end
  end

  def self.start!
    @@bot = Cinch::Bot.new do
      configure do |c|
        c.user = c.nick = 'ARGBot'
        c.realname = 'Dovahkiin'
        c.server = 'irc.gamesurge.net'
        c.channels = ["#valvearg2", "#valvearg3"]
        c.plugins.plugins = [ValveARG::Plugin]
      end
    end

    @@bot.start
  end
end

ValveARG::start!
