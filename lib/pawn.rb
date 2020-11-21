# frozen_string_literal: true

require_relative 'piece.rb'

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
    unless @moved || @game.piece_at([row + @direction, column]) || @game.piece_at([row + @direction + @direction, column])
      moves.push([row + @direction + @direction, column])
    end
    moves.push([row + @direction, column]) unless @game.piece_at([row + @direction, column])
    moves.push([row + @direction, column + 1]) if @game.enemy_at?(@player, [row + @direction, column + 1])
    moves.push([row + @direction, column - 1]) if @game.enemy_at?(@player, [row + @direction, column - 1])
    clean_moves(moves)
  end

  def can_attack_location?(location)
    valid_pawn_move?(location)
  end

  def can_attack_king?
    valid_pawn_move?(@game.enemy_king_location(@player))
  end

  def eligible_for_promotion?
    return true if @direction.positive? && @location.first == 7

    return true if @direction.negative? && @location.first.zero?

    false
  end

  private

  def valid_pawn_move?(location)
    legal_pawn_move?(location) \
    && @game.reachable?(self, location)
  end

  def legal_pawn_move?(move)
    possible_pawn_attack_moves(@location.first, @location.last).include?(move)
  end

  def possible_pawn_attack_moves(row, column)
    moves = []
    moves.push([row + @direction, column + 1])
    moves.push([row + @direction, column - 1])
    clean_moves(moves)
  end
end
