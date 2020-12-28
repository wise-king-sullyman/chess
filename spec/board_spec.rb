# frozen_string_literal: true

require './lib/board'
require './lib/pieces/piece'

describe Board do
  let(:players) { [] }
  subject(:board) { Board.new(players) }

  describe '#update' do
    it 'adds a piece to the board when requested' do
      board.update(1, 0, 1)
      expect(board.instance_variable_get('@current_board')[1][0]).to eql(1)
    end
  end

  describe '#piece_at' do
    let(:piece) { instance_double('piece') }
    context 'when a piece is present' do
      it 'returns the piece' do
        board.update(0, 4, piece)
        expect(board.piece_at([0, 4])).to eql(piece)
      end
    end
  end

  describe '#refresh' do
    context 'when no changes have been made' do
      it 'returns the same board' do
        board.refresh
        expect(board.instance_variable_get('@current_board')[1][0]).to be nil
      end
    end

    context 'when changes have been made' do
      let(:player) { double('player') }
      let(:players) { [player] }
      let(:game) { instance_double('game') }
      let(:piece) { Pawn.new(game, player, [1, 0]) }
      it 'returns the new board' do
        board.instance_variable_set('@players', players)
        allow(player).to receive(:pieces).and_return([piece])
        board.refresh
        expect(board.instance_variable_get('@current_board')[1][0]).to be piece
      end
    end
  end

  describe '#make_blank_board' do
    let(:blank_board) { board.make_blank_board }
    it 'sets the current board to an array of size 8' do
      expect(blank_board.size).to eq(8)
    end

    it 'has sub arrays of size 8 each' do
      all_rows_size_eight = blank_board.all? { |row| row.size == 8 }
      expect(all_rows_size_eight).to be(true)
    end

    it 'has nil in all tile locations' do
      nil_in_all_locations = blank_board.all? { |row| row.all?(&:nil?) }
      expect(nil_in_all_locations).to be(true)
    end
  end

  describe '#empty_current_board' do
    let(:board_state) { board.instance_variable_get('@current_board') }
    before do
      board.instance_variable_set('@current_board', [1, 2, 3, 4])
    end

    it 'replaces the current board with an array of size 8' do
      board.empty_current_board
      expect(board_state.size).to eq(8)
    end
  end

  describe '#to_s' do
    it 'returns #draw_rows after calling it with and appending a footer' do
      allow(board).to receive(:draw_rows).and_return("  a b c d e f g h \n")
      expect(board.to_s).to eq("  a b c d e f g h \n  a b c d e f g h \n")
    end
  end
end
