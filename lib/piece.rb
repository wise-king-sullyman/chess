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
    legal_move?(location) \
    && @game.reachable?(self, location)
  end

  def can_move?
    possible_moves(@location.first, @location.last).empty? ? false : true
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
