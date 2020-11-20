# frozen_string_literal: true

require_relative 'piece.rb'

class King
  include Piece

  def symbol(color)
    color == 'white' ? "\u2654".encode : "\u265A".encode
  end

  def can_attack_king?
    false
  end

  private

  def clean_moves(moves)
    super
    moves.keep_if { |move| @game.available?(@player, move) }
    moves.delete_if { |move| @game.in_check_at?(@player, move) }
    moves.keep_if { |move| @game.reachable?(self, move) }
  end

  def possible_moves(row, column)
    modifiers = [1, 0, -1].product([1, 0, -1])
    moves = apply_move_modifiers(modifiers, row, column)
    clean_moves(moves)
  end
end
