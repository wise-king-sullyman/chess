# frozen_string_literal: true

require_relative '../lib/pieces/king'

describe King do
  let(:game) { instance_double('game') }
  let(:player) { instance_double('player') }
  let(:board) { double('board') }
  subject(:king) { King.new(game, player, [0, 4]) }

  before do
    allow(king).to receive(:available?).and_return(true)
    allow(king).to receive(:reachable?).and_return(true)
    allow(game).to receive(:in_check_at?).and_return(false)
    allow(game).to receive(:move_checks_self?).and_return(false)
    allow(game).to receive(:board).and_return(board)
    allow(board).to receive(:piece_at)
    allow(player).to receive(:pieces).and_return([])
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
      king.move([0, 3])
      expect(king.instance_variable_get('@location')).to eql([0, 3])
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
    context 'when enemy king is in attack range' do
      it 'returns true' do
        allow(game).to receive(:enemy_king_location).and_return([1, 4])
        expect(king.can_attack_king?).to be true
      end
    end
    context 'when enemy king is not in attack range' do
      it 'returns false' do
        allow(game).to receive(:enemy_king_location).and_return([7, 4])
        expect(king.can_attack_king?).to be false
      end
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

  describe '#can_castle?' do
    let(:rook) { double('rook') }

    before do
      allow(rook).to receive(:moved).and_return(false)
      allow(rook).to receive(:location).and_return([0,7])
      allow(king).to receive(:reachable?).and_return(true)
      allow(game).to receive(:player_in_check?).and_return(false)
    end

    context 'when king has moved' do
      it 'returns false' do
        king.move([0, 4])
        expect(king.can_castle?(rook)).to be false
      end
    end

    context 'when rook has moved' do
      it 'returns false' do
        allow(rook).to receive(:moved).and_return(true)
        expect(king.can_castle?(rook)).to be false
      end
    end

    context 'when piece is between king and rook' do
      it 'returns false' do
        allow(king).to receive(:reachable?).and_return(false)
        expect(king.can_castle?(rook)).to be false
      end
    end

    context 'when king is in check' do
      it 'returns false' do
        allow(game).to receive(:player_in_check?).and_return(true)
        expect(king.can_castle?(rook)).to be false
      end
    end

    context 'when king would move into check' do
      it 'returns false' do
        allow(game).to receive(:move_checks_self?).and_return(false, true)
        expect(king.can_castle?(rook)).to be false
      end
    end

    context 'when castling is permissable' do
      it 'returns true' do
        expect(king.can_castle?(rook)).to be true
      end
    end
  end

  describe '#add_castle_move' do
    let(:rook) { double('rook') }

    before do
      allow(king).to receive(:can_castle?).and_return(true)
      allow(rook).to receive(:location).and_return([0, 7])
    end

    context 'when castling is permissable and rook is board right' do
      let(:moves) { [[0, 5]] }
      it 'returns board right castle added to move array' do
        expect(king.add_castle_move(rook, moves)).to eql([[0, 5], [0, 6]])
      end
    end

    context 'when castling is permissable and rook is board left' do
      let(:moves) { [[0, 4]] }
      it 'returns board right castle added to move array' do
        allow(rook).to receive(:location).and_return([0, 0])
        expect(king.add_castle_move(rook, moves)).to eql([[0, 4], [0, 2]])
      end
    end

    context 'when castling is not permissable' do
      let(:moves) { [[0, 4]] }
      it 'returns the move array' do
        allow(king).to receive(:can_castle?).and_return(false)
        expect(king.add_castle_move(rook, moves)).to eql([[0, 4]])
      end
    end
  end

  describe '#move_castling_rook' do
    let(:rook) { double('rook') }

    before do
      allow(game).to receive(:board).and_return(board)
      allow(board).to receive(:piece_at)
      allow(rook).to receive(:move)
    end

    context 'when the white king is moving board right' do
      let(:king_to_location) { [0, 6] }
      let(:rook_from_location) { [0, 7] }
      let(:rook_to_location) { [0, 5] }

      before do
        allow(rook).to receive(:location).and_return(rook_from_location)
      end

      it 'requests the correct rook' do
        expect(board).to receive(:piece_at).with(rook_from_location).and_return(rook)
        king.move_castling_rook(king_to_location)
      end

      it 'calls #move with the correct location on the rook' do
        allow(board).to receive(:piece_at).and_return(rook)
        expect(rook).to receive(:move).with(rook_to_location)
        king.move_castling_rook(king_to_location)
      end
    end

    context 'when the white king is moving board left' do
      let(:king_to_location) { [0, 2] }
      let(:rook_from_location) { [0, 0] }
      let(:rook_to_location) { [0, 3] }

      before do
        allow(rook).to receive(:location).and_return(rook_from_location)
      end

      it 'requests the correct rook' do
        expect(board).to receive(:piece_at).with(rook_from_location).and_return(rook)
        king.move_castling_rook(king_to_location)
      end

      it 'calls #move with the correct location on the rook' do
        allow(board).to receive(:piece_at).and_return(rook)
        expect(rook).to receive(:move).with(rook_to_location)
        king.move_castling_rook(king_to_location)
      end
    end

    context 'when the black king is moving board right' do
      let(:king_to_location) { [7, 6] }
      let(:rook_from_location) { [7, 7] }
      let(:rook_to_location) { [7, 5] }

      before do
        allow(rook).to receive(:location).and_return(rook_from_location)
      end

      it 'requests the correct rook' do
        expect(board).to receive(:piece_at).with(rook_from_location).and_return(rook)
        king.move_castling_rook(king_to_location)
      end

      it 'calls #move with the correct location on the rook' do
        allow(board).to receive(:piece_at).and_return(rook)
        expect(rook).to receive(:move).with(rook_to_location)
        king.move_castling_rook(king_to_location)
      end
    end

    context 'when the black king is moving board left' do
      let(:king_to_location) { [7, 2] }
      let(:rook_from_location) { [7, 0] }
      let(:rook_to_location) { [7, 3] }

      before do
        allow(rook).to receive(:location).and_return(rook_from_location)
      end

      it 'requests the correct rook' do
        expect(board).to receive(:piece_at).with(rook_from_location).and_return(rook)
        king.move_castling_rook(king_to_location)
      end

      it 'calls #move with the correct location on the rook' do
        allow(board).to receive(:piece_at).and_return(rook)
        expect(rook).to receive(:move).with(rook_to_location)
        king.move_castling_rook(king_to_location)
      end
    end
  end

  describe '#uncleaned_moves' do
    let(:modifiers) { [[1, 1], [1, 0], [1, -1], [0, 1], [0, 0], [0, -1], [-1, 1], [-1, 0], [-1, -1]] }
    let(:row) { 1 }
    let(:column) { 5 }

    it 'calls #apply_move_modifiers with the modifiers, row, and column' do
      expect(king).to receive(:apply_move_modifiers).with(modifiers, row, column)
      king.uncleaned_moves(row, column)
    end

    it 'returns the output from #apply_move_modifiers' do
      allow(king).to receive(:apply_move_modifiers).and_return('foo')
      expect(king.uncleaned_moves(row, column)).to eq('foo')
    end
  end

  describe '#possible_moves' do
    let(:row) { 0 }
    let(:column) { 4 }
    let(:piece) { double('piece') }
    let(:pieces) { [piece, piece, piece] }

    before do
      allow(king).to receive(:uncleaned_moves)
      allow(king).to receive(:clean_moves)
      allow(player).to receive(:pieces).and_return(pieces)
    end

    it 'calls methods needed to determine possible moves and returns their result' do
      allow(king).to receive(:uncleaned_moves)
      allow(king).to receive(:clean_moves).and_return('foo')
      expect(king.possible_moves(row, column)).to eq('foo')
    end

    context 'when one of the players pieces is a rook' do
      it 'calls #add_castle_moves once' do
        allow(piece).to receive(:class).and_return(Pawn, Pawn, Rook)
        expect(king).to receive(:add_castle_move).once
        king.possible_moves(row, column)
      end
    end

    context 'when two of the players pieces are rooks' do
      it 'calls #add_castle_moves twice' do
        allow(piece).to receive(:class).and_return(Pawn, Rook)
        expect(king).to receive(:add_castle_move).twice
        king.possible_moves(row, column)
      end
    end

    context 'when none of the players pieces are rooks' do
      it 'does not call #add_castle_moves' do
        allow(piece).to receive(:class).and_return(Pawn)
        expect(king).not_to receive(:add_castle_move)
        king.possible_moves(row, column)
      end
    end
  end
end
