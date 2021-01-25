# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:board) { double('board') }
  let(:player) { double('player') }
  let(:player2) { double('player') }
  let(:piece) { double('piece') }
  let(:piece2) { double('piece') }
  subject(:game) { Game.new }

  before do
    allow(game).to receive(:puts)
  end

  describe '#move_piece' do
    let(:location) { [1, 1] }

    context 'when the tile is unoccupied' do
      before do
        game.instance_variable_set('@board', board)
        allow(board).to receive(:piece_at).and_return(nil)
        allow(piece).to receive(:move)
      end

      it 'does not call for a piece to be remove' do
        expect(player).not_to receive(:remove_piece)
        game.move_piece(piece, location)
      end

      it 'calls #move on the moving piece with the supplied location' do
        expect(piece).to receive(:move).with(location)
        game.move_piece(piece, location)
      end
    end

    context 'when the tile is occupied' do
      before do
        game.instance_variable_set('@board', board)
        allow(board).to receive(:piece_at).and_return(piece2)
        allow(piece2).to receive(:player).and_return(player2)
        allow(player2).to receive(:remove_piece)
        allow(piece).to receive(:move)
      end

      it 'calls for the piece at the location to be removed' do
        expect(player2).to receive(:remove_piece).with(piece2)
        game.move_piece(piece, location)
      end

      it 'calls #move on the moving piece with the supplied location' do
        expect(piece).to receive(:move).with(location)
        game.move_piece(piece, location)
      end
    end
  end

  describe '#player_input_1_or_2' do
    before do
      allow(game).to receive(:puts)
    end

    context 'when valid input is given' do
      let(:valid_input) { '1' }

      before do
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'calls #gets once' do
        expect(game).to receive(:gets).once
        game.player_input_1_or_2
      end

      it 'returns the valid input as an integer' do
        expect(game.player_input_1_or_2).to eq(valid_input.to_i)
      end
    end

    context 'when a number outside the valid range is given' do
      let(:valid_input) { '1' }

      before do
        allow(game).to receive(:gets).and_return('0', '3', valid_input)
      end

      it 'calls #gets until valid input is given' do
        expect(game).to receive(:gets).exactly(3).times
        game.player_input_1_or_2
      end

      it 'returns the valid input as an integer' do
        expect(game.player_input_1_or_2).to eq(valid_input.to_i)
      end
    end

    context 'when a non number or symbol is given' do
      let(:valid_input) { '1' }

      before do
        allow(game).to receive(:gets).and_return('q', '$', valid_input)
      end

      it 'calls #gets until valid input is given' do
        expect(game).to receive(:gets).exactly(3).times
        game.player_input_1_or_2
      end

      it 'returns the valid input as an integer' do
        expect(game.player_input_1_or_2).to eq(valid_input.to_i)
      end
    end

    context 'when no response is given' do
      let(:valid_input) { '1' }

      before do
        allow(game).to receive(:gets).and_return('', '', valid_input)
      end

      it 'calls #gets until valid input is given' do
        expect(game).to receive(:gets).exactly(3).times
        game.player_input_1_or_2
      end

      it 'returns the valid input as an integer' do
        expect(game.player_input_1_or_2).to eq(valid_input.to_i)
      end
    end
  end

  describe '#add_players' do
    context 'when player input is 1' do
      it 'calls #setup_single_player_game' do
        allow(game).to receive(:player_input_1_or_2).and_return(1)
        expect(game).to receive(:setup_single_player_game)
        game.add_players
      end
    end

    context 'when player input is 2' do
      it 'calls #setup_two_player_game' do
        allow(game).to receive(:player_input_1_or_2).and_return(2)
        expect(game).to receive(:setup_two_player_game)
        game.add_players
      end
    end
  end

  describe '#setup_single_player_game' do
    context 'when player_input_1_or_2 == 1' do
      before do
        allow(game).to receive(:player_input_1_or_2).and_return(1)
      end

      it 'assigns white before black' do
        game.setup_single_player_game
        expect(game.players.first.color).to eq('white')
      end

      it 'assigns Player to white' do
        game.setup_single_player_game
        expect(game.players.first.class).to eq(Player)
      end

      it 'assigns AI to black' do
        game.setup_single_player_game
        expect(game.players.last.class).to eq(AI)
      end

      it 'adds two items to @players' do
        expect { game.setup_single_player_game }.to change { game.players.size }.by(2)
      end
    end

    context 'when player_input_1_or_2 == 2' do
      before do
        allow(game).to receive(:player_input_1_or_2).and_return(2)
      end

      it 'assigns white before black' do
        game.setup_single_player_game
        expect(game.players.first.color).to eq('white')
      end

      it 'assigns AI to white' do
        game.setup_single_player_game
        expect(game.players.first.class).to eq(AI)
      end

      it 'assigns Player to black' do
        game.setup_single_player_game
        expect(game.players.last.class).to eq(Player)
      end

      it 'adds two items to @players' do
        expect { game.setup_single_player_game }.to change { game.players.size }.by(2)
      end
    end
  end

  describe '#setup_two_player_game' do
    it 'assigns white before black' do
      game.setup_two_player_game
      expect(game.players.first.color).to eq('white')
    end

    it 'assigns Player to white' do
      game.setup_two_player_game
      expect(game.players.first.class).to eq(Player)
    end

    it 'assigns Player to black' do
      game.setup_two_player_game
      expect(game.players.last.class).to eq(Player)
    end

    it 'adds two items to @players' do
      expect { game.setup_two_player_game }.to change { game.players.size }.by(2)
    end
  end

  describe '#play' do
    before do
      allow(game).to receive(:ask_to_load_game)
      allow(File).to receive(:exist?)
      allow(game).to receive(:add_players)
      allow(game.players).to receive(:empty?)
      allow(game).to receive(:announce_winner)
      allow(game).to receive(:game_loop)
    end

    it 'calls File.exist? with file_name' do
      allow(game).to receive(:file_name).and_return('foo')
      expect(File).to receive(:exist?).with('foo')
      game.play
    end

    context 'when a file with file_name exists' do
      it 'calls #ask_to_load_game' do
        allow(File).to receive(:exist?).and_return(true)
        expect(game).to receive(:ask_to_load_game)
        game.play
      end
    end

    context 'when a file with file_name does not exist' do
      it 'does not call #ask_to_load_game' do
        allow(File).to receive(:exist?).and_return(false)
        expect(game).not_to receive(:ask_to_load_game)
        game.play
      end
    end

    context 'when game.players is empty' do
      it 'calls #add_players' do
        allow(game.players).to receive(:empty?).and_return(true)
        expect(game).to receive(:add_players)
        game.play
      end
    end

    context 'when game.players is not empty' do
      it 'does not call #add_players' do
        allow(game.players).to receive(:empty?).and_return(false)
        expect(game).not_to receive(:add_players)
        game.play
      end
    end

    it 'calls #game_loop' do
      expect(game).to receive(:game_loop)
      game.play
    end

    it 'calls #announce_winner with the output from #game_loop' do
      allow(game).to receive(:game_loop).and_return('foo')
      expect(game).to receive(:announce_winner).with('foo')
      game.play
    end
  end

  describe '#game_loop' do
    before do
      allow(game).to receive(:ply_setup)
      game.instance_variable_set('@players', [player, player2])
      allow(game).to receive(:clear_terminal)
    end

    it 'calls #ply_setup with player' do
      allow(game).to receive(:player_in_checkmate?).and_return(true)
      expect(game).to receive(:ply_setup).with(player)
      game.game_loop
    end

    it 'calls #player_in_checkmate? with player' do
      allow(game).to receive(:player_in_checkmate?).and_return(true)  
      expect(game).to receive(:player_in_checkmate?).with(player)
      game.game_loop
    end

    context 'when the player is in checkmate' do
      it 'returns #other_player with player' do
        allow(game).to receive(:player_in_checkmate?).and_return(true)
        expect(game).to receive(:other_player).with(player)
        game.game_loop
      end
    end

    it 'calls player #mated?' do
      allow(game).to receive(:player_in_checkmate?).and_return(false)
      allow(player).to receive(:mated?).and_return(true)
      expect(player).to receive(:mated?)
      game.game_loop
    end

    context 'when player is in stalemate' do
      it 'returns nil' do
        allow(game).to receive(:player_in_checkmate?).and_return(false)
        allow(player).to receive(:mated?).and_return(true)
        expect(game.game_loop).to eq(nil)
      end
    end

    context 'when player is not in checkmate or stalemate for three turns' do
      it 'calls player #move three times' do
        allow(game).to receive(:player_in_checkmate?).and_return(false)
        allow(player).to receive(:mated?).and_return(false, false, false, true)
        allow(player2).to receive(:mated?).and_return(false)
        allow(player).to receive(:move)
        allow(player2).to receive(:move)
        expect(player).to receive(:move).exactly(3).times
        game.game_loop
      end
    end

    it 'calls #clear_terminal' do
      allow(game).to receive(:player_in_checkmate?).and_return(false)
      allow(player).to receive(:mated?).and_return(false, true)
      allow(player2).to receive(:mated?).and_return(false)
      allow(player).to receive(:move)
      allow(player2).to receive(:move)
      expect(game).to receive(:clear_terminal)
      game.game_loop
    end
  end

  describe '#enemy_king_location' do
    let(:player2) { instance_double('player') }
    it 'returns the enemy kings location' do
      allow(player2).to receive(:king_location).and_return([7, 5])
      game.instance_variable_set('@players', [player, player2])
      expect(game.enemy_king_location(player)).to eql([7, 5])
    end
  end

  describe '#enemy_at?' do
    before do
      game.instance_variable_set('@players', [player, player2])
      game.instance_variable_set('@board', board)
    end

    context 'when an enemy piece is at the location' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(game.enemy_at?(player, [7, 1])).to be true
      end
    end

    context 'when no piece is at the location' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(nil)
        expect(game.enemy_at?(player, [7, 1])).to be false
      end
    end

    context 'when a friendly piece is at the location' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:parent).and_return(player)
        expect(game.enemy_at?(player, [7, 1])).to be false
      end
    end
  end

  describe '#other_player' do
    before do
      game.instance_variable_set('@players', [player, player2])
    end

    context 'when called with player' do
      it 'returns player2' do
        expect(game.other_player(player)).to eq(player2)
      end
    end

    context 'when called with player2' do
      it 'returns player' do
        expect(game.other_player(player2)).to eq(player)
      end
    end
  end

  describe '#available?' do
    let(:location) { 'foo' }

    before do
      game.instance_variable_set('@players', [player, player2])
      game.instance_variable_set('@board', board)
    end

    context 'when a player selects an empty space' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(nil)
        expect(game.available?(player, location, board)).to be true
      end
    end

    context 'when a player selects a space with an enemy piece' do
      it 'returns true' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player2)
        expect(game.available?(player, location, board)).to be true
      end
    end

    context 'when a player selects a space with one of their pieces' do
      it 'returns false' do
        allow(board).to receive(:piece_at).and_return(piece)
        allow(piece).to receive(:player).and_return(player)
        expect(game.available?(player, location, board)).to be false
      end
    end
  end

  describe '#reachable?' do
    let(:board) { game.instance_variable_get('@board') }
    let(:current_board) { board.instance_variable_get('@current_board') }
    let(:players) { game.instance_variable_get('@players') }
    let(:player1) { players.first }
    let(:player2) { players.last }


    before do
      allow(piece).to receive(:location).and_return([0, 0])
      allow(piece).to receive(:player).and_return(player1)
      allow(piece2).to receive(:player).and_return(player2)
    end

    context 'when the piece can reach a horizontal location unobstructed' do
      it 'returns true' do
        current_board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [0, 6]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a vertical location unobstructed' do
      it 'returns true' do
        current_board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [6, 0]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a higher vertical location unobstructed' do
      it 'returns true' do
        allow(piece).to receive(:location).and_return([6, 0])
        current_board[6][0] = piece
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a diagonal location unobstructed' do
      it 'returns true' do
        current_board[0][0] = piece
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach a diagonal location with an enemy' do
      it 'returns true' do
        current_board[0][0] = piece
        current_board[6][6] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece can reach an upper diagonal location unobstructed' do
      it 'returns true' do
        current_board[6][6] = piece
        allow(piece).to receive(:location).and_return([6, 6])
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be true
      end
    end

    context 'when the piece cant reach a horizontal location unobstructed' do
      it 'returns false' do
        current_board[0][0] = piece
        current_board[0][4] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 6]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach a vertical location unobstructed' do
      it 'returns false' do
        current_board[0][0] = piece
        current_board[4][0] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 0]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach a higher vertical location unobstructed' do
      it 'returns false' do
        allow(piece).to receive(:location).and_return([6, 0])
        current_board[6][0] = piece
        current_board[4][0] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach a diagonal location unobstructed' do
      it 'returns false' do
        current_board[0][0] = piece
        current_board[4][4] = piece2
        game.instance_variable_set('@board', board)
        location = [6, 6]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end

    context 'when the piece cant reach an upper diagonal location unobstructed' do
      it 'returns false' do
        current_board[6][6] = piece
        allow(piece).to receive(:location).and_return([6, 6])
        current_board[4][4] = piece2
        game.instance_variable_set('@board', board)
        location = [0, 0]
        expect(game.reachable?(piece, location, board)).to be false
      end
    end
  end
end
