# frozen_string_literal: true

# keep state of and execute actions for the player
class Player
  attr_reader :color

  def initialize(name, color, game, board)
    @name = name
    @color = color
    @game = game
    @board = board
    @pieces = get_pieces
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

  private

  def get_pieces
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
