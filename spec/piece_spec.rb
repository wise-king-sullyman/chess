# frozen_string_literal: true

require './lib/piece.rb'

describe King do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:king) { King.new(game, player, [0, 4]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:in_check_at?).and_return(false)
  end

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
        expect(king.legal_move?([4, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(king.legal_move?([0, 4])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(king.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    it 'returns false' do
      allow(game).to receive(:enemy_king_location).and_return([7, 4])
      expect(king.can_attack_king?).to be false
    end
  end

  describe '#can_move?' do
    context 'when the king can move' do
      it 'returns true' do
        allow(king).to receive(:possible_moves).and_return([[1, 2]])
        expect(king.can_move?).to be true
      end
    end

    context 'when the king cannot move' do
      it 'returns false' do
        allow(king).to receive(:possible_moves).and_return([])
        expect(king.can_move?).to be false
      end
    end
  end
end

describe Queen do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:queen) { Queen.new(game, player, [0, 3]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
  end

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
        expect(queen.legal_move?([4, 8])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(queen.legal_move?([0, 3])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(queen.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([0, 6])
        expect(queen.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(queen.can_attack_king?).to be false
      end
    end
  end
end

describe Rook do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:rook) { Rook.new(game, player, [0, 0]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
  end

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
        expect(rook.legal_move?([1, 2])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(rook.legal_move?([0, 0])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(rook.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([7, 0])
        expect(rook.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(rook.can_attack_king?).to be false
      end
    end
  end
end

describe Bishop do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:bishop) { Bishop.new(game, player, [0, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
  end

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
        expect(bishop.legal_move?([0, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(bishop.legal_move?([0, 1])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(bishop.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([6, 7])
        expect(bishop.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(bishop.can_attack_king?).to be false
      end
    end
  end
end

describe Knight do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:knight) { Knight.new(game, player, [0, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
  end

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
        expect(knight.legal_move?([0, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(knight.legal_move?([0, 1])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(knight.legal_move?([-1, 16])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([2, 2])
        expect(knight.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(knight.can_attack_king?).to be false
      end
    end
  end
end

describe Pawn do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  subject(:pawn) { Pawn.new(game, player, [1, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:piece_at).and_return(nil)
  end

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
      subject(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns true' do
        expect(pawn.legal_move?([5, 1])).to be true
      end
    end

    context 'when legal attack move from top to bottom is given' do
      it 'returns true' do
        expect(pawn.legal_move?([2, 2])).to be true
      end
    end

    context 'when legal attack move from bottom to top is given' do
      let(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns true' do
        expect(pawn.legal_move?([5, 2])).to be true
      end
    end

    context 'when non-legal move is given' do
      it 'returns false' do
        expect(pawn.legal_move?([0, 7])).to be false
      end
    end

    context 'when move is current location' do
      it 'returns false' do
        expect(pawn.legal_move?([0, 1])).to be false
      end
    end

    context 'when off board move is given' do
      it 'returns false' do
        expect(pawn.legal_move?([-1, 16])).to be false
      end
    end

    context 'when enemy is in front of pawn' do
      it 'returns false' do
        allow(game).to receive(:piece_at).and_return(true)
        expect(pawn.legal_move?([2, 1])).to be false
      end
    end
  end

  describe '#can_attack_king?' do
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([2, 0])
        expect(pawn.can_attack_king?).to be true
      end
    end

    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(pawn.can_attack_king?).to be false
      end
    end
  end
end
