# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'ai'
require_relative 'move_validation'
require_relative 'saving_and_loading'
require_relative 'check_detection'

# manage the game
class Game
  include MoveValidation
  include SavingAndLoading
  include CheckDetection

  attr_reader :board, :players, :file_name

  def initialize
    @players = []
    @board = Board.new(players)
    @file_name = 'chess_save.yaml'
  end

  def move_piece(piece, location)
    at_location = board.piece_at(location)
    at_location&.player&.remove_piece(at_location)
    piece.move(location)
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
    players.push(white, black)
  end

  def setup_two_player_game
    white = Player.new('player 1', 'white', self)
    black = Player.new('player 2', 'black', self)
    players.push(white, black)
  end

  def play
    ask_to_load_game if File.exist?(file_name)
    add_players if players.empty?
    announce_winner(game_loop)
  end

  def announce_winner(winner)
    if winner
      puts "#{other_player(winner).name} in checkmate! #{winner.name} won!"
    else
      puts 'Draw game'
    end
  end

  def game_loop
    loop do
      players.each do |player|
        ply_setup(player)
        return other_player(player) if player_in_checkmate?(player)

        return nil if player.mated?

        player.move
        clear_terminal
      end
    end
  end

  def ply_setup(player)
    save_game(player)
    previous_move = other_player(player).last_move
    puts "Last move: #{previous_move.first} to #{previous_move.last}" unless previous_move.empty?
    board.refresh
    puts board
    puts "#{player.name} in check" if player_in_check?(player)
  end

  def enemy_king_location(calling_player)
    enemy_player = other_player(calling_player)
    enemy_player.king_location
  end

  def enemy_at?(calling_player, location)
    enemy_player = other_player(calling_player)
    at_location = board.piece_at(location)
    at_location.respond_to?(:player) && at_location.player == enemy_player
  end

  def piece_at(location)
    board.piece_at(location)
  end

  def other_player(calling_player)
    player1 = players.first
    player2 = players.last
    player1 == calling_player ? player2 : player1
  end

  private

  attr_writer :players, :board

  def clear_terminal
    system('clear') || system('cls')
  end
end
