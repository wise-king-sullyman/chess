# frozen_string_literal: true

require './lib/game.rb'

describe Game do
  let(:player) { instance_double('player') }
  subject(:game) { Game.new }

  describe '#enemy_king_location' do
    let(:player2) { instance_double('player') }
    it 'returns the enemy kings location' do
      allow(player2).to receive(:king_location).and_return([7, 5])
      game.instance_variable_set('@players', [player, player2])
      expect(game.enemy_king_location(player)).to eql([7, 5])
    end
  end
end
