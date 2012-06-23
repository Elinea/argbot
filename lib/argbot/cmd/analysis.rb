#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

module ARGBot
  module AnalysisCommands
    def an_count(m, args)
      return if args.empty?
      counts = args.split.collect{|e| e.downcase.gsub(/[^a-z0-9]/, '').length}
      m.reply "Letter counts: #{counts.join(' ')} (total: #{args.length}; just letters: #{counts.inject{|sum, x| sum + x }})"
    end

    def an_wordcount(m, args)
      return if args.empty?
      m.reply "Word count: #{args.gsub(/[^a-z0-9 ]/, '').split.count}"
    end
  end
  
  cmd :analysis, :an_count, [:count, :c], 'Counts characters in a string', '%s <words>'
  cmd :analysis, :an_wordcount, [:wordcount, :wc, :w], 'Counts words', '%s <words>'
end