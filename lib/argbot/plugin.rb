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
                /^!(!|a(rg)?)(?<cmd>\w+)(?<flip>^)?\s*(?<args>.*)$/
              else
                /^((!)?(!)?arg)?(?<cmd>\w+)(?<flip>^)?\s*(?<args>.*)$/
              end
      matches = m.message.strip.match(regex)
      found = false

      if !matches.nil? && !matches[:cmd].nil?
        cmd = matches[:cmd].downcase
        args = (matches[:args] || '').strip
        aliases, opts = AB::Plugin.get_cmd(cmd)
        
        if !opts[:usage].nil? && args.empty?
          m.user.msg AB::Plugin.usage(aliases, opts)
        else
          @transient ||= {}
          @commands ||= @@commands
          destination = (matches[:flip].nil? 
          self.send(opts[:method], m, args)
        end
      end
    end
    
    def self.get_cmd(cmd)
      @@commands.each do |k, v|
        k.each do |a|
          return k, v if a.to_s == cmd
        end
      end
    end
    
    def self.usage(aliases, opts)
      "#{(opts[:usage] || '%s') % aliases.join(', ')} [#{opts[:desc]}]"
    end
  end
end