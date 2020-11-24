# frozen_string_literal: true

require './lib/king.rb'

describe King do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:king) { King.new(game, player, [0, 4]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:in_check_at?).and_return(false)
    allow(game).to receive(:move_checks_self?).and_return(false)
  end

  describe '#symbol' do
    context 'when white' do
      it 'returns the white king symbol' do
        expect(king.symbol('white')).to eql('♔')
      end
    end

    context 'when black' do
      it 'returns the black king symbol' do
        expect(king.symbol('black')).to eql('♚')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      king.move([0, 1])
      expect(king.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(king.legal_move?([1, 4])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(king.legal_move?([4, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(king.legal_move?([0, 4])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(king.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    it 'returns false' do
      allow(game).to receive(:enemy_king_location).and_return([7, 4])
      expect(king.can_attack_king?).to be false
    end
  end

  describe '#can_move?' do
    context 'when the king can move' do
      it 'returns true' do
        allow(king).to receive(:possible_moves).and_return([[1, 2]])
        expect(king.can_move?).to be true
      end
    end

    context 'when the king cannot move' do
      it 'returns false' do
        allow(king).to receive(:possible_moves).and_return([])
        expect(king.can_move?).to be false
      end
    end
  end
end
