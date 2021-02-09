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
end