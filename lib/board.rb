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

  private

  attr_accessor :current_board

  def empty_current_board
    self.current_board = make_blank_board
  end

  def make_blank_board
    board = []
    8.times { board.push([]) }
    board.each do |row|
      row.push(nil) until row.size == 8
    end
    board
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
      new_tile = tile ? make_played_tile(tile, background) : make_empty_tile(background)
      board_string += new_tile
    end
    board_string
  end

  def tile_background_white_or_black(row_index, tile_index)
    row_index.even? == tile_index.even? ? 'white' : 'black'
  end

  def make_empty_tile(background)
    colorize_tile(background_color: background)
  end

  def make_played_tile(tile, background)
    colorize_tile(
      symbol: tile.symbol('black'),
      symbol_color: tile.player.color,
      background_color: background
    )
  end
end
