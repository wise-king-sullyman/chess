# frozen_string_literal: true

require_relative '../lib/pieces/piece'

describe Piece do
  let(:game) { double('game') }
  let(:player) { double('player') }
  let(:location) { [4, 4] }
  let(:dummy_class) do
    class DummyClass
      include Piece
    end
  end
  subject(:piece) { dummy_class.new(game, player, location) }
end
