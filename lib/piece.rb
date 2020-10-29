# frozen_string_literal: true

# serves as the template for all unique pieces
class Piece
  def initialize(location)
    @location = location
    @moved = false
  end

  def move(location)
    @location = location
    @moved = true
  end
end

class Pawn < Piece
  def symbol(color)
    color == 'white' ? "\u2659".encode : "\u265F".encode
  end

  def legal_move?(location)
  end

  def can_attack_king?
  end
end
