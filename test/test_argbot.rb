require 'test/unit'
require 'argbot'

class ARGBotTest < Test::Unit::TestCase
  def test_argbot
    ARGBot.start!('ARGBot', 'Dovahkiin', 'irc.gamesurge.net', '#valvearg3')
  end
end