# frozen_string_literal: true

require_relative '../lib/pieces/piece'

describe Piece do
  let(:game) { double('game') }
  let(:player) { double('player') }
  let(:location) { [4, 4] }
  class DummyClass
    include Piece

    def possible_moves(row, column)
    end
  end
  subject(:piece) { DummyClass.new(game, player, location) }

  describe '#move' do
    context 'when a test move is being performed' do
      before do
        piece.move([3, 3], true)
      end

      it 'sets self.location to the entered location' do
        expect(piece.location).to eq([3, 3])
      end

      it 'does not change self.moved' do
        expect(piece.moved).to be(false)
      end
    end

    context 'when a non-test move is being performed' do
      before do
        piece.move([3, 3])
      end

      it 'sets self.location to the entered location' do
        expect(piece.location).to eq([3, 3])
      end

      it 'changes self.moved to true' do
        expect(piece.moved).to be(true)
      end
    end
  end

  describe '#legal_move?' do
    context 'when the move is legal' do
      it 'returns true' do
        allow(piece).to receive(:possible_moves).and_return([[0, 0], [3, 3]])
        expect(piece.legal_move?([3, 3])).to be(true)
      end
    end

    context 'when the move is not legal' do
      it 'returns false' do
        allow(piece).to receive(:possible_moves).and_return([[0, 0], [1, 1]])
        expect(piece.legal_move?([3, 3])).to be(false)
      end
    end
  end
end
