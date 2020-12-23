# frozen_string_literal: true

require './lib/player'

describe Player do
  let(:game) { double('game') }
  subject(:player) { Player.new('player 1', 'white', game) }
  let(:piece) { double('piece') }
  let(:pieces) { player.instance_variable_get('@pieces') }
  let(:location) { [] }
  let(:board) { double('board') }

  before do
    allow($stdout).to receive(:write)
    allow(game).to receive(:piece_at).and_return(piece)
    allow(piece).to receive(:player).and_return(player)
    allow(piece).to receive(:location).and_return([1, 1])
    allow(piece).to receive(:eligible_for_promotion?).and_return(false)
    allow(player).to receive(:gets).and_return('a4')
    allow(game).to receive(:move_piece)
    allow(game).to receive(:board).and_return(board)
    allow(board).to receive(:piece_at)
  end

  describe '#move' do
    before do
      allow(piece).to receive(:legal_move?).and_return(true)
    end
    context 'when a valid move is given to an owned piece' do
      before do
        allow(player).to receive(:valid_move?).and_return(true)
        allow(player).to receive(:piece_is_mine?).and_return(true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid_move?).once
        player.move
      end

      it 'calls game.move_piece' do
        expect(game).to receive(:move_piece)
        player.move
      end
    end

    context 'when a valid move is given to an unowned piece' do
      before do
        allow(player).to receive(:valid_move?).and_return(true)
        allow(player).to receive(:piece_is_mine?).and_return(false, true)
      end

      it 'calls #piece_is_mine? until a valid move is given' do
        expect(player).to receive(:piece_is_mine?).twice
        player.move
      end

      it 'calls game.move_piece once passing conditions are met' do
        expect(game).to receive(:move_piece).once
        player.move
      end
    end

    context 'when an invalid move is given to an owned piece' do
      before do
        allow(player).to receive(:valid_move?).and_return(false, true)
        allow(player).to receive(:piece_is_mine?).and_return(true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid_move?).twice
        player.move
      end

      it 'calls game.move_piece once passing conditions are met' do
        expect(game).to receive(:move_piece).once
        player.move
      end
    end
  end

  describe '#reset_en_passant_vulnerabilities' do
    before do
      player.instance_variable_set('@pieces', [piece, piece, piece, piece])
      allow(piece).to receive(:class).and_return(Pawn, Queen, King, Pawn)
      allow(piece).to receive(:falsify_en_passant_vulnerability)
    end

    it 'calls #falsify_en_passant_vulnerability on all pawns' do
      expect(piece).to receive(:falsify_en_passant_vulnerability).twice
      player.reset_en_passant_vulnerabilities
    end
  end

  describe '#assign_pieces' do
    let(:player2) { Player.new('player 2', 'black', game) }
    let(:player2_pieces) { player2.instance_variable_get('@pieces') }

    context 'when player is white' do
      it 'has a size of 16' do
        expect(pieces.size).to eql(16)
      end

      it 'gives the king the right location' do
        expect(pieces[7].location).to eql([7, 4])
      end
    end

    context 'when player is black' do
      it 'has a size of 16' do
        expect(player2_pieces.size).to eql(16)
      end

      it 'gives the king the right location' do
        expect(player2_pieces[7].location).to eql([0, 4])
      end
    end
  end

  describe '#remove_piece' do
    let(:piece) { pieces[7] }
    let(:lost_pieces) { player.instance_variable_get('@lost_pieces') }
    it 'removes the piece from @pieces' do
      player.remove_piece(piece)
      expect(pieces).not_to include(piece)
    end

    it 'adds the piece to @lost_piece' do
      player.remove_piece(piece)
      expect(lost_pieces).to include(piece)
    end
  end

  describe '#revive_piece' do
    let(:piece) { pieces[7] }
    let(:lost_pieces) { player.instance_variable_get('@lost_pieces') }
    it 'adds the piece to @pieces' do
      player.revive_piece(piece)
      expect(pieces).to include(piece)
    end

    it 'removes the piece from @lost_piece' do
      player.revive_piece(piece)
      expect(lost_pieces).not_to include(piece)
    end
  end

  describe '#king_location' do
    it 'returns the kings location' do
      expect(player.king_location).to eql([7, 4])
    end
  end

  describe '#mated?' do
    let(:king) { double('king') }

    before do
      player.instance_variable_set('@pieces', [piece, piece, piece, piece])
    end

    context 'when mated' do
      it 'returns true' do
        allow(piece).to receive(:can_move?).and_return(false)
        expect(player.mated?).to be true
      end
    end

    context 'when not mated' do
      it 'returns false' do
        allow(piece).to receive(:can_move?).and_return(false, false, true)
        expect(player.mated?).to be false
      end
    end
  end
end
