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

  def move(location, test_move = false)
    @location = location
    @moved = true unless test_move
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
    valid_moves(@location).empty? ? false : true
  end

  def eligible_for_promotion?
    false
  end

  def valid_move?(location)
    legal_move?(location) \
    && @game.available?(@player, location) \
    && @game.reachable?(self, location)
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

  def valid_moves(location)
    possible_moves(location.first, location.last).select do |move|
      @game.available?(@player, move) && @game.reachable?(self, move)
    end
  end
end
