# frozen_string_literal: true

require './lib/piece.rb'

describe King do
  subject(:king) { King.new([0, 4]) }

  describe '#symbol' do
    context 'when white' do
      it 'returns the white king symbol' do
        expect(king.symbol('white')).to eql('♔')
      end
    end

    context 'when black' do
      it 'returns the black king symbol' do
        expect(king.symbol('black')).to eql('♚')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      king.move([0, 1])
      expect(king.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(king.legal_move?([1, 4])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(king.legal_move?([4, 7])).to be nil
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(king.legal_move?([0, 4])).to be nil
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(king.legal_move?([-1, 16])).to be nil
      end
    end
  end
end

describe Queen do
  subject(:queen) { Queen.new([0, 3]) }

  describe '#symbol' do
    context 'when white' do
      it 'returns the white queen symbol' do
        expect(queen.symbol('white')).to eql('♕')
      end
    end

    context 'when black' do
      it 'returns the black queen symbol' do
        expect(queen.symbol('black')).to eql('♛')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      queen.move([0, 1])
      expect(queen.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when a legal horizontal move is given' do
      it 'returns true' do
        expect(queen.legal_move?([0, 7])).to be true
      end
    end

    context 'when a legal vertical move is given' do
      it 'returns true' do
        expect(queen.legal_move?([7, 3])).to be true
      end
    end

    context 'when legal diagonal move is given' do
      it 'returns true' do
        expect(queen.legal_move?([4, 7])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(queen.legal_move?([4, 8])).to be nil
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(queen.legal_move?([0, 3])).to be nil
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(queen.legal_move?([-1, 16])).to be nil
      end
    end
  end
end

describe Rook do
  subject(:rook) { Rook.new([0, 0]) }

  describe '#symbol' do
    context 'when white' do
      it 'returns the white rook symbol' do
        expect(rook.symbol('white')).to eql('♖')
      end
    end

    context 'when black' do
      it 'returns the black rook symbol' do
        expect(rook.symbol('black')).to eql('♜')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      rook.move([0, 1])
      expect(rook.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(rook.legal_move?([0, 7])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(rook.legal_move?([1, 2])).to be nil
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(rook.legal_move?([0, 0])).to be nil
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(rook.legal_move?([-1, 16])).to be nil
      end
    end
  end
end

describe Bishop do
  subject(:bishop) { Bishop.new([0, 1]) }

  describe '#symbol' do
    context 'when white' do
      it 'returns the white bishop symbol' do
        expect(bishop.symbol('white')).to eql('♗')
      end
    end

    context 'when black' do
      it 'returns the black bishop symbol' do
        expect(bishop.symbol('black')).to eql('♝')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      bishop.move([0, 1])
      expect(bishop.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(bishop.legal_move?([6, 7])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(bishop.legal_move?([0, 7])).to be nil
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(bishop.legal_move?([0, 1])).to be nil
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(bishop.legal_move?([-1, 16])).to be nil
      end
    end
  end
end

describe Knight do
  subject(:knight) { Knight.new([0, 1]) }

  describe '#symbol' do
    context 'when white' do
      it 'returns the white knight symbol' do
        expect(knight.symbol('white')).to eql('♘')
      end
    end

    context 'when black' do
      it 'returns the black knight symbol' do
        expect(knight.symbol('black')).to eql('♞')
      end
    end
  end

  describe '#move' do
    it 'sets @location to the new location' do
      knight.move([0, 1])
      expect(knight.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal move is given' do
      it 'returns true' do
        expect(knight.legal_move?([2, 2])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(knight.legal_move?([0, 7])).to be nil
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(knight.legal_move?([0, 1])).to be nil
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(knight.legal_move?([-1, 16])).to be nil
      end
    end
  end
end

describe Pawn do
  let(:game) { instance_double('game') }
  subject(:pawn) { Pawn.new(game, [1, 1]) }

  before do
    allow(game).to receive(:enemy_at?).and_return(true)
  end

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

  describe '#move' do
    it 'sets @location to the new location' do
      pawn.move([0, 1])
      expect(pawn.instance_variable_get('@location')).to eql([0, 1])
    end
  end

  describe '#legal_move?' do
    context 'when legal 1 square positive first move is given' do
      it 'returns true' do
        expect(pawn.legal_move?([2, 1])).to be true
      end
    end

    context 'when legal 2 square positive first move is given' do
      it 'returns true' do
        expect(pawn.legal_move?([3, 1])).to be true
      end
    end

    context 'when legal 1 square negative first move is given' do
      subject(:pawn) { Pawn.new(game, [6, 1]) }
      it 'returns true' do
        expect(pawn.legal_move?([5, 1])).to be true
      end
    end

    context 'when legal attack move is given' do
      it 'returns true' do

        expect(pawn.legal_move?([2, 2])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(pawn.legal_move?([0, 7])).to be nil
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(pawn.legal_move?([0, 1])).to be nil
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(pawn.legal_move?([-1, 16])).to be nil
      end
    end
  end
end
