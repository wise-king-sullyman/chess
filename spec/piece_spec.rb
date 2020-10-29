# frozen_string_literal: true

require './lib/piece.rb'

describe Piece do
  subject(:piece) { Piece.new([0, 0]) }

  describe '#move' do
    it 'sets @location to the new location' do
      piece.move([0, 1])
      expect(piece.instance_variable_get('@location')).to eql([0, 1])
    end
  end
end

describe Pawn do
  subject(:pawn) { Pawn.new([0, 1]) }

  describe '#symbol' do
    context 'when white' do
      it 'returns the white pawn symbol' do
        expect(pawn.symbol('white')).to eql('♙')
      end
    end

    context 'when black' do
      it 'returns the black pawn symbol' do
        expect(pawn.symbol('black')).to eql('♟')
      end
    end
  end
end
