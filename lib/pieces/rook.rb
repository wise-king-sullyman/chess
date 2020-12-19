# frozen_string_literal: true

require_relative 'piece'

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
