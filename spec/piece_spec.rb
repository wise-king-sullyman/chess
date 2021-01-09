# frozen_string_literal: true

require_relative '../lib/pieces/piece'

describe Piece do
  let(:game) { double('game') }
  let(:player) { double('player') }
  let(:location) { [4, 4] }
  let(:dummy_class) do
    class DummyClass
      include Piece
    end
  end
  subject(:piece) { dummy_class.new(game, player, location) }

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
end
