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

  describe '#can_attack_king?' do
    context 'when the piece can attack the enemy king' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location)
        allow(piece).to receive(:can_attack_location?).and_return(true)
        expect(piece.can_attack_king?).to be(true)
      end
    end

    context 'when the piece can not attack the enemy king' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location)
        allow(piece).to receive(:can_attack_location?).and_return(false)
        expect(piece.can_attack_king?).to be(false)
      end
    end
  end

  describe '#can_attack_location?' do
    before do
      allow(game).to receive(:board)
    end

    context 'when the given location is legal and reachable' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(piece).to receive(:reachable?).and_return(true)
        expect(piece.can_attack_location?([3, 3])).to be(true)
      end
    end

    context 'when the given location is legal but not reachable' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(piece).to receive(:reachable?).and_return(false)
        expect(piece.can_attack_location?([3, 3])).to be(false)
      end
    end

    context 'when the given location is reachable but not legal' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(false)
        allow(piece).to receive(:reachable?).and_return(true)
        expect(piece.can_attack_location?([3, 3])).to be(false)
      end
    end

    context 'when the given location is not legal or reachable' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(false)
        allow(piece).to receive(:reachable?).and_return(false)
        expect(piece.can_attack_location?([3, 3])).to be(false)
      end
    end
  end

  describe '#can_move?' do
    before do
      allow(game).to receive(:board)
    end

    context 'when valid_moves returns a non-empty array' do
      it 'returns true' do
        allow(piece).to receive(:valid_moves).and_return([[1, 1], [3, 3]])
        expect(piece.can_move?).to be(true)
      end
    end

    context 'when valid_moves returns an empty array' do
      it 'returns false' do
        allow(piece).to receive(:valid_moves).and_return([])
        expect(piece.can_move?).to be(false)
      end
    end
  end

  describe '#eligible_for_promotion?' do
    it 'returns false' do
      expect(piece.eligible_for_promotion?).to be(false)
    end
  end

  describe '#clean_moves' do
    before do
      allow(game).to receive(:board)
      allow(game).to receive(:move_checks_self?)
    end

    context 'when the move array contains no out of bounds, at current location, or (if applicable) self checking moves' do
      let(:moves) { [[1, 1], [3, 3]] }
      it 'returns the moves array unchanged' do
        expect(piece.clean_moves(moves)).to eq([[1, 1], [3, 3]])
      end
    end

    context 'when the current location is listed in the moves aray' do
      let(:moves) { [[1, 1], [4, 4]] }
      it 'returns the moves array after removing the current location' do
        expect(piece.clean_moves(moves)).to eq([[1, 1]])
      end
    end

    context 'when the moves array includes rows or columns out of range' do
      let(:moves) { [[1, 1], [8, 0], [3, 3], [-1, 2], [3, 9], [4, -3], [8, 8]] }
      it 'returns the moves array with out of bounds moves removed' do
        expect(piece.clean_moves(moves)).to eq([[1, 1], [3, 3]])
      end
    end

    context 'when the moves array includes moves that would check the moving player' do
      let(:moves) { [[1, 1], [7, 0], [3, 3], [1, 2], [3, 6], [4, 3], [2, 2]] }
      it 'returns the moves array with self checking moves removed' do
        allow(game).to receive(:move_checks_self?).and_return(false, true, false, true)
        expect(piece.clean_moves(moves)).to eq([[1, 1], [3, 3]])
      end
    end
  end
end
