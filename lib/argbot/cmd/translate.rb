#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

module ARGBot
  module TranslateCommands
  
    @@morse = {
      'a' => '.-',
      'b' => '-...',
      'c' => '-.-.',
      'd' => '-..',
      'e' => '.',
      'f' => '..-.',
      'g' => '--.',
      'h' => '....',
      'i' => '..',
      'j' => '.---',
      'k' => '-.-',
      'l' => '.-..',
      'm' => '--',
      'n' => '-.',
      'o' => '---',
      'p' => '.--.',
      'q' => '--.-',
      'r' => '.-.',
      's' => '...',
      't' => '-',
      'u' => '..-',
      'v' => '...-',
      'w' => '.--',
      'x' => '-..-',
      'y' => '-.--',
      'z' => '--..'
      
      # The rest of this was a deal with a friend to
      # algorithmically parse some part of Morse Code.
      # This insanity was the result.
      
      # Efficiency should be about the same for letters.
      # Numbers are done algorithmically, with a guarantee for
      # accuracy but no guarantee for speed.
      
      # This wasn't meant to be production-grade code. It was for fun.
    }
    
    def tr_asc_to_bin(m, args)
      m.user.msg "ASCII => BINARY: #{args.bytes.to_a.collect{|e| e.to_s(2)}.join(' ')}"
    end
    
    def tr_asc_to_dec(m, args)
      m.user.msg "ASCII => DEC: #{args.bytes.to_a.collect{|e| e.to_s(10)}.join(' ')}"
    end
    
    def tr_asc_to_hex(m, args)
      m.user.msg "ASCII => HEX: #{args.bytes.to_a.collect{|e| '0x' + e.to_s(16)}.join(' ')}"
    end
    
    def tr_bin_to_asc(m, args)
      m.user.msg "BINARY => ASCII: #{args.split.collect{|e| e.gsub(/[^0-1]/, '').to_i(2).chr}.join}"
    end
    
    def tr_bin_to_dec(m, args)
      m.user.msg "BINARY => DEC: #{args.split.collect{|e| e.gsub(/[^0-1]/, '').to_i(2).to_s(10)}.join(' ')}"
    end
    
    def tr_bin_to_hex(m, args)
      m.user.msg "BINARY => HEX: #{args.split.collect{|e| '0x' + e.gsub(/[^0-1]/, '').to_i(2).to_s(16)}.join(' ')}"
    end
    
    def tr_dec_to_asc(m, args)
      m.user.msg "DEC => ASCII: #{args.split.collect{|e| e.gsub(/[^0-9]/, '').to_i(10).chr}.join}"
    end
    
    def tr_dec_to_hex(m, args)
      m.user.msg "DEC => HEX: #{args.split.collect{|e| '0x' + e.gsub(/[^0-9]/, '').to_i(10).to_s(16)}.join(' ')}"
    end
    
    def tr_dec_to_bin(m, args)
      m.reply "DEC => BINARY: #{args.split.collect{|e| e.gsub(/[^0-9]/, '').to_i(10).to_s(2)}.join(' ')}"
    end
    
    def tr_hex_to_asc(m, args)
      m.user.msg "HEX => ASCII: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').to_i(16).chr}.join}"
    end
    
    def tr_hex_to_dec(m, args)
      m.user.msg "HEX => DEC: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').to_i(16).to_s(10)}.join(' ')}"
    end
    
    def tr_hex_to_bin(m, args)
      m.user.msg "HEX => BINARY: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').to_i(16).to_s(2)}.join(' ')}"
    end
    
    def tr_asc_to_morse(m, args)
      m.user.msg "Morse: #{args.downcase.gsub(/(\s+|[^0-9a-z])/, '').gsub(/[0-9a-z]/) {|m| (@@morse[m] || ->(n){(n <= 5 ? ('.' * n) : ('-' * (n - 5))) + (n <= 5 ? ('-' * (5 - n)) : ('.' * (10 - n).abs))}.call(m.to_i)) + ' '}.rstrip}"
    end
    
    def tr_morse_to_asc(m, args)
      m.user.msg "ASCII: #{args.split.collect {|a| ((@@morse_inverted ||= @@morse.invert)[(v = a.gsub(/[^\.-]/, ''))] || ->(m){((m.length == 5 && m =~ /\A(-|\.)\1*(-|\.)\2*\z/) ? (m.count('.') + m.gsub(/-+\z/, '').count('-') * 2) : nil)}.call(v)) || '?'}.join}"
    end
    
    def tr_asc_to_mmph(m, args)
      words = args.split
      words.collect do |word|
        upcase = (word =~ /\A[:upper:]+/)
        len, half_len, last_char, idx = word.length, word.length / 2, word.length - 1, 0
        
        word.downcase!
        word.gsub!(/\w/) do |match|
          if idx < half_len && idx != last_char
            char = 'm'
          elsif idx >= half_len && idx != last_char
            char = 'h'
          elsif idx == last_char
            char = (rand(0..1) == 1 ? 'p' : (rand(0..1) == 1 ? 'm' : 'h'))
          end
          
          idx += 1
          
          char
        end
          
        word.capitalize! if upcase
        
        word
      end
      
      m.reply "#{m.user.nick}: #{words.join(' ')}"
    end
  end
  
  cmd :translate, :tr_asc_to_bin, [:asc2bin, :a2b, :ab], 'Translates ASCII to binary', '%s <ascii>'
  cmd :translate, :tr_asc_to_dec, [:asc2dec, :a2d, :ad], 'Translates ASCII to decimal', '%s <ascii>'
  cmd :translate, :tr_asc_to_hex, [:asc2hex, :a2x, :ax], 'Translates ASCII to hex', '%s <ascii>'
  cmd :translate, :tr_bin_to_asc, [:bin2asc, :b2a, :ba], 'Translates binary to ASCII', '%s <binary>'
  cmd :translate, :tr_bin_to_dec, [:bin2dec, :b2d, :bd], 'Translates binary to decimal', '%s <binary>'
  cmd :translate, :tr_bin_to_hex, [:bin2hex, :b2h, :bx], 'Translates binary to hex', '%s <binary>'
  cmd :translate, :tr_dec_to_asc, [:dec2asc, :d2a, :da], 'Translates decimal to ASCII', '%s <decimal>'
  cmd :translate, :tr_dec_to_hex, [:dec2hex, :d2h, :dx], 'Translates decimal to hex', '%s <decimal>'
  cmd :translate, :tr_dec_to_bin, [:dec2bin, :d2b, :db], 'Translates decimal to binary', '%s <decimal>'
  cmd :translate, :tr_hex_to_asc, [:hex2asc, :x2a, :xa], 'Translates hex to ASCII', '%s <hex>'
  cmd :translate, :tr_hex_to_dec, [:hex2dec, :x2d, :xd], 'Translates hex to decimal', '%s <hex>'
  cmd :translate, :tr_hex_to_bin, [:hex2bin, :x2b, :xb], 'Translates hex to binary', '%s <hex>'
  cmd :translate, :tr_asc_to_morse, [:asc2morse, :morse, :a2m, :tm], 'Translates ASCII to morse', '%s <ascii>'
  cmd :translate, :tr_morse_to_asc, [:morse2asc, :m2a, :fm], 'Translates morse to ASCII', '%s <morse>'
  cmd :translate, :tr_asc_to_mmph, [:asc2mmph, :a2mph, :a2mp, :mmph], 'Translates ASCII to Mmmmmph mmph', '%s <ascii>'
end
