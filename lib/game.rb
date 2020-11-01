# frozen_string_literal: true

require 'board.rb'
require 'player.rb'

# manage the game
class Game
  def initialize
    @over = false
    @winner = nil
    @board = Board.new
    @players = [
      Player.new('player 1', 'white'),
      Player.new('player 2', 'black')
    ]
  end

  def game_over?
  end

  def save
  end

  def load
  end

  def play
  end

  def enemy_king_location(calling_player)
    player1 = @players.first
    player2 = @players.last
    player1 == calling_player ? player2.king_location : player1.king_location
  end

  def enemy_at?(calling_player, location)
    player1 = @players.first
    player2 = @players.last
    enemy_player = player1 == calling_player ? player2 : player1
    at_location = @board.piece_at(location)
    at_location.respond_to?(:player) && at_location.player == enemy_player
  end
end
