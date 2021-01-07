# frozen_string_literal: true

require_relative '../lib/pieces/queen'

describe Queen do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  let(:board) { double('board') }
  subject(:queen) { Queen.new(game, player, [0, 3]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:move_checks_self?).and_return(false)
    allow(game).to receive(:board).and_return(board)
    allow(board).to receive(:piece_at)
  end

  describe '#symbol' do
    context 'when white' do
      it 'returns the white queen symbol' do
        expect(queen.symbol('white')).to eql('♕')
      end
    end

    context 'when black' do
      it 'returns the black queen symbol' do
        expect(queen.symbol('black')).to eql('♛')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      queen.move([0, 1])
      expect(queen.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when a legal horizontal move is given' do
      it 'returns true' do
        expect(queen.legal_move?([0, 7])).to be true
      end
    end

    context 'when a legal vertical move is given' do
      it 'returns true' do
        expect(queen.legal_move?([7, 3])).to be true
      end
    end

    context 'when legal diagonal move is given' do
      it 'returns true' do
        expect(queen.legal_move?([4, 7])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(queen.legal_move?([4, 8])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(queen.legal_move?([0, 3])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(queen.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([0, 6])
        expect(queen.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(queen.can_attack_king?).to be false
      end
    end
  end
end
