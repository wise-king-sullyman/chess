# frozen_string_literal: true

require 'board.rb'
require 'player.rb'

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

  def enemy_king_location(active_player)
    @players.first == active_player ? @players.last.king_location : @players.first.king_location
  end
end
