# frozen_string_literal: true

require_relative 'piece.rb'

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
