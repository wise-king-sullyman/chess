# frozen_string_literal: true

require_relative 'piece.rb'

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
