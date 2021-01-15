# frozen_string_literal: true

require_relative '../move_validation'

# serves as the template for all unique pieces
module Piece
  include MoveValidation

  attr_reader :player, :location, :moved, :game

  def initialize(game, player, location)
    @game = game
    @player = player
    @location = location
    @moved = false
  end

  def move(location, test_move = false)
    self.location = location
    self.moved = true unless test_move
  end

  def legal_move?(move)
    possible_moves(location.first, location.last).include?(move)
  end

  def can_attack_king?
    can_attack_location?(game.enemy_king_location(player))
  end

  def can_attack_location?(location)
    legal_move?(location) \
    && reachable?(self, location, game.board)
  end

  def can_move?
    valid_moves(self, location, game.board).empty? ? false : true
  end

  def eligible_for_promotion?
    false
  end

  def clean_moves(moves)
    remove_at_current_location_move(moves, location)
    remove_out_of_bounds_moves(0, 7, moves)
    remove_self_checks(moves) unless callers_include?('can_attack_king?')
    moves
  end

  def remove_at_current_location_move(moves, current_location)
    moves.delete(current_location)
    moves
  end

  def remove_out_of_bounds_moves(lower_bound, upper_bound, moves)
    moves.keep_if do |move|
      move.all? { |number| number.between?(lower_bound, upper_bound) }
    end
    moves
  end

  def remove_self_checks(moves)
    moves.delete_if do |move|
      game.move_checks_self?(self, move, game.board)
    end
    moves
  end

  def callers_include?(function_name_as_string)
    caller_locations.any? do |caller|
      caller.to_s.include?(function_name_as_string)
    end
  end

  private

  attr_writer :location, :moved

  def apply_move_modifiers(modifiers, row, column)
    modifiers.map { |modifier| [row + modifier.first, column + modifier.last] }
  end
end
