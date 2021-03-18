# frozen_string_literal: true

require_relative '../lib/pieces/pawn'

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

  describe '#possible_moves' do
    let(:moves) { [] }
    let(:row) { 1 }
    let(:column) { 1 }

    it 'calls #add_single_move_if_applicable with a moves array, row, and column' do
      expect(pawn).to receive(:add_single_move_if_applicable).with(moves, row, column)
      pawn.possible_moves(row, column)
    end

    it 'calls #add_double_move_if_applicable with a moves array, row, and column' do
      allow(pawn).to receive(:add_single_move_if_applicable).and_return(moves)
      expect(pawn).to receive(:add_double_move_if_applicable).with(moves, row, column)
      pawn.possible_moves(row, column)
    end

    it 'calls #add_attack_moves_if_applicable with a moves array, row, and column' do
      allow(pawn).to receive(:add_single_move_if_applicable).and_return(moves)
      allow(pawn).to receive(:add_double_move_if_applicable).and_return(moves)
      expect(pawn).to receive(:add_attack_moves_if_applicable).with(moves, row, column)
      pawn.possible_moves(row, column)
    end

    it 'calls #add_en_passant_moves_if_applicable with a moves array, row, and column' do
      allow(pawn).to receive(:add_single_move_if_applicable).and_return(moves)
      allow(pawn).to receive(:add_double_move_if_applicable).and_return(moves)
      allow(pawn).to receive(:add_attack_moves_if_applicable).and_return(moves)
      expect(pawn).to receive(:add_en_passant_moves_if_applicable).with(moves, row, column)
      pawn.possible_moves(row, column)
    end

    it 'calls #clean_moves with the moves array' do
      allow(pawn).to receive(:add_single_move_if_applicable).and_return(moves)
      allow(pawn).to receive(:add_double_move_if_applicable).and_return(moves)
      allow(pawn).to receive(:add_attack_moves_if_applicable).and_return(moves)
      allow(pawn).to receive(:add_en_passant_moves_if_applicable).and_return(moves)
      expect(pawn).to receive(:clean_moves).with(moves)
      pawn.possible_moves(row, column)
    end
  end

  describe '#add_single_move_if_applicable' do
    let(:moves) { [] }
    let(:row) { 1 }
    let(:column) { 1 }

    context 'when there is a piece at the single move location' do
      it 'returns the moves array unchanged' do
        allow(game).to receive(:piece_at).and_return(true)
        expect { pawn.add_single_move_if_applicable(moves, row, column) }.not_to(change { moves })
      end
    end

    context 'when there is not a piece at the single move location' do
      it 'returns the moves array with the single move added' do
        allow(game).to receive(:piece_at).and_return(false)
        allow(pawn).to receive(:direction).and_return(1)

        pawn.add_single_move_if_applicable(moves, row, column)
        expect(moves).to eq([[2, 1]])
      end
    end
  end

  describe '#add_double_move_if_applicable' do
    let(:moves) { [] }
    let(:row) { 1 }
    let(:column) { 1 }

    context 'when there is a piece directly in front of the pawn' do
      it 'returns the moves array unchanged' do
        allow(game).to receive(:piece_at).and_return(true)
        expect { pawn.add_double_move_if_applicable(moves, row, column) }.not_to(change { moves })
      end
    end

    context 'when there is a piece two tiles in front of the pawn' do
      it 'returns the moves array unchanged' do
        allow(game).to receive(:piece_at).and_return(false, true)
        expect { pawn.add_double_move_if_applicable(moves, row, column) }.not_to(change { moves })
      end
    end

    context 'when there is no piece in the tile directly or two tiles in front in front of the pawn' do
      it 'returns the moves array with the double move added' do
        allow(game).to receive(:piece_at).and_return(false)
        allow(pawn).to receive(:direction).and_return(1)

        pawn.add_double_move_if_applicable(moves, row, column)
        expect(moves).to eq([[3, 1]])
      end
    end
  end

  describe '#add_attack_moves_if_applicable' do
    let(:moves) { [] }
    let(:row) { 1 }
    let(:column) { 1 }

    before do
      allow(pawn).to receive(:diagonal_right).and_return([2, 2])
      allow(pawn).to receive(:diagonal_left).and_return([2, 0])
    end

    context 'when there are no pieces that the pawn can attack' do
     it 'returns the moves array unchanged' do
       allow(pawn).to receive(:can_attack?).and_return(false)
       expect { pawn.add_attack_moves_if_applicable(moves, row, column) }.not_to(change { moves })
     end
    end 

    context 'when there is a piece that the pawn can attack to the right' do
      it 'returns the moves array with that right diagonal move added' do
        allow(pawn).to receive(:can_attack?).and_return(true, false)

        pawn.add_attack_moves_if_applicable(moves, row, column)
        expect(moves).to eq([[2, 2]])
      end
    end

    context 'when there is a piece that the pawn can attack to the left' do
      it 'returns the moves array with that left diagonal move added' do
        allow(pawn).to receive(:can_attack?).and_return(false, true)

        pawn.add_attack_moves_if_applicable(moves, row, column)
        expect(moves).to eq([[2, 0]])
      end
    end

    context 'when there are pieces to the left and right that the pawn can attack' do
      it 'returns the moves array with both right and left diagonal moves added' do
        allow(pawn).to receive(:can_attack?).and_return(true)

        pawn.add_attack_moves_if_applicable(moves, row, column)
        expect(moves).to eq([[2, 2], [2, 0]])
      end
    end
  end

  describe '#diagonal_right' do
    let(:row) { 1 }
    let(:column) { 1 }

    context 'when direction is positive' do
      it 'returns the move to board north diagonal right of the pawn' do
        allow(pawn).to receive(:direction).and_return(1)
        expect(pawn.diagonal_right(row, column)).to eq([2, 2])
      end
    end

    context 'when direction is negative' do
      it 'returns the move to board south diagonal right of the pawn' do
        allow(pawn).to receive(:direction).and_return(-1)
        expect(pawn.diagonal_right(row, column)).to eq([0, 2])
      end
    end
  end

  describe '#diagonal_left' do
    let(:row) { 1 }
    let(:column) { 1 }

    context 'when direction is positive' do
      it 'returns the move to board north diagonal left of the pawn' do
        allow(pawn).to receive(:direction).and_return(1)
        expect(pawn.diagonal_left(row, column)).to eq([2, 0])
      end
    end

    context 'when direction is negative' do
      it 'returns the move to board south diagonal left of the pawn' do
        allow(pawn).to receive(:direction).and_return(-1)
        expect(pawn.diagonal_left(row, column)).to eq([0, 0])
      end
    end
  end

  describe '#can_attack?' do
    let(:location) { [1, 1] }

    it 'calls #enemy_at? on the game with the player and location' do
      expect(game).to receive(:enemy_at?).with(player, location)
      pawn.can_attack?(location)
    end

    it 'returns the output of the #enemy_at? call to game' do
      allow(game).to receive(:enemy_at?).and_return('foo')
      expect(pawn.can_attack?(location)).to eq('foo')
    end
  end

  describe '#orthogonal_right_piece' do
    let(:row) { 1 }
    let(:column) { 1 }
    let(:right_column) { 2 }

    it 'calls Game.piece_at for the piece to the board right of the pawn' do
      expect(game).to receive(:piece_at).with([row, right_column])
      pawn.orthogonal_right_piece(row, column)
    end

    it 'returns the output of the #piece_at call' do
      allow(game).to receive(:piece_at).and_return('foo')
      expect(pawn.orthogonal_right_piece(row, column)).to eq('foo')
    end
  end

  describe '#orthogonal_left_piece' do
    let(:row) { 1 }
    let(:column) { 1 }
    let(:left_column) { 0 }

    it 'calls Game.piece_at for the piece to the board left of the pawn' do
      expect(game).to receive(:piece_at).with([row, left_column])
      pawn.orthogonal_left_piece(row, column)
    end

    it 'returns the output of the #piece_at call' do
      allow(game).to receive(:piece_at).and_return('foo')
      expect(pawn.orthogonal_left_piece(row, column)).to eq('foo')
    end
  end

  describe '#can_en_passant?' do
    let(:piece) { double('piece') }

    before do
      allow(piece).to receive(:location)
    end

    context 'when the piece is not a pawn' do
      it 'returns false' do
        allow(piece).to receive(:respond_to?).and_return(false)
        allow(game).to receive(:enemy_at?).and_return(true)
        allow(piece).to receive(:vulnerable_to_en_passant).and_return(true)
        expect(pawn.can_en_passant?(piece)).to be(false)
      end
    end

    context 'when the piece is not an enemy' do
      it 'returns false' do
        allow(piece).to receive(:respond_to?).and_return(true)
        allow(game).to receive(:enemy_at?).and_return(false)
        allow(piece).to receive(:vulnerable_to_en_passant).and_return(true)
        expect(pawn.can_en_passant?(piece)).to be(false)
      end
    end

    context 'when the piece is not vulnerable to en passant' do
      it 'returns false' do
        allow(piece).to receive(:respond_to?).and_return(true)
        allow(game).to receive(:enemy_at?).and_return(true)
        allow(piece).to receive(:vulnerable_to_en_passant).and_return(false)
        expect(pawn.can_en_passant?(piece)).to be(false)
      end
    end

    context 'when the piece can be en passanted' do
      it 'returns true' do
        allow(piece).to receive(:respond_to?).and_return(true)
        allow(game).to receive(:enemy_at?).and_return(true)
        allow(piece).to receive(:vulnerable_to_en_passant).and_return(true)
        expect(pawn.can_en_passant?(piece)).to be(true)
      end
    end
  end

  describe '#can_attack_location' do
    let(:location) { [2, 2] }

    it 'calls #valid_pawn_move? with the provided location' do
      expect(pawn).to receive(:valid_pawn_move?).with(location)
      pawn.can_attack_location?(location)
    end

    context 'when moving to the location is invalid' do
      it 'returns false' do
        allow(pawn).to receive(:valid_pawn_move?).and_return(false)
        expect(pawn.can_attack_location?(location)).to be(false)
      end
    end

    context 'when moving to the location is valid' do
      it 'returns true' do
        allow(pawn).to receive(:valid_pawn_move?).and_return(true)
        expect(pawn.can_attack_location?(location)).to be(true)
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

  describe `#valid_pawn_move?`do
    let(:location) { [2, 1] }
    
    context 'when the pawn move is legal and reachable' do
      it 'returns true' do
        allow(pawn).to receive(:legal_pawn_move?).and_return(true)
        allow(pawn).to receive(:reachable?).and_return(true)
        expect(pawn.valid_pawn_move?(location)).to be(true)
      end
    end

    context 'when the pawn move is legal but not reachable' do
      it 'returns false' do
        allow(pawn).to receive(:legal_pawn_move?).and_return(true)
        allow(pawn).to receive(:reachable?).and_return(false)
        expect(pawn.valid_pawn_move?(location)).to be(false)
      end
    end

    context 'when the pawn move is reachable but not legal' do
      it 'returns false' do
        allow(pawn).to receive(:legal_pawn_move?).and_return(false)
        allow(pawn).to receive(:reachable?).and_return(true)
        expect(pawn.valid_pawn_move?(location)).to be(false)
      end
    end

    context 'when the pawn move is not legal or reachable' do
      it 'returns false' do
        allow(pawn).to receive(:legal_pawn_move?).and_return(false)
        allow(pawn).to receive(:reachable?).and_return(false)
        expect(pawn.valid_pawn_move?(location)).to be(false)
      end
    end
  end
 
  describe '#legal_pawn_move?' do
    let(:move) { [2, 3] }

    context 'when the move is included in the current possible attack moves' do
      let(:possible_moves) { [[0, 2], [2, 3]] }

      it 'returns true' do
        allow(pawn).to receive(:possible_pawn_attack_moves).and_return(possible_moves)
        expect(pawn.legal_pawn_move?(move)).to be(true)
      end
    end

    context 'when the move is not included in the current possible attack moves' do
      let(:possible_moves) { [[0, 2], [2, 4]] }

      it 'returns false' do
        allow(pawn).to receive(:possible_pawn_attack_moves).and_return(possible_moves)
        expect(pawn.legal_pawn_move?(move)).to be(false)
      end
    end
  end

  describe '#possible_pawn_attack_moves' do
    let(:row) { 1 }
    let(:column) { 1 }

    before do
      allow(pawn).to receive(:clean_moves) { |argument| argument }
    end

    context 'when the pawns direction is positive' do
      let(:left_attack) { [2, 0] }
      let(:right_attack) { [2, 2] }

      it 'adds the board left attack move to the list of potential moves' do
        expect(pawn.possible_pawn_attack_moves(row, column)).to include(left_attack)
      end

      it 'adds the board right attack move to the list of potential moves' do
        expect(pawn.possible_pawn_attack_moves(row, column)).to include(right_attack)
      end

      it 'does not add any other moves to the list of potential moves' do
        expect(pawn.possible_pawn_attack_moves(row, column).size).to eq(2)
      end

      it 'returns the output of calling #clean_moves on the list of potential moves' do
        allow(pawn).to receive(:clean_moves).and_return('foo')
        expect(pawn.possible_pawn_attack_moves(row, column)).to eq('foo')
      end
    end
  end
end
