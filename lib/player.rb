# frozen_string_literal: true

# keep state of and execute actions for the player
class Player
  attr_reader :color

  def initialize(name, color, game)
    @name = name
    @color = color
    @game = game
    @pieces = get_pieces
    @lost_pieces = []
    @check = false
    @check_mate = false
  end

  def move(piece, location)
  end

  private

  def get_pieces
  end
end
