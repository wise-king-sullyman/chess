# frozen_string_literal: true

require_relative 'piece.rb'

# keep state of and execute actions for the player
class Player
  attr_accessor :name, :color, :pieces

  def initialize(name, color, game)
    @name = name
    @color = color
    @game = game
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

  def king_location
    @pieces.each do |piece|
      return piece.location if piece.class == King
    end
  end

  def mated?
    king = @pieces.select { |piece| piece.class == King }.first
    king.can_move? ? false : true
  end

  def remove_piece(piece)
    @lost_pieces.push(piece)
    @pieces.delete(piece)
  end

  def in_stalemate?
    @pieces.each do |piece|
      return false if piece.can_move?
    end
    true
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
    input = player_input
    piece_at_location([input.first, input.last])
  end

  def location_choice
    puts "#{@name} enter move location:"
    input = player_input
    [input.first, input.last]
  end

  def translate_input(input)
    column_hash = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    column = column_hash.fetch(input[0])
    row = 8 - input[1].to_i
    [row, column]
  end

  def player_input
    unvalidated_input = gets.chomp
    validated_input = validate_input(unvalidated_input)
    translate_input(validated_input)
  end

  def validate_input(input)
    until input.match?(/^[a-h][0-9]$/)
      puts 'invalid location input; please try again'
      input = gets.chomp
    end
    input
  end

  def piece_at_location(location)
    @game.piece_at(location)
  end

  def piece_is_mine?(piece)
    return false unless piece

    piece.player == self
  end

  def valid?(piece, location)
    piece.legal_move?(location) \
    && @game.available?(self, location) \
    && @game.reachable?(piece, location)
  end
end
