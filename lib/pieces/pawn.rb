# frozen_string_literal: true

require_relative 'piece'

class Pawn
  include Piece

  attr_reader :direction, :vulnerable_to_en_passant

  def initialize(game, player, location)
    super
    @direction = location.first == 1 ? 1 : -1
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
    add_en_passant_moves_if_applicable(moves, row, column)
    clean_moves(moves)
  end

  def add_single_move_if_applicable(moves, row, column)
    single_move = [row + direction, column]
    return if game.piece_at(single_move)

    moves.push(single_move)
  end

  def add_double_move_if_applicable(moves, row, column)
    return if moved

    single_move = [row + direction, column]
    double_move = [row + (direction * 2), column]
    return if game.piece_at(single_move) || game.piece_at(double_move)

    moves.push(double_move)
  end

  def add_attack_moves_if_applicable(moves, row, column)
    right_diagonal = diagonal_right(row, column)
    left_diagonal = diagonal_left(row, column)
    moves.push(diagonal_right(row, column)) if can_attack?(right_diagonal)
    moves.push(diagonal_left(row, column)) if can_attack?(left_diagonal)
  end

  def add_en_passant_moves_if_applicable(moves, row, column)
    right_piece = orthogonal_right_piece(row, column)
    left_piece = orthogonal_left_piece(row, column)
    moves.push(diagonal_right(row, column)) if can_en_passant?(right_piece)
    moves.push(diagonal_left(row, column)) if can_en_passant?(left_piece)
  end

  def diagonal_right(row, column)
    [row + direction, column + 1]
  end

  def diagonal_left(row, column)
    [row + direction, column - 1]
  end

  def can_attack?(location)
    game.enemy_at?(player, location)
  end

  def orthogonal_right_piece(row, column)
    game.piece_at([row, column + 1])
  end

  def orthogonal_left_piece(row, column)
    game.piece_at([row, column - 1])
  end

  def can_en_passant?(piece)
    piece.respond_to?('vulnerable_to_en_passant') \
    && game.enemy_at?(player, piece.location) \
    && piece.vulnerable_to_en_passant
  end

  def can_attack_location?(location)
    valid_pawn_move?(location)
  end

  def can_attack_king?
    valid_pawn_move?(game.enemy_king_location(player))
  end

  def eligible_for_promotion?
    return true if direction.positive? && location.first == 7

    return true if direction.negative? && location.first.zero?

    false
  end

  def move(to_location, test_move = false)
    capture_enemy_if_en_passant_performed(to_location)
    truthify_en_passant_vulnerability if en_passantable?(to_location, test_move)
    self.location = to_location
    self.moved = true unless test_move
  end

  def en_passant_performed?(piece, to_location)
    can_en_passant?(piece) \
    && piece.location == [to_location.first - direction, to_location.last]
  end

  def capture(piece)
    piece.player.remove_piece(piece)
  end

  def falsify_en_passant_vulnerability
    self.vulnerable_to_en_passant = false
  end

  def truthify_en_passant_vulnerability
    self.vulnerable_to_en_passant = true
  end

  def double_move_performed?(to_location)
    (to_location.first - location.first).abs == 2
  end

  def en_passantable?(to_location, test_move)
    return false if test_move

    double_move_performed?(to_location)
  end

  def piece_behind_move(to_location)
    game.piece_at([to_location.first - direction, to_location.last])
  end

  def capture_enemy_if_en_passant_performed(move_location)
    en_passant_piece = piece_behind_move(move_location)
    return unless en_passant_performed?(en_passant_piece, move_location)

    capture(en_passant_piece)
  end

  def valid_pawn_move?(location)
    legal_pawn_move?(location) \
    && reachable?(self, location, game.board)
  end

  private

  attr_writer :vulnerable_to_en_passant

  def legal_pawn_move?(move)
    possible_pawn_attack_moves(location.first, location.last).include?(move)
  end

  def possible_pawn_attack_moves(row, column)
    moves = []
    moves.push([row + direction, column + 1])
    moves.push([row + direction, column - 1])
    clean_moves(moves)
  end
end
