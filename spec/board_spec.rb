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
end
