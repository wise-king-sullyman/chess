# frozen_string_literal: true

require_relative '../lib/assign_pieces'

class AssignPiecesDummyClass
  include AssignPieces
end

describe 'AssignPieces' do
  subject(:piece_assigner) { AssignPiecesDummyClass.new }

  let(:player) { double('player') }
  let(:game) { double('game') }
  let(:pieces) { [] }

  before do
    allow(player).to receive(:color)
  end

  describe '#assign_pieces' do
    before do
      allow(piece_assigner).to receive(:assign_rooks)
      allow(piece_assigner).to receive(:assign_knights)
      allow(piece_assigner).to receive(:assign_bishops)
      allow(piece_assigner).to receive(:assign_queen)
      allow(piece_assigner).to receive(:assign_king)
      allow(piece_assigner).to receive(:assign_pawns)
    end

    it 'calls #assign_rooks with the player, game, and current pieces array' do
      expect(piece_assigner).to receive(:assign_rooks).with(player, game, pieces)
      piece_assigner.assign_pieces(player, game)
    end

    it 'calls #assign_knights with the player, game, and current pieces array' do
      expect(piece_assigner).to receive(:assign_knights).with(player, game, pieces)
      piece_assigner.assign_pieces(player, game)
    end

    it 'calls #assign_bishops with the player, game, and current pieces array' do
      expect(piece_assigner).to receive(:assign_bishops).with(player, game, pieces)
      piece_assigner.assign_pieces(player, game)
    end

    it 'calls #assign_queen with the player, game, and current pieces array' do
      expect(piece_assigner).to receive(:assign_queen).with(player, game, pieces)
      piece_assigner.assign_pieces(player, game)
    end

    it 'calls #assign_king with the player, game, and current pieces array' do
      expect(piece_assigner).to receive(:assign_king).with(player, game, pieces)
      piece_assigner.assign_pieces(player, game)
    end

    it 'calls #assign_pawns with the player, game, and current pieces array' do
      expect(piece_assigner).to receive(:assign_pawns).with(player, game, pieces)
      piece_assigner.assign_pieces(player, game)
    end

    it 'returns the pieces array' do
      expect(piece_assigner.assign_pieces(player, game)).to eq(pieces)
    end
  end

  describe '#assign_rooks' do
    it 'adds two items to the provided pieces array' do
      expect { piece_assigner.assign_rooks(player, game, pieces) }.to change { pieces.size }.by(2)
    end

    it 'only adds rooks to pieces' do
      piece_assigner.assign_rooks(player, game, pieces)
      expect(pieces.all? { |piece| piece.instance_of?(Rook) }).to be(true)
    end

    context 'when the player is white' do
      let(:expected_first_location) { [7, 0] }
      let(:expected_second_location) { [7, 7] }

      before do
        allow(player).to receive(:color).and_return('white')
      end

      it 'assign the expected first location to the first rook' do
        piece_assigner.assign_rooks(player, game, pieces)
        expect(pieces.first.location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second rook' do
        piece_assigner.assign_rooks(player, game, pieces)
        expect(pieces.last.location).to eq(expected_second_location)
      end
    end

    context 'when the player is black' do
      let(:expected_first_location) { [0, 0] }
      let(:expected_second_location) { [0, 7] }

      before do
        allow(player).to receive(:color).and_return('black')
      end

      it 'assign the expected first location to the first rook' do
        piece_assigner.assign_rooks(player, game, pieces)
        expect(pieces.first.location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second rook' do
        piece_assigner.assign_rooks(player, game, pieces)
        expect(pieces.last.location).to eq(expected_second_location)
      end
    end
  end
end
