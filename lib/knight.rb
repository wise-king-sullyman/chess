# frozen_string_literal: true

require_relative 'piece.rb'

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
