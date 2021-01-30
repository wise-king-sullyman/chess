# frozen_string_literal:true

require_relative '../lib/check_detection'

describe 'CheckDetection' do
  class CheckDummyClass
    include CheckDetection

    def other_player(player)
    end
  end

  subject(:check_tester) { CheckDummyClass.new }

  let(:board) { double('board') }
  let(:player) { double('player') }
  let(:player2) { double('player') }
  let(:piece) { double('piece') }
  let(:piece2) { double('piece') }

  before do
    allow(check_tester).to receive(:other_player).and_return(player2)
  end

  describe '#player_in_check?' do
    context 'when the other players enemy (aka the player passed in as the argument) is in check' do
      it 'returns true' do
        allow(check_tester).to receive(:enemy_in_check?).with(player2).and_return(true)
        expect(check_tester.player_in_check?(player)).to be true
      end
    end

    context 'when the other players enemy is not in check' do
      it 'returns false' do
        allow(check_tester).to receive(:enemy_in_check?).with(player2).and_return(false)
        expect(check_tester.player_in_check?(player)).to be false
      end
    end
  end

  describe '#player_in_checkmate' do
    context 'when player is in checkmate?' do
      it 'returns true' do
        allow(check_tester).to receive(:player_in_check?).and_return(true)
        allow(player).to receive(:mated?).and_return(true)
        expect(check_tester.player_in_checkmate?(player)).to be true
      end
    end

    context 'when player is in check but not mated' do
      it 'returns false' do
        allow(check_tester).to receive(:player_in_check?).and_return(true)
        allow(player).to receive(:mated?).and_return(false)
        expect(check_tester.player_in_checkmate?(player)).to be false
      end
    end

    context 'when player is mated but not in check' do
      it 'returns false' do
        allow(check_tester).to receive(:player_in_check?).and_return(false)
        allow(player).to receive(:mated?).and_return(true)
        expect(check_tester.player_in_checkmate?(player)).to be false
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
        expect(check_tester.enemy_in_check?(player)).to be true
      end
    end

    context 'when the enemy player is not in check' do
      it 'returns false' do
        allow(piece).to receive(:can_attack_king?).and_return(false)
        expect(check_tester.enemy_in_check?(player)).to be false
      end
    end
  end

  describe '#move_checks_self?' do
    let(:test_location) { [2, 2] }
    let(:piece_start_location) { [3, 3] }

    before do
      allow(piece).to receive(:location).and_return(piece_start_location)
      allow(board).to receive(:piece_at).and_return(piece2)
      allow(check_tester).to receive(:test_move)
      allow(check_tester).to receive(:player_in_check?)
      allow(piece).to receive(:player)
    end

    context 'when the player of the piece is in check after the test move' do
      it 'returns true' do
        allow(check_tester).to receive(:player_in_check?).and_return(true)
        result = check_tester.move_checks_self?(piece, test_location, board)
        expect(result).to be true
      end
    end

    context 'when the player of the piece is not in check after the test move' do
      it 'returns false' do
        allow(check_tester).to receive(:player_in_check?).and_return(false)
        result = check_tester.move_checks_self?(piece, test_location, board)
        expect(result).to be false
      end
    end

    it 'calls test_move with the piece, no replacement piece, the test location, and the board' do
      expect(check_tester).to receive(:test_move).with(piece, nil, test_location, board)
      check_tester.move_checks_self?(piece, test_location, board)
    end

    it 'calls test_move with the piece, the piece originally at test_loction, the original location of piece, and board' do
      expect(check_tester).to receive(:test_move).with(piece, piece2, piece_start_location, board)
      check_tester.move_checks_self?(piece, test_location, board)
    end
  end

  describe '#test_move' do
    let(:to_location) { [2, 2] }
    let(:piece_start_location) { [3, 3] }

    before do
      allow(piece).to receive(:location).and_return(piece_start_location)
      allow(piece).to receive(:move)
      allow(board).to receive(:update)
    end

    it 'calls #move on the given piece with the destination location' do
      expect(piece).to receive(:move).with(to_location, true)
      check_tester.test_move(piece, piece2, to_location, board)
    end

    it 'calls board.update with the pieces original row, column, and what to replace the piece with' do
      expect(board).to receive(:update).with(piece_start_location.first, piece_start_location.last, piece2)
      check_tester.test_move(piece, piece2, to_location, board)
    end

    it 'calls board.update with the destination row, column, and piece' do
      expect(board).to receive(:update).with(to_location.first, to_location.last, piece)
      check_tester.test_move(piece, piece2, to_location, board)
    end
  end

  describe '#in_check_at?' do
    let(:players) { [player, player2] }

    before do
      allow(player2).to receive(:pieces).and_return([piece])
      check_tester.instance_variable_set('@players', players)
    end

    context 'when move would be in check' do
      it 'returns true' do
        allow(piece).to receive(:can_attack_location?).and_return(true)
        expect(check_tester.in_check_at?(player, [0, 0])).to be true
      end
    end

    context 'when move would not be in check' do
      it 'returns true' do
        allow(piece).to receive(:can_attack_location?).and_return(false)
        expect(check_tester.in_check_at?(player, [0, 0])).to be false
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
      check_tester.instance_variable_set('@players', players)
      allow(board).to receive(:piece_at)
      allow(board).to receive(:update)
    end
    context 'when move puts self into check' do
      it 'reutrns true' do
        allow(piece2).to receive(:can_attack_king?).and_return(true)
        expect(check_tester.move_checks_self?(piece, location, board)).to be true
      end
    end

    context 'when move does not put self into check' do
      it 'reutrns false' do
        allow(piece2).to receive(:can_attack_king?).and_return(false)
        expect(check_tester.move_checks_self?(piece, location, board)).to be false
      end
    end
  end
end