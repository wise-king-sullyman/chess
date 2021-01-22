# frozen_string_literal: true

require_relative '../lib/player'

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

  describe '#translate_input' do
    it 'translates the input into proper [row, column] notation' do
      expect(player.translate_input('b3')).to eq([5, 1])
    end
  end

  describe '#update_last_move' do
    context 'when last_move is "full" already' do
      let(:move) { 'a1' }
      before do
        player.instance_variable_set('@last_move', %w[b3 b4])
        player.update_last_move(move)
      end

      it 'removes the first logged move' do
        expect(player.last_move).not_to include('b3')
      end

      it 'removes the second logged move' do
        expect(player.last_move).not_to include('b4')
      end

      it 'adds the new move' do
        expect(player.last_move).to include('a1')
      end
    end

    context 'when last_move is not "full" yet' do
      let(:move) { 'a3' }
      before do
        player.instance_variable_set('@last_move', %w[a1])
        player.update_last_move(move)
      end

      it 'keeps the first move' do
        expect(player.last_move).to include('a1')
      end

      it 'adds the second move' do
        expect(player.last_move).to include('a3')
      end

      it 'has no other moves' do
        expect(player.last_move.size).to eq(2)
      end
    end
  end

  describe '#validate_input' do
    context 'when valid input is given initially' do
      let(:input) { 'a1' }
      it 'returns the input' do
        expect(player.validate_input(input)).to eq(input)
      end

      it 'does not call #gets' do
        expect(player).not_to receive(:gets)
        player.validate_input(input)
      end
    end

    context 'when no input is given' do
      let(:input) { '' }
      before do
        allow(player).to receive(:gets).and_return(input, input, 'a1')
      end

      it 'returns the input when valid' do
        expect(player.validate_input(input)).to eq('a1')
      end

      it 'calls #gets until valid input is given' do
        expect(player).to receive(:gets).exactly(3).times
        player.validate_input(input)
      end
    end

    context 'when out of order input is given' do
      let(:input) { '1a' }
      before do
        allow(player).to receive(:gets).and_return(input, input, 'a1')
      end

      it 'returns the input when valid' do
        expect(player.validate_input(input)).to eq('a1')
      end

      it 'calls #gets until valid input is given' do
        expect(player).to receive(:gets).exactly(3).times
        player.validate_input(input)
      end
    end

    context 'when out of range input is given' do
      let(:input) { 'i1' }
      before do
        allow(player).to receive(:gets).and_return('a0', 'a9', 'a1')
      end

      it 'returns the input when valid' do
        expect(player.validate_input(input)).to eq('a1')
      end

      it 'calls #gets until valid input is given' do
        expect(player).to receive(:gets).exactly(3).times
        player.validate_input(input)
      end
    end

    context 'when other invalid input is given' do
      let(:input) { '#1' }
      before do
        allow(player).to receive(:gets).and_return('1$', 'foo', 'a1')
      end

      it 'returns the input when valid' do
        expect(player.validate_input(input)).to eq('a1')
      end

      it 'calls #gets until valid input is given' do
        expect(player).to receive(:gets).exactly(3).times
        player.validate_input(input)
      end
    end
  end

  describe '#piece_is_mine?' do
    context 'when nil argument is given' do
      it 'returns false' do
        expect(player.piece_is_mine?(nil)).to be(false)
      end
    end

    context 'when non owned piece argument is given' do
      it 'returns false' do
        allow(piece).to receive(:player).and_return(double('player'))
        expect(player.piece_is_mine?(piece)).to be(false)
      end
    end

    context 'when owned piece argument is given' do
      it 'returns true' do
        allow(piece).to receive(:player).and_return(player)
        expect(player.piece_is_mine?(piece)).to be(true)
      end
    end
  end

  describe '#validate_promotion_choice' do
    context 'when valid input is given initially' do
      let(:promotion_choice) { '1' }
      it 'returns the input as an integer' do
        expect(player.validate_promotion_choice(promotion_choice)).to eq(1)
      end

      it 'does not call #gets' do
        expect(player).not_to receive(:gets)
        player.validate_promotion_choice(promotion_choice)
      end
    end

    context 'when no input is given' do
      let(:promotion_choice) { '' }
      before do
        allow(player).to receive(:gets).and_return(promotion_choice, promotion_choice, '1')
      end

      it 'returns the input as an integer when valid' do
        expect(player.validate_promotion_choice(promotion_choice)).to eq(1)
      end

      it 'calls #gets until valid input is given' do
        expect(player).to receive(:gets).exactly(3).times
        player.validate_promotion_choice(promotion_choice)
      end
    end

    context 'when other invalid input is given' do
      let(:input) { '#' }
      before do
        allow(player).to receive(:gets).and_return('4', 'foo', '1')
      end

      it 'returns the input as an integer when valid' do
        expect(player.validate_promotion_choice(input)).to eq(1)
      end

      it 'calls #gets until valid input is given' do
        expect(player).to receive(:gets).exactly(3).times
        player.validate_promotion_choice(input)
      end
    end
  end

  describe '#add_promotion_piece' do
    before do
      player.instance_variable_set('@pieces', [])
    end

    context 'when queen selected' do
      it 'adds a queen to player.pieces' do
        player.add_promotion_piece(piece, 0)
        expect(pieces.first.class).to be Queen
      end

      it 'gives the piece the same location as the piece it is replacing' do
        player.add_promotion_piece(piece, 0)
        expect(pieces.first.location).to eq([1, 1])
      end
    end

    context 'when rook selected' do
      it 'adds a rook to player.pieces' do
        player.add_promotion_piece(piece, 1)
        expect(pieces.first.class).to be Rook
      end

      it 'gives the piece the same location as the piece it is replacing' do
        player.add_promotion_piece(piece, 1)
        expect(pieces.first.location).to eq([1, 1])
      end
    end

    context 'when bishop selected' do
      it 'adds a bishop to player.pieces' do
        player.add_promotion_piece(piece, 2)
        expect(pieces.first.class).to be Bishop
      end

      it 'gives the piece the same location as the piece it is replacing' do
        player.add_promotion_piece(piece, 2)
        expect(pieces.first.location).to eq([1, 1])
      end
    end

    context 'when knight selected' do
      it 'adds a knight to player.pieces' do
        player.add_promotion_piece(piece, 3)
        expect(pieces.first.class).to be Knight
      end

      it 'gives the piece the same location as the piece it is replacing' do
        player.add_promotion_piece(piece, 3)
        expect(pieces.first.location).to eq([1, 1])
      end
    end
  end

  describe '#promote' do
    before do
      allow(player).to receive(:gets).and_return('foo')
      allow(player).to receive(:validate_promotion_choice).and_return('foo')
    end

    it 'calls #add_promotion_piece with the piece and result from #validate_promotion_choice' do
      expect(player).to receive(:add_promotion_piece).with(piece, 'foo')
      player.promote(piece)
    end

    it 'calls delete on the players pieces with the given piece' do
      expect(pieces).to receive(:delete).with(piece)
      player.promote(piece)
    end
  end

  describe '#piece_choice' do
    before do
      allow(player).to receive(:player_input).and_return([0, 1])
      allow(player).to receive(:piece_at_location).and_return(piece)
    end

    it 'calls #piece_at_location with the translated player input' do
      expect(player).to receive(:piece_at_location).with([0, 1])
      player.piece_choice
    end

    it 'returns the piece at the given location' do
      expect(player.piece_choice).to eq(piece)
      player.piece_choice
    end
  end

  describe '#location_choice' do
    it 'returns an array with the translated player input' do
      allow(player).to receive(:player_input).and_return([2, 1])
      expect(player.location_choice).to eq([2, 1])
    end
  end

  describe '#player_input' do
    let(:unvalidated_input) { 'foo' }
    let(:validated_input) { 'a1' }

    before do
      allow(player).to receive(:gets).and_return(unvalidated_input)
      allow(player).to receive(:validate_input).and_return(validated_input)
      allow(player).to receive(:update_last_move)
      allow(player).to receive(:translate_input).and_return('bar')
    end

    it 'calls #validate_input with the given input' do
      expect(player).to receive(:validate_input).with(unvalidated_input)
      player.player_input
    end

    it 'calls #update_last_move with the validated input' do
      expect(player).to receive(:update_last_move).with(validated_input)
      player.player_input
    end

    it 'calls #translate_input with the validated input' do
      expect(player).to receive(:translate_input).with(validated_input)
      player.player_input
    end

    it 'returns the output from translate_input' do
      expect(player.player_input).to eq('bar')
    end
  end
end
