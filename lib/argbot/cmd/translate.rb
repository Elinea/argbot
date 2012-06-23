#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

module ARGBot
  module TranslateCommands
    def tr_hex(m, args)
      m.reply "In hex: #{args.split.collect{|e| '0x' + e.gsub(/[^0-9]/, '').to_i.to_s(16)}.join(' ')}"
    end

    def tr_dec(m, args)
      m.reply "In decimal: #{args.split.collect{|e| e.gsub(/[^0-9a-f]/, '').hex.to_s}.join(' ')}"
    end
  end
  
  cmd :translate, :tr_hex, [:hex, :x], 'Translates decimal to hex', '%s <decimal number> ...'
  cmd :translate, :tr_dec, [:dec, :d], 'Translates hex to decimal', '%s <hex number> ...'
end
