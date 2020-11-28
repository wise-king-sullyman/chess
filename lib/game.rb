# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'player.rb'
require_relative 'ai.rb'
require 'yaml'

# manage the game
class Game
  def initialize
    @over = false
    @winner = nil
    @players = []
    @board = Board.new(@players)
    @file_name = 'chess_save.yaml'
  end

  def move_piece(piece, location)
    at_location = @board.piece_at(location)
    at_location&.player&.remove_piece(at_location)
    piece.move(location)
    @board.refresh
  end

  def test_move_piece(piece, location)
    at_location = @board.piece_at(location)
    at_location&.player&.remove_piece(at_location)
    piece.move(location, true)
    @board.refresh
  end

  def game_over?
  end

  def save_game(current_player)
    current_state = {
      players: @players,
      board: @board,
      player: current_player
    }
    File.open(@file_name, 'w') { |file| file.write(current_state.to_yaml) }
  end

  def load_game
    save = YAML.load_file(@file_name)
    @players = save.fetch(:players)
    @board = save.fetch(:board)
    player = save.fetch(:player)
    @players.reverse! unless @players.first == player
  end

  def ask_to_load_game
    puts 'Save game detected. Load previous game? y/n'
    load_game if gets.chomp == 'y'
  end

  def player_input_1_or_2
    input = gets.chomp.to_i
    until input.between?(1, 2)
      puts 'Choice must be "1" or "2"'
      input = gets.chomp.to_i
    end
    input
  end

  def add_players
    puts 'Enter 1 for single player (against computer) or 2 for two player game'
    player_input_1_or_2 == 1 ? setup_single_player_game : setup_two_player_game
  end

  def setup_single_player_game
    puts 'Enter 1 to be the white player, 2 to be the black player'
    if player_input_1_or_2 == 1
      white = Player.new('player 1', 'white', self)
      black = AI.new('player 2', 'black', self)
    else
      white = AI.new('player 1', 'white', self)
      black = Player.new('player 2', 'black', self)
    end
    @players.push(white, black)
  end

  def setup_two_player_game
    white = Player.new('player 1', 'white', self)
    black = Player.new('player 2', 'black', self)
    @players.push(white, black)
  end

  def play
    ask_to_load_game if File.exist?(@file_name)
    add_players if @players.empty?
    loop do
      @players.each do |player|
        save_game(player)
        @board.refresh
        puts @board
        player.move
        if player_in_check?(player)
          puts 'You must move out of check'
          load_game
          break
        end
        if enemy_in_check?(player)
          puts "#{other_player(player).name} in check"
          return player if other_player(player).mated?
        end
        break if player.in_stalemate?
      end
    end
  end

  def player_in_check?(player)
    enemy_in_check?(other_player(player))
  end

  def enemy_in_check?(calling_player)
    calling_player.pieces.each do |piece|
      return true if piece.can_attack_king?
    end
    false
  end

  def move_checks_self?(piece, location)
    starting_location = piece.location
    test_move_piece(piece, location)
    output = player_in_check?(piece.player) ? true : false
    load_game
    test_move_piece(piece, starting_location)
    output
  end

  def in_check_at?(player, location)
    enemy_pieces = other_player(player).pieces
    enemy_pieces.each do |piece|
      next if piece.class == King
      return true if piece.can_attack_location?(location)
    end
    false
  end

  def enemy_king_location(calling_player)
    enemy_player = other_player(calling_player)
    enemy_player.king_location
  end

  def enemy_at?(calling_player, location)
    enemy_player = other_player(calling_player)
    at_location = @board.piece_at(location)
    at_location.respond_to?(:player) && at_location.player == enemy_player
  end

  def available?(player, location)
    at_location = @board.piece_at(location)
    return false if at_location.respond_to?(:player) && at_location.player == player

    true
  end

  def reachable?(piece, destination)
    from_row = piece.location.first
    from_column = piece.location.last
    to_row = destination.first
    to_column = destination.last

    return true if piece.class == Knight

    return row_reachable?(piece, destination) if from_row == to_row

    return column_reachable?(piece, destination) if from_column == to_column

    return false unless diagonal_reachable?(piece, destination)

    true
  end

  def piece_at(location)
    @board.piece_at(location)
  end

  private

  def row_reachable?(piece, to)
    from_column = piece.location.last
    range = to.last > from_column ? (from_column + 1...to.last) : (to.last + 1...from_column)
    range.each do |column|
      return false if piece_at([piece.location.first, column])
    end
    true
  end

  def column_reachable?(piece, to)
    from_row = piece.location.first
    range = to.first > from_row ? (from_row + 1...to.first) : (to.first + 1...from_row)
    range.each do |row|
      return false if piece_at([row, piece.location.last])
    end
    true
  end

  def diagonal_reachable?(piece, to)
    from_row = piece.location.first
    from_column = piece.location.last
    row_direction = from_row < to.first ? 1 : -1
    column_direction = from_column < to.last ? 1 : -1
    until from_row + row_direction == to.first && from_column + column_direction == to.last
      return false if piece_at([from_row += row_direction, from_column += column_direction])
    end
    true
  end

  def other_player(calling_player)
    player1 = @players.first
    player2 = @players.last
    player1 == calling_player ? player2 : player1
  end
end
