# frozen_string_literal: true

# create/update board and reply if a space is occupied
class Board
  def initialize
    @symbol_ids = { 0 => "\u25A1", 1 => "\u2659" }
    @game_board = make_blank_board
  end

  def update(row, column, id)
    @game_board[row][column] = id
  end

  def to_s
    s = ''
    @game_board.each do |row|
      row.each do |id|
        s += @symbol_ids[id].encode + ' '
      end
      s += "\n"
    end
    s
  end

  private

  def make_blank_board
    board = []
    8.times { board.push([]) }
    board.each do |row|
      row.push(0) until row.size == 8
    end
    board
  end
end
