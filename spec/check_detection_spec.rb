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