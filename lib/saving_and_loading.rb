# frozen_string_literal: true

require 'yaml'

# Includes methods related to saving a game and restoring from a save
module SavingAndLoading
  def game_state(current_players, current_board, current_player)
    { players: current_players, board: current_board, player: current_player }
  end

  def save_game(current_player, save_as = file_name)
    current_state = game_state(players, board, current_player)
    File.open(save_as, 'w') { |file| file.write(current_state.to_yaml) }
  end

  def load_game(game_save = nil)
    save = game_save || YAML.load_file(file_name)
    self.players = save.fetch(:players)
    self.board = save.fetch(:board)
    player = save.fetch(:player)
    players.reverse! unless players.first == player
  end

  def ask_to_load_game
    load_game if prompt_user_to_load_game == 'y'
  end

  private

  def prompt_user_to_load_game
    puts 'Save game detected. Load previous game? y/n'
    gets.chomp
  end
end
