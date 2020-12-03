# frozen_string_literal: true

require_relative 'move_validation.rb'

# serves as the template for all unique pieces
module Piece
  include MoveValidation

  attr_reader :player, :location, :moved

  def initialize(game, player, location)
    @game = game
    @player = player
    @location = location
    @moved = false
  end

  def move(location, test_move = false)
    @location = location
    @moved = true unless test_move
  end

  def legal_move?(move)
    possible_moves(@location.first, @location.last).include?(move)
  end

  def can_attack_king?
    can_attack_location?(@game.enemy_king_location(@player))
  end

  def can_attack_location?(location)
    legal_move?(location) \
    && reachable?(self, location, @game.board)
  end

  def can_move?
    valid_moves(self, @location, @game.board).empty? ? false : true
  end

  def eligible_for_promotion?
    false
  end

  private

  def clean_moves(moves)
    calling_method_name = caller_locations[3].to_s.split(' ').last
    moves.delete(@location)
    moves.keep_if { |move| move.all? { |number| number.between?(0, 7) } }
    unless calling_method_name == "`can_attack_king?'"
      moves.delete_if do |move|
        @game.move_checks_self?(self, move)
      end
    end
    moves
  end

  def apply_move_modifiers(modifiers, row, column)
    modifiers.map { |modifier| [row + modifier.first, column + modifier.last] }
  end
end
