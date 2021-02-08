# frozen_string_literal: true

require_relative '../lib/ai'

describe AI do
  let(:game) { instance_double(Game) }
  let(:piece) { instance_double(Piece) }
  let(:location) { [4, 4] }
  subject(:ai_test) { described_class.new('Hal', 'white', game) }

  describe '#move' do
    before do
      allow(ai_test).to receive(:piece_choice).and_return(piece)
      allow(ai_test).to receive(:location_choice).and_return(location)
      allow(ai_test).to receive(:piece_is_mine?).and_return(true)
      allow(ai_test).to receive(:valid_move?).and_return(true)
      allow(game).to receive(:board)
      allow(game).to receive(:move_piece)
      allow(ai_test).to receive(:promote)
      allow(piece).to receive(:eligible_for_promotion?)
    end

    it 'calls #reset_en_passant_vulnerabilities' do
      expect(ai_test).to receive(:reset_en_passant_vulnerabilities)
      ai_test.move
    end

    it 'calls Game #move_piece with the piece and location' do
      expect(game).to receive(:move_piece).with(piece, location)
      ai_test.move
    end

    context 'when a valid piece and move are given' do
      it 'calls #piece_choice once' do
        expect(ai_test).to receive(:piece_choice).once
        ai_test.move
      end

      it 'calls #location_choice once' do
        expect(ai_test).to receive(:location_choice).once
        ai_test.move
      end
    end

    context 'when an invalid piece and invalid move are given at first' do
      it 'calls #piece_choice twice' do
        allow(ai_test).to receive(:piece_is_mine?).and_return(false, true)
        expect(ai_test).to receive(:piece_choice).twice
        ai_test.move
      end

      it 'calls #location_choice twice' do
        allow(ai_test).to receive(:valid_move?).and_return(false, true)
        expect(ai_test).to receive(:location_choice).twice
        ai_test.move
      end
    end

    context 'when a valid piece is given but an invalid move is given at first' do
      it 'calls #location_choice twice' do
        allow(ai_test).to receive(:valid_move?).and_return(false, true)
        expect(ai_test).to receive(:location_choice).twice
        ai_test.move
      end
    end

    context 'when an invalid piece is given but a valid move is given at first' do
      it 'calls #piece_choice twice' do
        allow(ai_test).to receive(:piece_is_mine?).and_return(false, true)
        expect(ai_test).to receive(:piece_choice).twice
        ai_test.move
      end
    end

    context 'when a piece is eligible for promotion' do
      it 'calls promote with that piece' do
        allow(piece).to receive(:eligible_for_promotion?).and_return(true)
        expect(ai_test).to receive(:promote).with(piece)
        ai_test.move
      end
    end

    context 'when a piece is not eligible for promotion' do
      it 'calls promote with that piece' do
        allow(piece).to receive(:eligible_for_promotion?).and_return(false)
        expect(ai_test).not_to receive(:promote)
        ai_test.move
      end
    end
  end

  describe '#random_tile' do
    before do
      allow(ai_test).to receive(:random_row_selection).and_return('2')
      allow(ai_test).to receive(:random_column_selection).and_return('b')
    end

    it 'calls #update_last_move with its randomly selection location' do
      expect(ai_test).to receive(:update_last_move).with('b2')
      ai_test.random_tile
    end

    it 'returns the translated tile choice' do
      expect(ai_test.random_tile).to eq([6, 1])
    end
  end

  describe '#promote' do
    before do
      allow(ai_test).to receive(:add_promotion_piece)
    end

    it 'calls #add_promotion_piece with the provided piece and #rand' do
      expect(ai_test).to receive(:add_promotion_piece).with(piece, 3)
      ai_test.promote(piece, 3)
    end

    let(:my_pieces) { [] }
    it 'calls #delete with piece on my_pieces' do
      expect(my_pieces).to receive(:delete).with(piece)
      ai_test.promote(piece, 3, my_pieces)
    end
  end

  describe '#piece_choice' do
    let(:tile) { [1, 2] }

    before do
      allow(ai_test).to receive(:random_tile).and_return(tile)
      allow(ai_test).to receive(:piece_at_location)
    end

    it 'calls #random_tile' do
      expect(ai_test).to receive(:random_tile)
      ai_test.piece_choice
    end

    it 'calls #piece_at_location with the first and second outputs from random_tile' do
      expect(ai_test).to receive(:piece_at_location).with(tile)
      ai_test.piece_choice
    end
  end

  describe '#location_choice' do
    let(:tile) { [1, 2] }

    before do
      allow(ai_test).to receive(:random_tile).and_return(tile)
      allow(ai_test).to receive(:piece_at_location)
    end

    it 'calls #random_tile' do
      expect(ai_test).to receive(:random_tile)
      ai_test.location_choice
    end

    it 'returns the output of #random_tile' do
      expect(ai_test.location_choice).to eq(tile)
    end
  end

  describe '#random_row_selection' do
    it 'calls #rand with 1..8' do
      expect(ai_test).to receive(:rand).with(1..8)
      ai_test.random_row_selection
    end

    it 'returns the random number as a string' do
      allow(ai_test).to receive(:rand).and_return(3)
      expect(ai_test.random_row_selection).to eq('3')
    end
  end

  describe '#random_column_selection' do
    context 'when supplied with a one character range' do
      let(:range) { ('a'...'b') }
      it 'returns the character' do
        expect(ai_test.random_column_selection(range)).to eq('a')
      end
    end

    context 'when supplied with a limited character range' do
      let(:range) { ('c'..'e') }
      it 'returns the character' do
        random_column = ai_test.random_column_selection(range)
        expect(random_column).to eq('c').or eq('d').or eq('e')
      end
    end

    context 'when given no arguments' do
      let(:range) { ('a'..'h') }
      it 'returns a character between a and h inclusive' do
        expect(range).to include(ai_test.random_column_selection)
      end
    end

    context 'when given the same seed' do
      it 'always returns the same character' do
        srand(1)
        # 'f' is the predetermined output after calling srand(1)
        expect(ai_test.random_column_selection).to eq('f')
      end
    end

    context 'when the seed is changed' do
      it 'returns a different character' do
        srand(1)
        character1 = ai_test.random_column_selection
        srand(2)
        character2 = ai_test.random_column_selection
        expect(character1).not_to eq(character2)
      end
    end
  end
end
