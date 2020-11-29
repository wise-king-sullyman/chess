# frozen_string_literal: true

require_relative 'player.rb'
require_relative 'move_validation.rb'

# keep state of and execute actions for the ai
class AI < Player
  include MoveValidation

  def move
    piece = piece_choice
    location = location_choice
    until piece_is_mine?(piece) && valid_move?(piece, location, @game.board)
      piece = piece_choice
      location = location_choice
    end
    @game.move_piece(piece, location)
    promote(piece) if piece.eligible_for_promotion?
  end

  private

  def piece_choice
    input = random_tile
    piece_at_location([input.first, input.last])
  end

  def location_choice
    input = random_tile
    [input.first, input.last]
  end

  def random_tile
    [rand(8), rand(8)]
  end
end
