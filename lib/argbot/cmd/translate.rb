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
    }
    
    def tr_hex(m, args)
      m.reply "In hex: #{args.split.collect{|e| '0x' + e.gsub(/[^0-9]/, '').to_i.to_s(16)}.join(' ')}"
    end

    def tr_dec(m, args)
      m.reply "In decimal: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').hex.to_s}.join(' ')}"
    end
    
    def tr_from_morse(m, args)
      args.downcase.gsub(/(\s+|[^0-9a-z])/, '').gsub(/[0-9a-z]/) {|m| (@@morse[m] || ->(n){(n <= 5 ? ('.' * n) : ('-' * (n - 5))) + (n <= 5 ? ('-' * (5 - n)) : ('.' * (10 - n).abs))}.call(m.to_i)) + ' '}.rstrip
    end
    
    def tr_to_morse(m, args)
      args.split.collect {|a| ((@@morse_inverted ||= @@morse.invert)[(v = a.gsub(/[^\.-]/, ''))] || ->(m){((m.length == 5 && m =~ /\A(-|\.)\1*(-|\.)\2*\z/) ? (m.count('.') + m.gsub(/-+\z/, '').count('-') * 2) : nil)}.call(v)) || '?'}.join
    end
  end
  
  cmd :translate, :tr_hex, [:hex, :x], 'Translates decimal to hex', '%s <decimal number> ...'
  cmd :translate, :tr_dec, [:dec, :d], 'Translates hex to decimal', '%s <hex number> ...'
  cmd :translate, :tr_from_morse, [:frommorse, :fm], 'Translates morse to ASCII', '%s <morse>'
  cmd :translate, :tr_to_morse, [:tomorse, :morse, :tm], 'Translates ASCII to morse', '%s <ascii>'
end
