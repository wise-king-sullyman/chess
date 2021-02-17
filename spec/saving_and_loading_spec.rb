# frozen_string_literal: true

require_relative '../lib/saving_and_loading'

class SaveAndLoadDummyClass
  include SavingAndLoading
end

describe 'SavingAndLoading' do
  subject(:save_load_tester) { SaveAndLoadDummyClass.new }

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