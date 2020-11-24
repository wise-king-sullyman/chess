# frozen_string_literal: true

require './lib/pawn.rb'

describe Pawn do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:pawn) { Pawn.new(game, player, [1, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:piece_at).and_return(nil)
    allow(game).to receive(:move_checks_self?).and_return(false)
  end

  before do
    allow(game).to receive(:enemy_at?).and_return(true)
  end

  describe '#symbol' do
    context 'when white' do
      it 'returns the white pawn symbol' do
        expect(pawn.symbol('white')).to eql('♙')
      end
    end

    context 'when black' do
      it 'returns the black pawn symbol' do
        expect(pawn.symbol('black')).to eql('♟')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      pawn.move([0, 1])
      expect(pawn.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal 1 square positive first move is given' do
      it 'returns true' do
        expect(pawn.legal_move?([2, 1])).to be true
      end
    end

    context 'when legal 2 square positive first move is given' do
      it 'returns true' do
        expect(pawn.legal_move?([3, 1])).to be true
      end
    end

    context 'when legal 1 square negative first move is given' do
      subject(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns true' do
        expect(pawn.legal_move?([5, 1])).to be true
      end
    end

    context 'when legal attack move from top to bottom is given' do
      it 'returns true' do
        expect(pawn.legal_move?([2, 2])).to be true
      end
    end

    context 'when legal attack move from bottom to top is given' do
      let(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns true' do
        expect(pawn.legal_move?([5, 2])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(pawn.legal_move?([0, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(pawn.legal_move?([0, 1])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(pawn.legal_move?([-1, 16])).to be false
      end
    end

    context 'when enemy is in front of pawn' do
      it 'returns false' do
        allow(game).to receive(:piece_at).and_return(true)
        expect(pawn.legal_move?([2, 1])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([2, 0])
        expect(pawn.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(pawn.can_attack_king?).to be false
      end
    end
  end

  describe '#eligible_for_promotion?' do
    context 'when piece starting in row 1 reaches row 7' do
      it 'returns true' do
        pawn.move([7, 1])
        expect(pawn.eligible_for_promotion?).to be true
      end
    end

    context 'when piece starting in row 6 reaches row 0' do
      subject(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns true' do
        pawn.move([0, 1])
        expect(pawn.eligible_for_promotion?).to be true
      end
    end

    context 'when piece starting in row 1 has not reached row 7' do
      it 'returns false' do
        pawn.move([6, 1])
        expect(pawn.eligible_for_promotion?).to be false
      end
    end

    context 'when piece starting in row 6 has not reached row 0' do
      subject(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns false' do
        pawn.move([1, 1])
        expect(pawn.eligible_for_promotion?).to be false
      end
    end
  end
end
