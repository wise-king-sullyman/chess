# frozen_string_literal: true

require_relative 'piece.rb'

class King
  include Piece

  def symbol(color)
    color == 'white' ? "\u2654".encode : "\u265A".encode
  end

  def can_attack_king?
    moves = uncleaned_moves(@location.first, @location.last)
    moves.include?(@game.enemy_king_location(@player)) ? true : false
  end

  private

  def uncleaned_moves(row, column)
    modifiers = [1, 0, -1].product([1, 0, -1])
    apply_move_modifiers(modifiers, row, column)
  end

  def possible_moves(row, column)
    clean_moves(uncleaned_moves(row, column))
  end
end
