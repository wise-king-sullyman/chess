# frozen_string_literal: true

require_relative 'assign_pieces'
require_relative 'move_validation'
require 'pry'

# keep state of and execute actions for the player
class Player
  include AssignPieces
  include MoveValidation

  attr_reader :name, :color, :pieces, :lost_pieces, :game, :last_move

  def initialize(name, color, game)
    @name = name
    @color = color
    @game = game
    @pieces = assign_pieces(self, game)
    @lost_pieces = []
    @last_move = []
  end

  def move
    reset_en_passant_vulnerabilities
    piece = piece_choice
    location = location_choice
    until piece_is_mine?(piece) && valid_move?(piece, location, game.board)
      puts 'Invalid piece and/or location selected, please choose again'
      piece = piece_choice
      location = location_choice
    end
    game.move_piece(piece, location)
    promote(piece) if piece.eligible_for_promotion?
  end

  def reset_en_passant_vulnerabilities
    pieces.each do |piece|
      piece.falsify_en_passant_vulnerability if piece.class == Pawn
    end
  end

  def king_location
    pieces.each do |piece|
      return piece.location if piece.class == King
    end
  end

  def remove_piece(piece)
    lost_pieces.push(piece)
    pieces.delete(piece)
  end

  def revive_piece(piece)
    pieces.push(piece)
    lost_pieces.delete(piece)
  end

  def mated?
    pieces.each do |piece|
      return false if piece.can_move?
    end
    true
  end

  def translate_input(input)
    column_hash = {
      'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6,
      'h' => 7
    }
    column = column_hash.fetch(input[0])
    row = 8 - input[1].to_i
    [row, column]
  end

  private

  def piece_choice
    puts "#{name} enter piece selection location:"
    input = player_input
    piece_at_location([input.first, input.last])
  end

  def location_choice
    puts "#{name} enter move location:"
    input = player_input
    [input.first, input.last]
  end

  def player_input
    unvalidated_input = gets.chomp
    binding.pry if unvalidated_input == 'admin'
    validated_input = validate_input(unvalidated_input)
    update_last_move(validated_input)
    translate_input(validated_input)
  end

  def update_last_move(move)
    last_move.clear if last_move.size == 2
    last_move.push(move)
  end

  def validate_input(input)
    until input.match?(/^[a-h][1-8]$/)
      puts 'invalid location input; please try again'
      input = gets.chomp
    end
    input
  end

  def piece_at_location(location)
    game.piece_at(location)
  end

  def piece_is_mine?(piece)
    return false unless piece

    piece.player == self
  end

  def promote(piece)
    puts 'Pawn promoted! Select 0 to become a queen, 1 to become a rook'\
    '2 to become a bishop, or 3 to become a knight'
    add_promotion_piece(piece, validate_promotion_choice(gets.chomp))
    pieces.delete(piece)
  end

  def validate_promotion_choice(promotion_choice)
    until promotion_choice.match?(/^[0-3]$/)
      puts 'invalid selection; please try again'
      promotion_choice = gets.chomp
    end
    promotion_choice.to_i
  end

  def add_promotion_piece(old_piece, new_piece_selection)
    case new_piece_selection
    when 0
      pieces.push(Queen.new(game, self, old_piece.location))
    when 1
      pieces.push(Rook.new(game, self, old_piece.location))
    when 2
      pieces.push(Bishop.new(game, self, old_piece.location))
    when 3
      pieces.push(Knight.new(game, self, old_piece.location))
    end
  end
end
