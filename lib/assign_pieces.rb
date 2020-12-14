# frozen_string_literal: true

require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'pawn'

# assign pieces to a player
module AssignPieces
  def assign_pieces(player, game)
    pieces = []
    assign_rooks(player, game, pieces)
    assign_knights(player, game, pieces)
    assign_bishops(player, game, pieces)
    assign_queen(player, game, pieces)
    assign_king(player, game, pieces)
    assign_pawns(player, game, pieces)
    pieces
  end

  def assign_rooks(player, game, pieces)
    locations = []
    player.color == 'white' ? locations.push([7, 0], [7, 7]) : locations.push([0, 0], [0, 7])
    locations.each do |location|
      pieces.push(Rook.new(game, player, location))
    end
  end

  def assign_knights(player, game, pieces)
    locations = []
    player.color == 'white' ? locations.push([7, 1], [7, 6]) : locations.push([0, 1], [0, 6])
    locations.each do |location|
      pieces.push(Knight.new(game, player, location))
    end
  end

  def assign_bishops(player, game, pieces)
    locations = []
    player.color == 'white' ? locations.push([7, 2], [7, 5]) : locations.push([0, 2], [0, 5])
    locations.each do |location|
      pieces.push(Bishop.new(game, player, location))
    end
  end

  def assign_queen(player, game, pieces)
    location = player.color == 'white' ? [7, 3] : [0, 3]
    pieces.push(Queen.new(game, player, location))
  end

  def assign_king(player, game, pieces)
    location = player.color == 'white' ? [7, 4] : [0, 4]
    pieces.push(King.new(game, player, location))
  end

  def assign_pawns(player, game, pieces)
    locations = []
    if player.color == 'white'
      8.times { |column| locations.push([6, column]) }
    else
      8.times { |column| locations.push([1, column]) }
    end
    locations.each do |location|
      pieces.push(Pawn.new(game, player, location))
    end
  end
end
