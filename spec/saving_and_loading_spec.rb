# frozen_string_literal: true

require_relative '../lib/saving_and_loading'

class SaveAndLoadDummyClass
  include SavingAndLoading

  attr_accessor :players, :board
end

describe 'SavingAndLoading' do
  subject(:save_load_tester) { SaveAndLoadDummyClass.new }

  let(:players) { double('players') }
  let(:board) { double('board') }
  let(:player) { double('player') }

  describe '#save_game' do
    let(:mocked_game_save) { { players: players, board: board, player: player } }
    let(:game_save) { double('game_save') }

    it 'calls #to_yaml on the result from #game_state' do
      allow(save_load_tester).to receive(:game_state).and_return(game_save)
      expect(game_save).to receive(:to_yaml)
      save_load_tester.save_game(player, 'file_name.yaml')
    end

    it 'calls for game_state.to_yaml to be saved as the given file name' do
      allow(save_load_tester).to receive(:game_state).and_return(mocked_game_save)
      allow(File).to receive(:open).with('file_name.yaml', 'w') do |file|
        expect(file).to receive(:write).with(mocked_game_save.to_yaml)
      end
    end
  end

  describe '#load_game' do
    let(:mocked_game_save) { { players: players, board: board, player: player } }

    before do
      allow(save_load_tester).to receive(:players).and_return(players)
      allow(players).to receive(:first)
      allow(players).to receive(:reverse!)
    end

    it 'sets self.players to the saved games players value' do
      expect(save_load_tester).to receive(:players=).with(players)
      save_load_tester.load_game(mocked_game_save)
    end

    it 'sets self.board to the saved games board value' do
      expect(save_load_tester).to receive(:board=).with(board)
      save_load_tester.load_game(mocked_game_save)
    end

    context 'when the player in the save is the first player in players' do
      it 'does not call #reverse! on self.players' do
        allow(players).to receive(:first).and_return(player)
        expect(players).not_to receive(:reverse!)
        save_load_tester.load_game(mocked_game_save)
      end
    end

    context 'when the player in the save is not the first player in players' do
      it 'calls #reverse! on self.players' do
        allow(players).to receive(:first).and_return(double('player2'))
        expect(players).to receive(:reverse!)
        save_load_tester.load_game(mocked_game_save)
      end
    end
  end

  describe '#ask_to_load_game' do
    before do
      allow(save_load_tester).to receive(:load_game)
    end

    context 'when the users responds to the load prompt with y' do
      it 'calls #load_game' do
        allow(save_load_tester).to receive(:prompt_user_to_load_game).and_return('y')
        expect(save_load_tester).to receive(:load_game).once
        save_load_tester.ask_to_load_game
      end
    end

    context 'when the user responds to the load prompt with n' do
      it 'does not call #load_game' do
        allow(save_load_tester).to receive(:prompt_user_to_load_game).and_return('n')
        expect(save_load_tester).not_to receive(:load_game)
        save_load_tester.ask_to_load_game
      end
    end

    context 'when the user responds to the load prompt with random text' do
      it 'does not call #load_game' do
        allow(save_load_tester).to receive(:prompt_user_to_load_game).and_return('aefsdbv43#R4683')
        expect(save_load_tester).not_to receive(:load_game)
        save_load_tester.ask_to_load_game
      end
    end

    context 'when the user responds to the load prompt with nothing' do
      it 'does not call #load_game' do
        allow(save_load_tester).to receive(:prompt_user_to_load_game).and_return('')
        expect(save_load_tester).not_to receive(:load_game)
        save_load_tester.ask_to_load_game
      end
    end
  end
end