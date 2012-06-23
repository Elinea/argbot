#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_| 

module ARGBot
  class Plugin
    include Cinch::Plugin
    
    listen_to :channel, :private
    
    @@commands = {}
    
    def self.cmd(aliases, opts)
      @@commands[aliases] = opts
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
        @@commands.each do |k, v|
          k.each do |a|
            if a.to_s == cmd
              if !v[:usage].nil? && args.empty?
                m.user.msg "usage: #{k} #{v[:usage] % cmd}"
              else
                @transient ||= {}
                @commands ||= @@commands
                self.send(v[:method], m, args)
              end
            end
          end
        end
      end
    end
  end
end