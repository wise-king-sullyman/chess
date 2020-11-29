# frozen_string_literal: true

require_relative '../lib/ai.rb'

describe AI do
  let(:game) { double('game') }
  subject(:ai) { AI.new('player 1', 'white', game) }
  describe '#move' do
  end
end
