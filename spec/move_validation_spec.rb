# frozen_string_literal: true

require_relative '../lib/move_validation'

class MoveValidationDummyClass
  include MoveValidation

  def possible_moves(row, column)
  end
end

describe 'MoveValidation' do
  subject(:move_validator) { MoveValidationDummyClass.new }

  let(:board) { double('board') }
  let(:player) { double('player') }
  let(:player2) { double('player') }
  let(:piece) { double('piece') }
  let(:piece2) { double('piece') }

  describe '#valid_move?' do
    let(:location) { [1, 2] }

    before do
      allow(piece).to receive(:player)
    end

    context 'when the move is valid, and the location is both available and reachable' do
      it 'returns true' do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(move_validator).to receive(:available?).and_return(true)
        allow(move_validator).to receive(:reachable?).and_return(true)
        expect(move_validator.valid_move?(piece, location, board)).to be(true)
      end
    end

    context 'when the move is invalid, but the location is available and reachable' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(false)
        allow(move_validator).to receive(:available?).and_return(true)
        allow(move_validator).to receive(:reachable?).and_return(true)
        expect(move_validator.valid_move?(piece, location, board)).to be(false)
      end
    end

    context 'when the move is valid and the location is available, but not reachable' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(move_validator).to receive(:available?).and_return(true)
        allow(move_validator).to receive(:reachable?).and_return(false)
        expect(move_validator.valid_move?(piece, location, board)).to be(false)
      end
    end

    context 'when the move is valid, and the location is reachable, but not available' do
      it 'returns false' do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(move_validator).to receive(:available?).and_return(false)
        allow(move_validator).to receive(:reachable?).and_return(true)
        expect(move_validator.valid_move?(piece, location, board)).to be(false)
      end
    end
  end

  describe '#valid_moves' do
    let(:location) { [1, 2] }
    let(:test_move) { [3, 3] }
    let(:moves) { [test_move] }

    before do
      allow(piece).to receive(:player)
      allow(move_validator).to receive(:possible_moves).and_return(moves)
    end

    context 'when a possible move is available and reachable' do
      it 'includes that move in the array it returns' do
        allow(move_validator).to receive(:available?).and_return(true)
        allow(move_validator).to receive(:reachable?).and_return(true)
        expect(move_validator.valid_moves(piece, location, board)).to include(test_move)
      end
    end

    context 'when a possible move is available but not reachable' do
      it 'does not include that move in the array it returns' do
        allow(move_validator).to receive(:available?).and_return(true)
        allow(move_validator).to receive(:reachable?).and_return(false)
        expect(move_validator.valid_moves(piece, location, board)).not_to include(test_move)
      end
    end

    context 'when a possible move is reachable but not available' do
      it 'does not include that move in the array it returns' do
        allow(move_validator).to receive(:available?).and_return(false)
        allow(move_validator).to receive(:reachable?).and_return(true)
        expect(move_validator.valid_moves(piece, location, board)).not_to include(test_move)
      end
    end

    context 'when a possible move is not available or reachable' do
      it 'does not include that move in the array it returns' do
        allow(move_validator).to receive(:available?).and_return(false)
        allow(move_validator).to receive(:reachable?).and_return(false)
        expect(move_validator.valid_moves(piece, location, board)).not_to include(test_move)
      end
    end
  end

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

  describe '#row_reachable' do
    context 'when the piece is moving to a column of greater index' do
      let(:current_location) { [0, 0] }
      let(:to_location) { [0, 4] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.row_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.row_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.row_reachable?(piece, to_location, board)).to be true
        end
      end
    end

    context 'when the piece is moving to a column of lesser index' do
      let(:current_location) { [0, 4] }
      let(:to_location) { [0, 0] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.row_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.row_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.row_reachable?(piece, to_location, board)).to be true
        end
      end
    end
  end

  describe '#column_reachable?' do
    context 'when the piece is moving to a column of greater index' do
      let(:current_location) { [0, 0] }
      let(:to_location) { [4, 0] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.column_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.column_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.column_reachable?(piece, to_location, board)).to be true
        end
      end
    end

    context 'when the piece is moving to a column of lesser index' do
      let(:current_location) { [4, 0] }
      let(:to_location) { [0, 0] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.column_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.column_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.column_reachable?(piece, to_location, board)).to be true
        end
      end
    end
  end

  describe '#diagonal_reachable?' do
    context 'when the piece is moving to a column of greater index and row of greater index' do
      let(:current_location) { [0, 0] }
      let(:to_location) { [4, 4] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end
    end

    context 'when the piece is moving to a column of greater index and row of lesser index' do
      let(:current_location) { [0, 4] }
      let(:to_location) { [4, 0] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end
    end

    context 'when the piece is moving to a column of lesser index and row of greater index' do
      let(:current_location) { [4, 0] }
      let(:to_location) { [0, 4] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end
    end

    context 'when the piece is moving to a column of lesser index and row of lesser index' do
      let(:current_location) { [4, 4] }
      let(:to_location) { [0, 0] }

      before do
        allow(piece).to receive(:location).and_return(current_location)
      end

      context 'when a piece is in one of the tiles between the location and destination' do
        it 'returns false' do
          allow(board).to receive(:piece_at).and_return(false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be false
        end
      end

      context 'when there are no pieces between the location and the destination' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end

      context 'when a piece is at the destination but none are inbetween' do
        it 'returns true' do
          allow(board).to receive(:piece_at).and_return(false, false, false, true)
          expect(move_validator.diagonal_reachable?(piece, to_location, board)).to be true
        end
      end
    end
  end
end
