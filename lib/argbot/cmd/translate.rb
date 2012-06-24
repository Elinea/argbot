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
  
    def tr_hex(m, args)
      m.reply "In hex: #{args.split.collect{|e| '0x' + e.gsub(/[^0-9]/, '').to_i.to_s(16)}.join(' ')}"
    end

    def tr_dec(m, args)
      m.reply "In decimal: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').hex.to_s}.join(' ')}"
    end
    
    def tr_to_morse(m, args)
      m.reply "Morse: #{args.downcase.gsub(/(\s+|[^0-9a-z])/, '').gsub(/[0-9a-z]/) {|m| (@@morse[m] || ->(n){(n <= 5 ? ('.' * n) : ('-' * (n - 5))) + (n <= 5 ? ('-' * (5 - n)) : ('.' * (10 - n).abs))}.call(m.to_i)) + ' '}.rstrip}"
    end
    
    def tr_from_morse(m, args)
      m.reply "ASCII: #{args.split.collect {|a| ((@@morse_inverted ||= @@morse.invert)[(v = a.gsub(/[^\.-]/, ''))] || ->(m){((m.length == 5 && m =~ /\A(-|\.)\1*(-|\.)\2*\z/) ? (m.count('.') + m.gsub(/-+\z/, '').count('-') * 2) : nil)}.call(v)) || '?'}.join}"
    end
    
    def tr_to_mmph(m, args)
      m.reply 'Unimplemented.'
    end
    
    def tr_from_mmph(m, args)
      m.reply 'Unimplemented.'
    end
  end
  
  cmd :translate, :tr_hex, [:hex, :x], 'Translates decimal to hex', '%s <decimal number> ...'
  cmd :translate, :tr_dec, [:dec, :d], 'Translates hex to decimal', '%s <hex number> ...'
  cmd :translate, :tr_to_morse, [:tomorse, :morse, :tm], 'Translates ASCII to morse', '%s <ascii>'
  cmd :translate, :tr_from_morse, [:frommorse, :fm], 'Translates morse to ASCII', '%s <morse>'
  cmd :translate, :tr_to_mmph, [:tommph, :tmph, :tmp], 'Translates ASCII to Mmmmmph mmph', '%s <ascii>'
  cmd :translate, :tr_from_mmph, [:frommmph, :fmph, :fmp], 'Translates Mmmmmph mmph to ASCII', '%s <ascii>'
end
