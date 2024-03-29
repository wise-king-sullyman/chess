# frozen_string_literal: true

require_relative 'tile'

# create/update board and reply if a space is occupied
class Board
  include Tile

  attr_reader :players

  def initialize(players)
    @players = players
    @current_board = make_blank_board
  end

  def update(row, column, piece)
    current_board[row][column] = piece
  end

  def to_s
    board_string = "  a b c d e f g h \n"
    board_string = draw_rows(current_board, board_string)
    board_string += "  a b c d e f g h \n"
    board_string
  end

  def draw_rows(board_array, board_string)
    board_array.each_with_index do |row, index|
      board_string += (8 - index).to_s + ' '
      board_string = draw_tiles(row, board_string, index)
      board_string += ' ' + (8 - index).to_s
      board_string += "\n"
    end
    board_string
  end

  def draw_tiles(row, board_string, row_index)
    row.each_with_index do |tile, tile_index|
      background = tile_background_white_or_black(row_index, tile_index)
      board_string += make_colorized_tile(tile, background)
    end
    board_string
  end

  def tile_background_white_or_black(row_index, tile_index)
    row_index.even? == tile_index.even? ? 'white' : 'black'
  end

  def make_colorized_tile(tile, background)
    colorize_tile(
      symbol: tile&.symbol('black') || ' ',
      symbol_color: tile&.player&.color,
      background_color: background
    )
  end

  def piece_at(location)
    current_board[location.first][location.last]
  end

  def refresh
    empty_current_board
    players.each do |player|
      player.pieces.each do |piece|
        row = piece.location.first
        column = piece.location.last
        update(row, column, piece)
      end
    end
  end

  def empty_current_board
    self.current_board = make_blank_board
  end

  def make_blank_board
    Array.new(8) { Array.new(8) }
  end

  private

  attr_accessor :current_board
end
