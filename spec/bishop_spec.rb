# frozen_string_literal: true

require_relative '../lib/pieces/bishop'

describe Bishop do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  let(:board) { double('board') }
  subject(:bishop) { Bishop.new(game, player, [0, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:move_checks_self?).and_return(false)
    allow(game).to receive(:board).and_return(board)
    allow(board).to receive(:piece_at)
  end

  describe '#symbol' do
    context 'when white' do
      it 'returns the white bishop symbol' do
        expect(bishop.symbol('white')).to eql('♗')
      end
    end

    context 'when black' do
      it 'returns the black bishop symbol' do
        expect(bishop.symbol('black')).to eql('♝')
      end
    end
  end

  describe '#possible_moves' do
    let(:possible_moves) do
      [
        [0, 1], [0, 1], [0, 1], [0, 1],
        [1, 2], [1, 0], [-1, 2], [-1, 0],
        [2, 3], [2, -1], [-2, 3], [-2, -1],
        [3, 4], [3, -2], [-3, 4], [-3, -2],
        [4, 5], [4, -3], [-4, 5], [-4, -3],
        [5, 6], [5, -4], [-5, 6], [-5, -4],
        [6, 7], [6, -5], [-6, 7], [-6, -5],
        [7, 8], [7, -6], [-7, 8], [-7, -6]
      ]
    end

    it 'calls #clean_moves with all theoretically possible moves the piece can make' do
      allow(bishop).to receive(:clean_moves) { |moves| moves }
      expect(bishop).to receive(:clean_moves).with(possible_moves)
      bishop.possible_moves(bishop.location.first, bishop.location.last)
    end

    it 'returns the cleaned moves' do
      allow(bishop).to receive(:clean_moves).with(possible_moves).and_return('foo')
      expect(bishop.possible_moves(bishop.location.first, bishop.location.last)).to eq('foo')
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      bishop.move([0, 1])
      expect(bishop.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(bishop.legal_move?([6, 7])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(bishop.legal_move?([0, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(bishop.legal_move?([0, 1])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(bishop.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([6, 7])
        expect(bishop.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(bishop.can_attack_king?).to be false
      end
    end
  end
end
