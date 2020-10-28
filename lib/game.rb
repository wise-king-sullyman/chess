# frozen_string_literal: true

# manage the game
class Game
  def initialize
    @over = false
    @winner = nil
    @board = Board.new
    @players = [Player.new('player 1', 'white'), Player.new('player 2', 'black')]
  end

  def game_over?
  end

  def save
  end

  def load
  end

  def play
  end
end
