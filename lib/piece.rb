# frozen_string_literal: true

# serves as the template for all unique pieces
module Piece
  def initialize(location)
    @location = location
    @moved = false
  end

  def move(location)
    @location = location
    @moved = true
  end

  def legal_move?(move)
    true if possible_moves.include?(move)
  end

  def can_attack_king?
  end
end

class King
  include Piece

  def symbol(color)
    color == 'white' ? "\u2654".encode : "\u265A".encode
  end

  def possible_moves
    x = @location.first
    y = @location.last
    [
      [x + 1, y], [x, y + 1], [x + 1, y + 1], [x + 1, y - 1],
      [x - 1, y], [x, y - 1], [x - 1, y - 1], [x - 1, x + 1]
    ].keep_if { |move| move.all? { |number| number.between?(0, 7) } }
  end
end

class Queen
  include Piece

  def symbol(color)
    color == 'white' ? "\u2655".encode : "\u265B".encode
  end

  def possible_moves
    x = @location.first
    y = @location.last
    moves = []
    8.times do |number|
      moves.push([number, y], [x, number])
      moves.push(
        [x + number, y + number], [x + number, y - number],
        [x - number, y + number], [x - number, y - number]
      )
    end
    moves.delete(@location)
    moves.keep_if { |move| move.all? { |number| number.between?(0, 7) } }
  end
end

class Rook
  include Piece

  def symbol(color)
    color == 'white' ? "\u2656".encode : "\u265C".encode
  end

  def possible_moves
    x = @location.first
    y = @location.last
    moves = []
    8.times { |number| moves.push([number, y], [x, number]) }
    moves.delete(@location)
    moves.keep_if { |move| move.all? { |number| number.between?(0, 7) } }
  end
end

class Bishop
  include Piece

  def symbol(color)
    color == 'white' ? "\u2657".encode : "\u265D".encode
  end

  def possible_moves
    x = @location.first
    y = @location.last
    moves = []
    8.times do |number|
      moves.push(
        [x + number, y + number], [x + number, y - number],
        [x - number, y + number], [x - number, y - number]
      )
    end
    moves.delete(@location)
    moves.keep_if { |move| move.all? { |number| number.between?(0, 7) } }
  end
end

class Knight
  include Piece

  def symbol(color)
    color == 'white' ? "\u2658".encode : "\u265E".encode
  end

  def possible_moves
    x = @location.first
    y = @location.last
    [
      [x + 2, y + 1], [x - 2, y + 1], [x + 1, y + 2], [x - 1, y + 2],
      [x + 2, y - 1], [x - 2, y - 1], [x + 1, y - 2], [x - 1, y - 2]
    ].keep_if { |move| move.all? { |number| number.between?(0, 7) } }
  end
end

class Pawn
  include Piece

  def symbol(color)
    color == 'white' ? "\u2659".encode : "\u265F".encode
  end

  def possible_moves
  end
end
