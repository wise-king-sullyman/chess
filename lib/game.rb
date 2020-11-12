# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'player.rb'

# manage the game
class Game
  def initialize
    @over = false
    @winner = nil
    @players = [
      Player.new('player 1', 'white', self),
      Player.new('player 2', 'black', self)
    ]
    @board = Board.new(@players)
  end

  def move_piece(piece, location)
    at_location = @board.piece_at(location)
    at_location&.player&.remove_piece(at_location)
    piece.move(location)
    @board.refresh
  end

  def game_over?
  end

  def save
  end

  def load
  end

  def play
    loop do
      @players.each do |player|
        @board.refresh
        puts @board
        player.move
      end
    end
  end

  def enemy_king_location(calling_player)
    enemy_player = other_player(calling_player)
    enemy_player.king_location
  end

  def enemy_at?(calling_player, location)
    enemy_player = other_player(calling_player)
    at_location = @board.piece_at(location)
    at_location.respond_to?(:player) && at_location.player == enemy_player
  end

  def available?(player, location)
    at_location = @board.piece_at(location)
    return false if at_location.respond_to?(:player) && at_location.player == player

    true
  end

  def reachable?(piece, destination)
    from_row = piece.location.first
    from_column = piece.location.last
    to_row = destination.first
    to_column = destination.last

    return true if piece.class == Knight

    return row_reachable?(piece, destination) if from_row == to_row

    return column_reachable?(piece, destination) if from_column == to_column

    return false unless diagonal_reachable?(piece, destination)

    true
  end

  def piece_at(location)
    @board.piece_at(location)
  end

  private

  def row_reachable?(piece, to)
    from_column = piece.location.last
    range = to.last > from_column ? (from_column + 1...to.last) : (from_column - 1...to.last)
    range.each do |column|
      return false if piece_at([piece.location.first, column])
    end
    true
  end

  def column_reachable?(piece, to)
    from_row = piece.location.first
    range = to.first > from_row ? (from_row + 1...to.first) : (from_row - 1...to.first)
    range.each do |row|
      return false if piece_at([row, piece.location.last])
    end
    true
  end

  def diagonal_reachable?(piece, to)
    from_row = piece.location.first
    from_column = piece.location.last
    row_direction = from_row < to.first ? 1 : -1
    column_direction = from_column < to.last ? 1 : -1
    until from_row + row_direction == to.first && from_column + column_direction == to.last
      return false if piece_at([from_row += row_direction, from_column += column_direction])
    end
    true
  end

  def other_player(calling_player)
    player1 = @players.first
    player2 = @players.last
    player1 == calling_player ? player2 : player1
  end
end
