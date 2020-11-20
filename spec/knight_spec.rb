# frozen_string_literal: true

require './lib/knight.rb'

describe Knight do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:knight) { Knight.new(game, player, [0, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
  end

  describe '#symbol' do
    context 'when white' do
      it 'returns the white knight symbol' do
        expect(knight.symbol('white')).to eql('♘')
      end
    end

    context 'when black' do
      it 'returns the black knight symbol' do
        expect(knight.symbol('black')).to eql('♞')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      knight.move([0, 1])
      expect(knight.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(knight.legal_move?([2, 2])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(knight.legal_move?([0, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(knight.legal_move?([0, 1])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(knight.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([2, 2])
        expect(knight.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(knight.can_attack_king?).to be false
      end
    end
  end
end
