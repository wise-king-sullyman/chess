# frozen_string_literal: true

require './lib/pawn.rb'

describe Pawn do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  let(:board) { double('board') }
  let(:knight) { double('knight') }
  subject(:pawn) { Pawn.new(game, player, [1, 1]) }

  before do
    allow(game).to receive(:available?).and_return(true)
    allow(game).to receive(:reachable?).and_return(true)
    allow(game).to receive(:piece_at).and_return(nil)
    allow(game).to receive(:move_checks_self?).and_return(false)
    allow(game).to receive(:board).and_return(board)
    allow(knight).to receive(:location)
    allow(board).to receive(:piece_at)
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

    context 'when a double move is performed' do
      it 'sets @vulnerable_to_en_passant to true' do
        pawn.move([3, 1])
        expect(pawn.vulnerable_to_en_passant).to be true
      end
    end

    context 'when a single move is performed' do
      it 'leaves @vulnerable_to_en_passant false' do
        pawn.move([2, 1])
        expect(pawn.vulnerable_to_en_passant).to be false
      end
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
        allow(game).to receive(:piece_at).and_return(knight)
        expect(pawn.legal_move?([2, 1])).to be false
      end
    end

    context 'when double move is attempted but an emeny is two squares ahead' do
      it 'returns false' do
        allow(game).to receive(:piece_at).and_return(knight)
        expect(pawn.legal_move?([3, 1])).to be false
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

  describe '#eligible_for_promotion?' do
    context 'when piece starting in row 1 reaches row 7' do
      it 'returns true' do
        pawn.move([7, 1])
        expect(pawn.eligible_for_promotion?).to be true
      end
    end

    context 'when piece starting in row 6 reaches row 0' do
      subject(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns true' do
        pawn.move([0, 1])
        expect(pawn.eligible_for_promotion?).to be true
      end
    end

    context 'when piece starting in row 1 has not reached row 7' do
      it 'returns false' do
        pawn.move([6, 1])
        expect(pawn.eligible_for_promotion?).to be false
      end
    end

    context 'when piece starting in row 6 has not reached row 0' do
      subject(:pawn) { Pawn.new(game, player, [6, 1]) }
      it 'returns false' do
        pawn.move([1, 1])
        expect(pawn.eligible_for_promotion?).to be false
      end
    end
  end

  describe '#add_en_passant_moves_if_applicable' do
    let(:enemy_pawn) { double('pawn') }

    before do
      allow(enemy_pawn).to receive(:location)
    end

    context 'when no piece is to the side' do
      it 'does not change moves' do
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when a non pawn piece is to the right' do
      it 'does not change moves' do
        allow(game).to receive(:piece_at).and_return(knight, nil)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when a non pawn piece is to the left' do
      it 'does not change moves' do
        allow(game).to receive(:piece_at).and_return(nil, knight)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when a non pawn piece is on both sides' do
      it 'adds the en pasant move' do
        allow(game).to receive(:piece_at).and_return(knight)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when a non en passant vulnerable pawn is to the right' do
      it 'does not change moves' do
        allow(game).to receive(:piece_at).and_return(enemy_pawn, nil)
        allow(enemy_pawn).to receive(:vulnerable_to_en_passant).and_return(false)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when a non en passant vulnerable pawn is to the left' do
      it 'does not change moves' do
        allow(game).to receive(:piece_at).and_return(nil, enemy_pawn)
        allow(enemy_pawn).to receive(:vulnerable_to_en_passant).and_return(false)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when non en passant vulnerable pawns are to the left and right' do
      it 'adds the en pasant move' do
        allow(game).to receive(:piece_at).and_return(enemy_pawn)
        allow(enemy_pawn).to receive(:vulnerable_to_en_passant).and_return(false)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to eq([])
      end
    end

    context 'when an en passant vulnerable pawn is to the right' do
      let(:enemy_pawn) { double('pawn') }
      it 'adds the en pasant move' do
        allow(game).to receive(:piece_at).and_return(enemy_pawn, nil)
        allow(enemy_pawn).to receive(:vulnerable_to_en_passant).and_return(true)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to include([2, 2])
      end
    end

    context 'when an en passant vulnerable pawn is to the left' do
      let(:enemy_pawn) { double('pawn') }
      it 'adds the en pasant move' do
        allow(game).to receive(:piece_at).and_return(nil, enemy_pawn)
        allow(enemy_pawn).to receive(:vulnerable_to_en_passant).and_return(true)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to include([2, 0])
      end
    end

    context 'when en passant vulnerable pawns are to the left and right' do
      let(:enemy_pawn) { double('pawn') }
      it 'adds the en pasant move' do
        allow(game).to receive(:piece_at).and_return(enemy_pawn)
        allow(enemy_pawn).to receive(:vulnerable_to_en_passant).and_return(true)
        moves = []
        pawn.add_en_passant_moves_if_applicable(moves, 1, 1)
        expect(moves).to include([2, 0], [2, 2])
      end
    end
  end
end
