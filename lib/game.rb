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
      Player.new('player 1', 'white', self, @board),
      Player.new('player 2', 'black', self, @board)
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

  def available?(player, location)
    at_location = @board.piece_at(location)
    return false if at_location.respond_to?(:player) && at_location.player == player

    true
  end

  def reachable?(piece, destination)
    return true if piece.class == Knight

    from_row = piece.location.first
    from_column = piece.location.first
    to_row = destination.first
    to_column = destination.last
    row_range = from_row < to_row ? (from_row...to_row) : (to_row...from_row)
    column_range = from_column < to_column ? (from_column...to_column) : (to_column...from_column)
    if from_row == to_row 
      column_range.each do |column| 
        return false if enemy_at?(piece.player, [from_row, column])
      end
    elsif from_column == to_column
      row_range.each do |row|
        return false if enemy_at?(piece.player, [row, from_column])
      end
    else
      row_direction = from_row < to_row ? 1 : -1
      column_direction = from_column < to_column ? 1 : -1
      until from_row == to_row && from_column == to_column
        return false if enemy_at?(piece.player, [from_row += row_direction, from_column += column_direction])
      end
    end
    true
  end
end
