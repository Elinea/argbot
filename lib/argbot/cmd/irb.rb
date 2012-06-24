#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'timeout'
require 'fakefs/safe'

module ARGBot
  module IrbCommands
    def irb_swap(m, args)
      mask = m.user.mask
      @transient[:irb] ||= {}
      @transient[:irb][mask] = (@transient[:irb][mask].nil? || @transient[:irb][mask] == false)
    end
    
    def irb_eval(m, args)
      status = Timeout::timeout(5) do 
        FakeFS do
          error = false
          stdout_id = $stdout.to_i
          stderr_id = $stderr.to_i
          stdin_id = $stdin.to_i
          
          code = <<-EOF
            module Kernel
              def require(path)
                false
              end
            end
            
            $stdout = StringIO.new
            $stderr = StringIO.new
            $stdin = nil
            
            begin
              $SAFE = 3
              #{args}
            end
          EOF
          
          begin
            # Evaluate the code in a new binding
            result = Thread.new { eval code, TOPLEVEL_BINDING }.value
            $stdout.rewind
            output = $stdout.read
          rescue SecurityError
            m.reply "I'm sorry, #{m.user.nick}, I'm afraid I can't do that."
            error = true
          rescue Exception => e
            m.reply "#{e.to_s}"
            error = true
          ensure
            $stdout = IO.new(stdout_id)
            $stderr = IO.new(stderr_id)
            $stdin = IO.new(stdin_id)
          end
      
          unless error
            m.reply "#{output.gsub("\n", ' ')}"
            m.reply " => #{result.inspect}"
          end
        end
      end
    end
  end
  
  cmd :irb, :irb_swap, [:irb, :!], 'Puts you into (or removes you from) an interactive ruby session'
  cmd :irb, :irb_eval, [:eval, :e], 'Evaluates (heavily) sandboxed Ruby code', '%s <code>'
end