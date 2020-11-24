# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'player.rb'
require 'yaml'

# manage the game
class Game
  def initialize
    @over = false
    @winner = nil
    @players = [
      Player.new('player 1', 'white', self),
      Player.new('player 2', 'black', self)
    ]
    @board = Board.new(@players)
    @file_name = 'chess_save.yaml'
  end

  def move_piece(piece, location)
    at_location = @board.piece_at(location)
    at_location&.player&.remove_piece(at_location)
    piece.move(location)
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

  def play
    ask_to_load_game if File.exist?(@file_name)
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
