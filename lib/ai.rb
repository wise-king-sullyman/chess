# frozen_string_literal: true

require_relative 'player'
require_relative 'move_validation'

# keep state of and execute actions for the ai
class AI < Player
  include MoveValidation

  def move
    reset_en_passant_vulnerabilities
    piece = piece_choice
    location = location_choice
    until piece_is_mine?(piece) && valid_move?(piece, location, game.board)
      piece = piece_choice
      location = location_choice
    end
    game.move_piece(piece, location)
    promote(piece) if piece.eligible_for_promotion?
  end

  def random_tile
    location = random_column_selection + random_row_selection
    update_last_move(location)
    translate_input(location)
  end

  def promote(piece, number = rand(4), my_pieces = pieces)
    add_promotion_piece(piece, number)
    my_pieces.delete(piece)
  end

  def piece_choice
    input = random_tile
    piece_at_location([input.first, input.last])
  end

  def location_choice
    input = random_tile
    [input.first, input.last]
  end

  def random_row_selection
    rand(1..8).to_s
  end

  def random_column_selection(range = ('a'..'h'))
    range.to_a.sample
  end
end
