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
    s = "  0 1 2 3 4 5 6 7 \n"
    @game_board.each_with_index do |row, index|
      s += index.to_s + ' '
      row.each do |tile|
        s += tile ? tile.symbol(tile.player.color) + ' ' : @empty_tile
      end
      s += "\n"
    end
    s
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
end
