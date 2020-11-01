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

  def enemy_king_location(calling_player)
    @players.first == calling_player ? @players.last.king_location : @players.first.king_location
  end

  def enemy_at?(calling_player, location)
    enemy_player = @players.first == calling_player ? @players.last : @players.first
    at_location = @board.piece_at(location)
    at_location.respond_to?(:parent) && at_location.parent == enemy_player
  end
end
