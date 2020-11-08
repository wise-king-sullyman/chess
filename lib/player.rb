# frozen_string_literal: true

require_relative 'piece.rb'

# keep state of and execute actions for the player
class Player
  attr_reader :color, :pieces

  def initialize(name, color, game, board)
    @name = name
    @color = color
    @game = game
    @board = board
    @pieces = assign_pieces
    @lost_pieces = []
    @check = false
    @check_mate = false
  end

  def move
    piece = piece_choice
    location = location_choice
    until piece_is_mine?(piece) && valid?(piece, location)
      puts 'Invalid piece and/or location selected, please choose again'
      piece = piece_choice
      location = location_choice
    end
    @game.move_piece(piece, location)
  end

  def remove_piece(piece)
    @lost_pieces.push(piece)
    @pieces.delete(piece)
  end

  private

  def assign_pieces
    pieces = []
    assign_rooks(pieces)
    assign_knights(pieces)
    assign_bishops(pieces)
    assign_queen(pieces)
    assign_king(pieces)
    assign_pawns(pieces)
    pieces
  end

  def assign_rooks(pieces)
    locations = []
    @color == 'white' ? locations.push([7, 0], [7, 7]) : locations.push([0, 0], [0, 7])
    locations.each do |location|
      pieces.push(Rook.new(@game, self, location))
    end
  end

  def assign_knights(pieces)
    locations = []
    @color == 'white' ? locations.push([7, 1], [7, 6]) : locations.push([0, 1], [0, 6])
    locations.each do |location|
      pieces.push(Knight.new(@game, self, location))
    end
  end

  def assign_bishops(pieces)
    locations = []
    @color == 'white' ? locations.push([7, 2], [7, 5]) : locations.push([0, 2], [0, 5])
    locations.each do |location|
      pieces.push(Bishop.new(@game, self, location))
    end
  end

  def assign_queen(pieces)
    location = @color == 'white' ? [7, 3] : [0, 3]
    pieces.push(Queen.new(@game, self, location))
  end

  def assign_king(pieces)
    location = @color == 'white' ? [7, 4] : [0, 4]
    pieces.push(King.new(@game, self, location))
  end

  def assign_pawns(pieces)
    locations = []
    if @color == 'white'
      8.times { |column| locations.push([6, column]) }
    else
      8.times { |column| locations.push([1, column]) }
    end
    locations.each do |location|
      pieces.push(Pawn.new(@game, self, location))
    end
  end

  def piece_choice
    puts "#{@name} enter piece selection location:"
    piece_at_location(gets.chomp)
  end

  def location_choice
    puts "#{@name} enter move location:"
    gets.chomp
  end

  def piece_at_location(location)
    @board.piece_at(location)
  end

  def piece_is_mine?(piece)
    piece.player == self
  end

  def valid?(piece, location)
    piece.legal_move?(location) \
    && @game.available?(self, location) \
    && @game.reachable?(piece, location)
  end
end
