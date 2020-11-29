# frozen_string_literal: true

require './lib/move_validation.rb'

describe MoveValidation do
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
        expect(available?(player, location)).to be true
      end
    end

    context 'when a player selects a space with an enemy piece' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(available?(player, location)).to be true
      end
    end

    context 'when a player selects a space with one of their pieces' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player)
        expect(available?(player, location)).to be false
      end
    end
  end

  describe '#reachable?' do
    let(:game_board) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end
    let(:player1) { double('player') }
    let(:player2) { double('player') }

    before do
      allow(piece).to receive(:location).and_return([0, 0])
      allow(piece).to receive(:player).and_return(player1)
      allow(piece2).to receive(:player).and_return(player2)
    end

    context 'when the piece can reach a horizontal location unobstructed' do
      it 'returns true' do
        game_board[0][0] = piece
        location = [0, 6]
        expect(reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can reach a vertical location unobstructed' do
      it 'returns true' do
        game_board[0][0] = piece
        location = [6, 0]
        expect(reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can reach a higher vertical location unobstructed' do
      it 'returns true' do
        allow(piece).to receive(:location).and_return([6, 0])
        game_board[6][0] = piece
        location = [0, 0]
        expect(reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can reach a diagonal location unobstructed' do
      it 'returns true' do
        game_board[0][0] = piece
        location = [6, 6]
        expect(reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can reach a diagonal location with an enemy' do
      it 'returns true' do
        game_board[0][0] = piece
        game_board[6][6] = piece2
        location = [6, 6]
        expect(reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can reach an upper diagonal location unobstructed' do
      it 'returns true' do
        game_board[6][6] = piece
        allow(piece).to receive(:location).and_return([6, 6])
        location = [0, 0]
        expect(reachable?(piece, location)).to be true
      end
    end

    context 'when the piece cant reach a horizontal location unobstructed' do
      it 'returns false' do
        game_board[0][0] = piece
        game_board[0][4] = piece2
        location = [0, 6]
        expect(reachable?(piece, location)).to be false
      end
    end

    context 'when the piece cant reach a vertical location unobstructed' do
      it 'returns false' do
        game_board[0][0] = piece
        game_board[4][0] = piece2
        location = [6, 0]
        expect(reachable?(piece, location)).to be false
      end
    end

    context 'when the piece cant reach a higher vertical location unobstructed' do
      it 'returns false' do
        allow(piece).to receive(:location).and_return([6, 0])
        game_board[6][0] = piece
        game_board[4][0] = piece2
        location = [0, 0]
        expect(reachable?(piece, location)).to be false
      end
    end

    context 'when the piece cant reach a diagonal location unobstructed' do
      it 'returns false' do
        game_board[0][0] = piece
        game_board[4][4] = piece2
        location = [6, 6]
        expect(reachable?(piece, location)).to be false
      end
    end

    context 'when the piece cant reach an upper diagonal location unobstructed' do
      it 'returns false' do
        game_board[6][6] = piece
        allow(piece).to receive(:location).and_return([6, 6])
        game_board[4][4] = piece2
        location = [0, 0]
        expect(reachable?(piece, location)).to be false
      end
    end
  end
end
