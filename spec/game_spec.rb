# frozen_string_literal: true

require './lib/game'

describe Game do
  let(:board) { double('board') }
  let(:player) { double('player') }
  let(:player2) { double('player') }
  let(:piece) { double('piece') }
  let(:piece2) { double('piece') }
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
        expect(game.available?(player, location, board)).to be true
      end
    end

    context 'when a player selects a space with an enemy piece' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(game.available?(player, location, board)).to be true
      end
    end

    context 'when a player selects a space with one of their pieces' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player)
        expect(game.available?(player, location, board)).to be false
      end
    end
  end

  describe '#reachable?' do
    let(:board) { game.instance_variable_get('@board') }
    let(:game_board) { board.instance_variable_get('@game_board') }
    let(:players) { game.instance_variable_get('@players') }
    let(:player1) { players.first }
    let(:player2) { players.last }


    before do
      allow(piece).to receive(:location).and_return([0, 0])
      allow(piece).to receive(:player).and_return(player1)
      allow(piece2).to receive(:player).and_return(player2)
    end

    context 'when the piece can reach a horizontal location unobstructed' do
      it 'returns true' do
        game_board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [0, 6]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a vertical location unobstructed' do
      it 'returns true' do
        game_board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [6, 0]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a higher vertical location unobstructed' do
      it 'returns true' do
        allow(piece).to receive(:location).and_return([6, 0])
        game_board[6][0] = piece
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a diagonal location unobstructed' do
      it 'returns true' do
        game_board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a diagonal location with an enemy' do
      it 'returns true' do
        game_board[0][0] = piece
        game_board[6][6] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach an upper diagonal location unobstructed' do
      it 'returns true' do
        game_board[6][6] = piece
        allow(piece).to receive(:location).and_return([6, 6])
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece cant reach a horizontal location unobstructed' do
      it 'returns false' do
        game_board[0][0] = piece
        game_board[0][4] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 6]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach a vertical location unobstructed' do
      it 'returns false' do
        game_board[0][0] = piece
        game_board[4][0] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 0]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach a higher vertical location unobstructed' do
      it 'returns false' do
        allow(piece).to receive(:location).and_return([6, 0])
        game_board[6][0] = piece
        game_board[4][0] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach a diagonal location unobstructed' do
      it 'returns false' do
        game_board[0][0] = piece
        game_board[4][4] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach an upper diagonal location unobstructed' do
      it 'returns false' do
        game_board[6][6] = piece
        allow(piece).to receive(:location).and_return([6, 6])
        game_board[4][4] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end
  end

  describe '#enemy_in_check?' do
    before do
      allow(player).to receive(:pieces).and_return([piece])
    end

    context 'when the enemy player is in check' do
      it 'returns true' do
        allow(piece).to receive(:can_attack_king?).and_return(true)
        expect(game.enemy_in_check?(player)).to be true
      end
    end

    context 'when the enemy player is not in check' do
      it 'returns false' do
        allow(piece).to receive(:can_attack_king?).and_return(false)
        expect(game.enemy_in_check?(player)).to be false
      end
    end
  end

  describe '#in_check_at?' do
    let(:players) { [player, player2] }

    before do
      allow(player2).to receive(:pieces).and_return([piece])
      game.instance_variable_set('@players', players)
    end

    context 'when move would be in check' do
      it 'returns true' do
        allow(piece).to receive(:can_attack_location?).and_return(true)
        expect(game.in_check_at?(player, [0, 0])).to be true
      end
    end

    context 'when move would not be in check' do
      it 'returns true' do
        allow(piece).to receive(:can_attack_location?).and_return(false)
        expect(game.in_check_at?(player, [0, 0])).to be false
      end
    end
  end

  describe '#move_checks_self?' do
    let(:location) { [0, 0] }
    let(:players) { [player, player2] }

    before do
      allow(piece).to receive(:move)
      allow(piece).to receive(:player).and_return(player)
      allow(piece).to receive(:location)
      allow(player2).to receive(:pieces).and_return([piece2])
      game.instance_variable_set('@players', players)
      allow(board).to receive(:piece_at)
      allow(board).to receive(:refresh)
    end
    context 'when move puts self into check' do
      it 'reutrns true' do
        allow(piece2).to receive(:can_attack_king?).and_return(true)
        expect(game.move_checks_self?(piece, location, board)).to be true
      end
    end

    context 'when move does not put self into check' do
      it 'reutrns false' do
        allow(piece2).to receive(:can_attack_king?).and_return(false)
        expect(game.move_checks_self?(piece, location, board)).to be false
      end
    end
  end
end
