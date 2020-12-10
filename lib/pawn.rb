# frozen_string_literal: true

require_relative 'piece.rb'

class Pawn
  include Piece

  attr_reader :vulnerable_to_en_passant

  def initialize(game, player, location)
    super
    @direction = @location.first == 1 ? 1 : -1
    @vulnerable_to_en_passant = false
  end

  def symbol(color)
    color == 'white' ? "\u2659".encode : "\u265F".encode
  end

  def possible_moves(row, column)
    moves = []
    add_single_move_if_applicable(moves, row, column)
    add_double_move_if_applicable(moves, row, column)
    add_attack_moves_if_applicable(moves, row, column)
    clean_moves(moves)
  end

  def add_single_move_if_applicable(moves, row, column)
    single_move = [row + @direction, column]
    return if @game.piece_at(single_move)

    moves.push(single_move)
  end

  def add_double_move_if_applicable(moves, row, column)
    return if @moved

    single_move = [row + @direction, column]
    double_move = [row + (@direction * 2), column]
    return if @game.piece_at(single_move) || @game.piece_at(double_move)

    moves.push(double_move)
  end

  def add_attack_moves_if_applicable(moves, row, column)
    attack_right = [row + @direction, column + 1]
    attack_left = [row + @direction, column - 1]
    moves.push(attack_right) if @game.enemy_at?(@player, attack_right)
    moves.push(attack_left) if @game.enemy_at?(@player, attack_left)
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

  def move(to_location, test_move = false)
    @vulnerable_to_en_passant = true if (to_location.first - @location.first).abs == 2
    @location = to_location
    @moved = true unless test_move
  end

  def falsify_en_passant_vulnerability
    @vulnerable_to_en_passant = false
  end

  private

  def valid_pawn_move?(location)
    legal_pawn_move?(location) \
    && reachable?(self, location, @game.board)
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
