require 'cinch'
require 'date'
require 'open-uri'
require 'digest/md5'
require 'base64'

module ValveARG
  VERSION = '0.2.0'

  class Plugin
    include Cinch::Plugin
    
    listen_to :channel, :private

    def initialize(arg)
      super(arg)
      @commands = {
        [:status, :s] => {:method => :arg_status, :desc => 'Displays ARG status'},
        [:about, :a] => {:method => :arg_about, :desc => 'Displays ARGBot info'},
        [:help, :h] => {:method => :arg_help, :desc => 'Displays ARGBot help'},
        [:rules, :r] => {:method => :arg_rules, :desc => 'Displays IRC rules'},
        [:links, :l] => {:method => :arg_links, :desc => 'Displays relevant links'},
        [:hl3, :ep3] => {:method => :arg_hl3, :desc => 'Try it to find out!'},
        [:hex, :x] => {:method => :arg_hex, :desc => 'Converts decimal to hex.', :usage => '%s <decimal number> ...'},
        [:dec, :d] => {:method => :arg_dec, :desc => 'Converts hex to decimal.', :usage => '%s <hex number> ...'},
        [:shorten, :t] => {:method => :arg_shorten, :desc => 'Shortens a link.', :usage => '%s <url> ...'},
        [:count, :c] => {:method => :arg_count, :desc => 'Counts characters in a string.', :usage => '%s <words>'},
        [:wordcount, :wc, :w] => {:method => :arg_wc, :desc => 'Counts words.', :usage => '%s <words>'},
        [:md5sum, :md5, :m] => {:method => :arg_md5, :desc => 'Takes the MD5 hash of some text.', :usage => '%s <text>'},
        [:base64e, :base64, :b64] => {:method => :arg_base64e, :desc => 'Encodes a string with base64.', :usage => '%s <text>'},
        [:base64d, :b64d] => {:method => :arg_base64d, :desc => 'Decodes a base64-encoded string.', :usage => '%s <base64>'},
        [:rot13, :r13] => {:method => :arg_rot13, :desc => 'Encodes a string with rot13.', :usage => '%s <text>'}
      }
      
      @transient = {}
    end

    def listen(m)
      regex = if m.events.include?(:channel)
                /^!a(rg)?(?<cmd>\w+)\s*(?<args>.*)$/
              else
                /^((!)?arg)?(?<cmd>\w+)\s*(?<args>.*)$/
              end
      matches = m.message.strip.match(regex)
      found = false

      if !matches.nil? && !matches[:cmd].nil?
        cmd = matches[:cmd].downcase
        args = (matches[:args] || '').strip
        @commands.each do |k, v|
          k.each do |a|
            if a.to_s == cmd
              if !v[:usage].nil? && args.empty?
                m.user.msg "usage: #{k} #{v[:usage] % cmd}"
              else
                self.send(v[:method], m, args)
                return
              end
            end
          end
        end
      end
    end

    def arg_status(m, args)
      m.reply "#{m.user.nick}, the Pyro has torched EVERYTHING. Hang on."
    end
    
    def arg_about(m, args)
      m.reply "ARGBot #{VERSION} by Dovahkiin"
    end
    
    def arg_help(m, args)
      @commands.each {|k, v| m.user.msg "#{((v[:usage] || '%s') % k.collect{|e| e.to_s}.join(', '))}: #{v[:desc]}"}
    end

    def arg_rules(m, args)
      m.user.msg "Try to stay on topic, for the love of god. For example: Dinnerbone is a prettycoolguy and ZOMG MOJANG but that is not the purpose of this channel!"
      m.user.msg "Try to type with at least 3 words per line. It really cuts down on spam. \"hello\" or \"lol\" are not good uses of lines."
      m.user.msg "Don't ask to ask something, don't ask to say something, and post proof whenever you say something vaguely breaking; e.g. \"TF2 just updated for me, here's a screenshot of the changelog\" etc."
      m.user.msg "Jokes/off topic/speculation coming out of 4chan/\"I haven't been here for the last hour, what's going on?\" --> #valvearg3. #valvearg2 is for SOLVING and IMPORTANT RELEVANT DISCUSSION, not anything interesting you might want to say."
    end

    def arg_links(m, args)
      m.user.msg "Wiki: http://valvearg.com/tfhunt"
      m.user.msg "IRC Rules: http://valvearg.com/tfhunt/IRC_Rules"
      m.user.msg "TF2: http://www.teamfortress.com"
      m.user.msg "TF2 Wiki: http://wiki.teamfortress.com"
      m.user.msg "TF2 Wiki ARG Page: http://wiki.teamfortress.com/wiki/ARG"
    end

    def arg_hl3(m, args)
      @transient[:hl3_target] ||= Date.today.next
      @transient[:hl3_target] = transient[:target].next_month
      m.reply "Half-Life 3 delayed by one month. Current release target: #{@transient[:hl3_target].strftime('%F')}"
    end

    def arg_hex(m, args)
      m.reply "In hex: #{args.split.collect{|e| '0x' + e.gsub(/[^0-9]/, '').to_i.to_s(16)}.join(' ')}"
    end

    def arg_dec(m, args)
      m.reply "In decimal: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').hex.to_s}.join(' ')}"
    end

    def arg_shorten(m, args)
      shorten = ->(url) {
        ret = nil
        begin
          url = "http://#{url}" if !(url =~ /^http(s)?:\/\//)
          url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
          ret = url if url != "Error"
        rescue OpenURI::HTTPError
        end
        ret
      }

      m.reply "Shortened: #{args.split.collect{|e| shorten.call(e) || '<error>'}.join(' ')}"
    end

    def arg_count(m, args)
      return if args.empty?
      counts = args.split.collect{|e| e.downcase.gsub(/[^a-z0-9]/, '').length}
      m.reply "COUNT(\"#{args}\"): #{counts.join(' ')} (total: #{counts.inject{|sum, x| sum + x }})"
    end

    def arg_wc(m, args)
      return if args.empty?
      m.reply "WC(\"#{args}\"): #{args.split.count}"
    end

    def arg_md5(m, args)
      m.reply "MD5(\"#{args}\"): #{Digest::MD5.hexdigest(args)}"
    end

    def arg_base64e(m, args)
      m.reply "BASE64E(\"#{args}\"): #{Base64.encode64(args)}"
    end

    def arg_base64d(m, args)
      m.reply "BASE64D(\"#{args}\"): #{Base64.decode64(args)}"
    end

    def arg_rot13(m, args)
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
