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

  describe '#assign_knights' do
    it 'adds two items to the provided pieces array' do
      expect { piece_assigner.assign_knights(player, game, pieces) }.to change { pieces.size }.by(2)
    end

    it 'only adds knights to pieces' do
      piece_assigner.assign_knights(player, game, pieces)
      expect(pieces.all? { |piece| piece.instance_of?(Knight) }).to be(true)
    end

    context 'when the player is white' do
      let(:expected_first_location) { [7, 1] }
      let(:expected_second_location) { [7, 6] }

      before do
        allow(player).to receive(:color).and_return('white')
      end

      it 'assign the expected first location to the first knight' do
        piece_assigner.assign_knights(player, game, pieces)
        expect(pieces.first.location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second knight' do
        piece_assigner.assign_knights(player, game, pieces)
        expect(pieces.last.location).to eq(expected_second_location)
      end
    end

    context 'when the player is black' do
      let(:expected_first_location) { [0, 1] }
      let(:expected_second_location) { [0, 6] }

      before do
        allow(player).to receive(:color).and_return('black')
      end

      it 'assign the expected first location to the first knight' do
        piece_assigner.assign_knights(player, game, pieces)
        expect(pieces.first.location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second knight' do
        piece_assigner.assign_knights(player, game, pieces)
        expect(pieces.last.location).to eq(expected_second_location)
      end
    end
  end

  describe '#assign_bishops' do
    it 'adds two items to the provided pieces array' do
      expect { piece_assigner.assign_bishops(player, game, pieces) }.to change { pieces.size }.by(2)
    end

    it 'only adds bishops to pieces' do
      piece_assigner.assign_bishops(player, game, pieces)
      expect(pieces.all? { |piece| piece.instance_of?(Bishop) }).to be(true)
    end

    context 'when the player is white' do
      let(:expected_first_location) { [7, 2] }
      let(:expected_second_location) { [7, 5] }

      before do
        allow(player).to receive(:color).and_return('white')
      end

      it 'assign the expected first location to the first bishop' do
        piece_assigner.assign_bishops(player, game, pieces)
        expect(pieces.first.location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second bishop' do
        piece_assigner.assign_bishops(player, game, pieces)
        expect(pieces.last.location).to eq(expected_second_location)
      end
    end

    context 'when the player is black' do
      let(:expected_first_location) { [0, 2] }
      let(:expected_second_location) { [0, 5] }

      before do
        allow(player).to receive(:color).and_return('black')
      end

      it 'assign the expected first location to the first bishop' do
        piece_assigner.assign_bishops(player, game, pieces)
        expect(pieces.first.location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second bishop' do
        piece_assigner.assign_bishops(player, game, pieces)
        expect(pieces.last.location).to eq(expected_second_location)
      end
    end
  end

  describe '#assign_queen' do
    it 'adds one item to the provided pieces array' do
      expect { piece_assigner.assign_queen(player, game, pieces) }.to change { pieces.size }.by(1)
    end

    it 'only adds queens to pieces' do
      piece_assigner.assign_queen(player, game, pieces)
      expect(pieces.all? { |piece| piece.instance_of?(Queen) }).to be(true)
    end

    context 'when the player is white' do
      let(:expected_location) { [7, 3] }

      before do
        allow(player).to receive(:color).and_return('white')
      end

      it 'assign the expected location to the queen' do
        piece_assigner.assign_queen(player, game, pieces)
        expect(pieces.first.location).to eq(expected_location)
      end
    end

    context 'when the player is black' do
      let(:expected_location) { [0, 3] }

      before do
        allow(player).to receive(:color).and_return('black')
      end

      it 'assign the expected location to the queen' do
        piece_assigner.assign_queen(player, game, pieces)
        expect(pieces.first.location).to eq(expected_location)
      end
    end
  end

  describe '#assign_king' do
    it 'adds one item to the provided pieces array' do
      expect { piece_assigner.assign_king(player, game, pieces) }.to change { pieces.size }.by(1)
    end

    it 'only adds kings to pieces' do
      piece_assigner.assign_king(player, game, pieces)
      expect(pieces.all? { |piece| piece.instance_of?(King) }).to be(true)
    end

    context 'when the player is white' do
      let(:expected_location) { [7, 4] }

      before do
        allow(player).to receive(:color).and_return('white')
      end

      it 'assign the expected location to the king' do
        piece_assigner.assign_king(player, game, pieces)
        expect(pieces.first.location).to eq(expected_location)
      end
    end

    context 'when the player is black' do
      let(:expected_location) { [0, 4] }

      before do
        allow(player).to receive(:color).and_return('black')
      end

      it 'assign the expected location to the king' do
        piece_assigner.assign_king(player, game, pieces)
        expect(pieces.first.location).to eq(expected_location)
      end
    end
  end

  describe '#assign_pawns' do
    it 'adds two items to the provided pieces array' do
      expect { piece_assigner.assign_pawns(player, game, pieces) }.to change { pieces.size }.by(8)
    end

    it 'only adds pawns to pieces' do
      piece_assigner.assign_pawns(player, game, pieces)
      expect(pieces.all? { |piece| piece.instance_of?(Pawn) }).to be(true)
    end

    context 'when the player is white' do
      let(:expected_first_location) { [6, 0] }
      let(:expected_second_location) { [6, 1] }
      let(:expected_third_location) { [6, 2] }
      let(:expected_fourth_location) { [6, 3] }
      let(:expected_fifth_location) { [6, 4] }
      let(:expected_sixth_location) { [6, 5] }
      let(:expected_seventh_location) { [6, 6] }
      let(:expected_eighth_location) { [6, 7] }

      before do
        allow(player).to receive(:color).and_return('white')
      end

      it 'assign the expected first location to the first pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[0].location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[1].location).to eq(expected_second_location)
      end

      it 'assign the expected third location to the third pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[2].location).to eq(expected_third_location)
      end

      it 'assign the expected fourth location to the fourth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[3].location).to eq(expected_fourth_location)
      end

      it 'assign the expected fifth location to the fifth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[4].location).to eq(expected_fifth_location)
      end

      it 'assign the expected sixth location to the sixth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[5].location).to eq(expected_sixth_location)
      end

      it 'assign the expected seventh location to the seventh pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[6].location).to eq(expected_seventh_location)
      end

      it 'assign the expected eighth location to the eighth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[7].location).to eq(expected_eighth_location)
      end
    end

    context 'when the player is black' do
      let(:expected_first_location) { [1, 0] }
      let(:expected_second_location) { [1, 1] }
      let(:expected_third_location) { [1, 2] }
      let(:expected_fourth_location) { [1, 3] }
      let(:expected_fifth_location) { [1, 4] }
      let(:expected_sixth_location) { [1, 5] }
      let(:expected_seventh_location) { [1, 6] }
      let(:expected_eighth_location) { [1, 7] }

      before do
        allow(player).to receive(:color).and_return('black')
      end

      it 'assign the expected first location to the first pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[0].location).to eq(expected_first_location)
      end

      it 'assign the expected second location to the second pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[1].location).to eq(expected_second_location)
      end

      it 'assign the expected third location to the third pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[2].location).to eq(expected_third_location)
      end

      it 'assign the expected fourth location to the fourth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[3].location).to eq(expected_fourth_location)
      end

      it 'assign the expected fifth location to the fifth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[4].location).to eq(expected_fifth_location)
      end

      it 'assign the expected sixth location to the sixth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[5].location).to eq(expected_sixth_location)
      end

      it 'assign the expected seventh location to the seventh pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[6].location).to eq(expected_seventh_location)
      end

      it 'assign the expected eighth location to the eighth pawn' do
        piece_assigner.assign_pawns(player, game, pieces)
        expect(pieces[7].location).to eq(expected_eighth_location)
      end
    end
  end
end
