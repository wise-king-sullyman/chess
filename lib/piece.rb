# frozen_string_literal: true

# serves as the template for all unique pieces
module Piece
  attr_reader :player, :location

  def initialize(game, player, location)
    @game = game
    @player = player
    @location = location
    @moved = false
  end

  def move(location)
    @location = location
    @moved = true
  end

  def legal_move?(move)
    possible_moves(@location.first, @location.last).include?(move)
  end

  def can_attack_king?
    valid_move?(@game.enemy_king_location(@player))
  end

  def can_attack_location?(location)
    valid_move?(location)
  end

  private

  def clean_moves(moves)
    moves.delete(@location)
    moves.keep_if { |move| move.all? { |number| number.between?(0, 7) } }
  end

  def apply_move_modifiers(modifiers, row, column)
    modifiers.map { |modifier| [row + modifier.first, column + modifier.last] }
  end

  def valid_move?(location)
    legal_move?(location) \
    && @game.available?(@player, location) \
    && @game.reachable?(self, location)
  end
end

class King
  include Piece

  def symbol(color)
    color == 'white' ? "\u2654".encode : "\u265A".encode
  end

  def can_move?
    possible_moves(@location.first, @location.last).empty? ? false : true
  end

  def can_attack_king?
    false
  end

  private

  def clean_moves(moves)
    super
    moves.delete_if { |move| @game.in_check_at?(@player, move) }
  end

  def possible_moves(row, column)
    modifiers = [1, 0, -1].product([1, 0, -1])
    moves = apply_move_modifiers(modifiers, row, column)
    clean_moves(moves)
  end
end

class Queen
  include Piece

  def symbol(color)
    color == 'white' ? "\u2655".encode : "\u265B".encode
  end

  private

  def possible_moves(row, column)
    moves = []
    8.times do |number|
      moves.push([number, column], [row, number])
      moves.push(
        [row + number, column + number], [row + number, column - number],
        [row - number, column + number], [row - number, column - number]
      )
    end
    clean_moves(moves)
  end
end

class Rook
  include Piece

  def symbol(color)
    color == 'white' ? "\u2656".encode : "\u265C".encode
  end

  private

  def possible_moves(row, column)
    moves = []
    8.times { |number| moves.push([number, column], [row, number]) }
    clean_moves(moves)
  end
end

class Bishop
  include Piece

  def symbol(color)
    color == 'white' ? "\u2657".encode : "\u265D".encode
  end

  private

  def possible_moves(row, column)
    moves = []
    8.times do |number|
      moves.push(
        [row + number, column + number], [row + number, column - number],
        [row - number, column + number], [row - number, column - number]
      )
    end
    clean_moves(moves)
  end
end

class Knight
  include Piece

  def symbol(color)
    color == 'white' ? "\u2658".encode : "\u265E".encode
  end

  private

  def possible_moves(row, column)
    modifiers = [2, -2].product([1, -1]) + [1, -1].product([2, -2])
    moves = apply_move_modifiers(modifiers, row, column)
    clean_moves(moves)
  end
end

class Pawn
  include Piece

  def initialize(game, player, location)
    super
    @direction = @location.first == 1 ? 1 : -1
  end

  def symbol(color)
    color == 'white' ? "\u2659".encode : "\u265F".encode
  end

  def possible_moves(row, column)
    moves = []
    unless @moved
      moves.push([row + @direction + @direction, column])
      @moved = true
    end
    moves.push([row + @direction, column])
    moves.push([row + @direction, column + 1]) if @game.enemy_at?(@player, [row + @direction, column + 1])
    moves.push([row + @direction, column - 1]) if @game.enemy_at?(@player, [row + @direction, column - 1])
    clean_moves(moves)
  end
end
