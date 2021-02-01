# frozen_string_literal: true

require_relative '../lib/move_validation'

describe 'MoveValidation' do
  class MoveValidationDummyClass
    include MoveValidation
  end

  subject(:move_validator) { MoveValidationDummyClass.new }

  let(:board) { double('board') }
  let(:player) { double('player') }
  let(:player2) { double('player') }
  let(:piece) { double('piece') }
  let(:piece2) { double('piece') }

  describe '#available?' do
    let(:location) { 'foo' }

    context 'when a player selects an empty space' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(nil)
        expect(move_validator.available?(player, location, board)).to be true
      end
    end

    context 'when a player selects a space with an enemy piece' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(move_validator.available?(player, location, board)).to be true
      end
    end

    context 'when a player selects a space with one of their pieces' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player)
        expect(move_validator.available?(player, location, board)).to be false
      end
    end
  end

  describe '#reachable?' do
    before do
      allow(piece).to receive(:location).and_return([0, 0])
      allow(piece).to receive(:player).and_return(player)
      allow(piece2).to receive(:player).and_return(player2)
      allow(move_validator).to receive(:row_reachable?).and_return(false)
      allow(move_validator).to receive(:column_reachable?).and_return(false)
      allow(move_validator).to receive(:diagonal_reachable?).and_return(false)
    end

    context 'when the piece is a knight' do
      let(:destination) { [4, 7] }

      it 'returns true' do
        allow(piece).to receive(:class).and_return(Knight)
        result = move_validator.reachable?(piece, destination, board)
        expect(result).to be true
      end
    end

    context 'when the destination is on the same row as the piece' do
      let(:destination) { [0, 7] }

      it 'calls #row_reachable?' do
        expect(move_validator).to receive(:row_reachable?).with(piece, destination, board)
        move_validator.reachable?(piece, destination, board)
      end

      context 'when the destination is row reachable' do
        it 'returns true' do
          allow(move_validator).to receive(:row_reachable?).and_return(true)
          result = move_validator.reachable?(piece, destination, board)
          expect(result).to be true
        end
      end

      context 'when the destination is not row reachable' do
        it 'returns false' do
          allow(move_validator).to receive(:row_reachable?).and_return(false)
          result = move_validator.reachable?(piece, destination, board)
          expect(result).to be false
        end
      end
    end

    context 'when the destination is on the same column as the piece' do
      let(:destination) { [7, 0] }

      it 'calls #column_reachable?' do
        expect(move_validator).to receive(:column_reachable?).with(piece, destination, board)
        move_validator.reachable?(piece, destination, board)
      end

      context 'when the destination is column reachable' do
        it 'returns true' do
          allow(move_validator).to receive(:column_reachable?).and_return(true)
          result = move_validator.reachable?(piece, destination, board)
          expect(result).to be true
        end
      end

      context 'when the destination is not column reachable' do
        it 'returns false' do
          allow(move_validator).to receive(:column_reachable?).and_return(false)
          result = move_validator.reachable?(piece, destination, board)
          expect(result).to be false
        end
      end
    end

    context 'when the destination is not on the same row or column' do
      let(:destination) { [7, 7] }

      it 'calls #diagonal_reachable?' do
        expect(move_validator).to receive(:diagonal_reachable?).with(piece, destination, board)
        move_validator.reachable?(piece, destination, board)
      end

      context 'when the destination is column reachable' do
        it 'returns true' do
          allow(move_validator).to receive(:diagonal_reachable?).and_return(true)
          result = move_validator.reachable?(piece, destination, board)
          expect(result).to be true
        end
      end

      context 'when the destination is not column reachable' do
        it 'returns false' do
          allow(move_validator).to receive(:diagonal_reachable?).and_return(false)
          result = move_validator.reachable?(piece, destination, board)
          expect(result).to be false
        end
      end
    end
  end
end