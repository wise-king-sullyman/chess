# frozen_string_literal: true

# create/update board and reply if a space is occupied
class Board
  def initialize(players)
    @players = players
    @empty_tile = "\u25A1".encode + ' '
    @game_board = make_blank_board
  end

  def update(row, column, piece)
    @game_board[row][column] = piece
  end

  def to_s
    board_string = "  a b c d e f g h \n"
    board_string = draw_rows(@game_board, board_string)
    board_string += "  a b c d e f g h \n"
    board_string
  end

  def piece_at(location)
    @game_board[location.first][location.last]
  end

  def refresh
    @game_board = make_blank_board
    @players.each do |player|
      player.pieces.each do |piece|
        row = piece.location.first
        column = piece.location.last
        @game_board[row][column] = piece
      end
    end
    @game_board
  end

  private

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
      board_string = draw_tiles(row, board_string)
      board_string += ' ' + (8 - index).to_s
      board_string += "\n"
    end
    board_string
  end

  def draw_tiles(row, board_string)
    row.each do |tile|
      board_string += tile ? tile.symbol(tile.player.color) + ' ' : @empty_tile
    end
    board_string
  end
end
