# frozen_string_literal: true

# serves as the template for all unique pieces
class Piece
  def initialize(player, location = nil)
    @player = player
    @location = location
    @alive = true
    @moved = false
  end

  def move(location)
  end

  def attack(piece)
  end

  def can_attack_king?
  end
end
