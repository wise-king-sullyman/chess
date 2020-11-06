# frozen_string_literal: true

require './lib/game.rb'

describe Game do
  let(:board) { double('board') }
  let(:player) { double('player') }
  let(:player2) { double('player') }
  let(:piece) { double('piece') }
  subject(:game) { Game.new }

  describe '#enemy_king_location' do
    let(:player2) { instance_double('player') }
    it 'returns the enemy kings location' do
      allow(player2).to receive(:king_location).and_return([7, 5])
      game.instance_variable_set('@players', [player, player2])
      expect(game.enemy_king_location(player)).to eql([7, 5])
    end
  end

  describe '#enemy_at?' do
    before do
      game.instance_variable_set('@players', [player, player2])
      game.instance_variable_set('@board', board)
    end

    context 'when an enemy piece is at the location' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(game.enemy_at?(player, [7, 1])).to be true
      end
    end

    context 'when no piece is at the location' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(nil)
        expect(game.enemy_at?(player, [7, 1])).to be false
      end
    end

    context 'when a friendly piece is at the location' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:parent).and_return(player)
        expect(game.enemy_at?(player, [7, 1])).to be false
      end
    end
  end

  describe '#available?' do
    let(:location) { 'foo' }

    before do
      game.instance_variable_set('@players', [player, player2])
      game.instance_variable_set('@board', board)
    end

    context 'when a player selects an empty space' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(nil)
        expect(game.available?(player, location)).to be true
      end
    end

    context 'when a player selects a space with an enemy piece' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(game.available?(player, location)).to be true
      end
    end

    context 'when a player selects a space with one of their pieces' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player)
        expect(game.available?(player, location)).to be false
      end
    end
  end

  describe '#reachable?' do
    let(:board) { game.instance_variable_get(@board) }
    let(:piece2) { double('piece') }

    context 'when the piece can reach a horizontal location unobstructed' do
      it 'returns true' do
        board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [0, 7]
        expect(game.reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can reach a diagonal location unobstructed' do
      it 'returns true' do
        board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location)).to be true
      end
    end

    context 'when the piece can not reach a horizontal location unobstructed' do
      it 'returns false' do
        board[0][0] = piece
        board[0][4] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 7]
        expect(game.reachable?(piece, location)).to be false
      end
    end

    context 'when the piece can not reach a diagonal location unobstructed' do
      it 'returns false' do
        board[0][0] = piece
        board[4][4] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location)).to be false
      end
    end
  end
end
