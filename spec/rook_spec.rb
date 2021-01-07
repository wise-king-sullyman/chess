# frozen_string_literal: true

require_relative '../lib/pieces/rook'

describe Rook do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  let(:board) { double('board') }
  subject(:rook) { Rook.new(game, player, [0, 0]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:move_checks_self?).and_return(false)
    allow(game).to receive(:board).and_return(board)
    allow(board).to receive(:piece_at)
  end

  describe '#symbol' do
    context 'when white' do
      it 'returns the white rook symbol' do
        expect(rook.symbol('white')).to eql('♖')
      end
    end

    context 'when black' do
      it 'returns the black rook symbol' do
        expect(rook.symbol('black')).to eql('♜')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      rook.move([0, 1])
      expect(rook.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(rook.legal_move?([0, 7])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(rook.legal_move?([1, 2])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(rook.legal_move?([0, 0])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(rook.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([7, 0])
        expect(rook.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(rook.can_attack_king?).to be false
      end
    end
  end
end
