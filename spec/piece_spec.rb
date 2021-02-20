# frozen_string_literal: true

require_relative '../lib/pieces/piece'

class DummyClass
  include Piece

  def possible_moves(row, column)
  end

  # this is to give an easy to find method name for testing #callers_include?
  def foo(function_name_as_string)
    callers_include?(function_name_as_string)
  end
end

describe Piece do
  let(:game) { double('game') }
  let(:player) { double('player') }
  let(:location) { [4, 4] }

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
    let(:moves) { [[1, 1], [4, 4]] }

    before do
      allow(game).to receive(:board)
      allow(game).to receive(:move_checks_self?)
    end

    it 'calls #remove_at_current_location_move once with moves and location' do
      expect(piece).to receive(:remove_at_current_location_move).once.with(moves, location)
      piece.clean_moves(moves)
    end

    it 'calls #remove_out_of_bounds_moves once' do
      expect(piece).to receive(:remove_out_of_bounds_moves).once.with(0, 7, moves)
      piece.clean_moves(moves)
    end

    context 'when #clean_moves is not being called as a descendent of #can_attack_king' do
      it 'calls #remove_self_checks' do
        allow(piece).to receive(:callers_include?).and_return(false)
        expect(piece).to receive(:remove_self_checks).once.with(moves)
        piece.clean_moves(moves)
      end
    end

    context 'when #clean_moves is being called as a descendent of #can_attack_king' do
      it 'calls #remove_self_checks' do
        allow(piece).to receive(:callers_include?).and_return(true)
        expect(piece).not_to receive(:remove_self_checks)
        piece.clean_moves(moves)
      end
    end

    it 'returns moves' do
      expect(piece.clean_moves(moves)).to eq(moves)
    end
  end

  describe '#remove_at_current_location_move' do
    before do
      allow(game).to receive(:board)
      allow(game).to receive(:move_checks_self?)
    end

    context 'when the move array contains does not include the current location' do
      let(:moves) { [[1, 1], [3, 3]] }
      it 'returns the moves array unchanged' do
        output_moves = piece.remove_at_current_location_move(moves, [4, 4])
        expect(output_moves).to eq([[1, 1], [3, 3]])
      end
    end

    context 'when the current location is listed in the moves aray' do
      let(:moves) { [[1, 1], [4, 4]] }
      it 'returns the moves array after removing the current location' do
        output_moves = piece.remove_at_current_location_move(moves, [4, 4])
        expect(output_moves).to eq([[1, 1]])
      end
    end
  end

  describe '#remove_out_of_bounds_moves' do
    before do
      allow(game).to receive(:board)
      allow(game).to receive(:move_checks_self?).and_return(false)
    end

    context 'when the move array contains no out of bounds moves' do
      let(:moves) { [[1, 1], [3, 3]] }
      it 'returns the moves array unchanged' do
        output_moves = piece.remove_out_of_bounds_moves(0, 7, moves)
        expect(output_moves).to eq([[1, 1], [3, 3]])
      end
    end

    context 'when the moves array includes rows or columns out of range' do
      let(:moves) { [[1, 1], [8, 0], [3, 3], [-1, 2], [3, 9], [4, -3], [8, 8]] }
      it 'returns the moves array with out of bounds moves removed' do
        output_moves = piece.remove_out_of_bounds_moves(0, 7, moves)
        expect(output_moves).to eq([[1, 1], [3, 3]])
      end
    end
  end

  describe '#remove_self_checks' do
    before do
      allow(game).to receive(:board)
      allow(game).to receive(:move_checks_self?).and_return(false)
    end

    context 'when the move array contains no self checking moves' do
      let(:moves) { [[1, 1], [3, 3]] }
      it 'returns the moves array unchanged' do
        output_moves = piece.remove_self_checks(moves)
        expect(output_moves).to eq([[1, 1], [3, 3]])
      end
    end

    context 'when the moves array includes moves that would check the moving player' do
      let(:moves) { [[1, 1], [7, 0], [3, 3], [1, 2], [3, 6], [4, 3], [2, 2]] }
      it 'returns the moves array with self checking moves removed' do
        allow(game).to receive(:move_checks_self?).and_return(false, true, false, true)
        output_moves = piece.remove_self_checks(moves)
        expect(output_moves).to eq([[1, 1], [3, 3]])
      end
    end
  end

  describe '#callers_include?' do
    context 'when the supplied function name is included in the callers of the method' do
      it 'returns true' do
        expect(piece.foo('foo')).to be(true)
      end
    end

    context 'when the supplied function name is not included in the callers of the method' do
      it 'returns false' do
        expect(piece.callers_include?('foo')).to be(false)
      end
    end
  end

  describe '#apply_move_modifiers' do
    let(:modifiers) { [[0, 0], [1, 2], [3, -1]] }
    let(:expected_moves) { [[1, 4], [2, 6], [4, 3]] }
    it 'returns an array of moves with the supplied row and column summed with the given modifiers' do
      expect(piece.apply_move_modifiers(modifiers, 1, 4)).to eq(expected_moves)
    end
  end
end
