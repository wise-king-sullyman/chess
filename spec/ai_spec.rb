# frozen_string_literal: true

require_relative '../lib/ai'

describe AI do
  let(:game_double) { instance_double(Game)}
  subject(:ai_test) { described_class.new('Hal', 'white', game_double) }

  describe '#random_tile' do
    before do
      allow(ai_test).to receive(:random_row_selection).and_return('2')
      allow(ai_test).to receive(:random_column_selection).and_return('b')
    end

    it 'calls #update_last_move with its randomly selection location' do
      expect(ai_test).to receive(:update_last_move).with('b2')
      ai_test.random_tile
    end

    it 'returns the translated tile choice' do
      expect(ai_test.random_tile).to eq([6, 1])
    end
  end
end