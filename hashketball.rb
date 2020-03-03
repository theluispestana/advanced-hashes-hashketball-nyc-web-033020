# Write your code here!
require 'yaml'

def game_hash
  YAML.load_file('players.yml')
end

def num_points_scored(player_name)
  data = game_hash()
  player_stats = find_stats(player_name, data)
  player_stats[:points]
end

def find_stats(player_name, data)
  if data[:home][:players].any? { |stats| stats[:player_name] == player_name }
    team_players = data[:home][:players]
  else
    team_players = data[:away][:players]
  end
  players_stats = {}
  team_players.each { |hash| players_stats = hash if hash[:player_name] == player_name}
  players_stats
end

def home_or_away(team_name, data)
  if data[:home][:team_name] == team_name
    return :home
  else
    return :away
  end
end

def shoe_size(player_name)
  data = game_hash()
  player_stats = find_stats(player_name, data)
  player_stats[:shoe]
end

def team_colors(team_name)
  data = game_hash()
  team = home_or_away(team_name, data)
  return data[team][:colors]
end

def team_names
  data = game_hash()
  team_names = []
  data.each_value { |value| team_names << value[:team_name] }
  team_names
end

def player_numbers(team_name)
  data = game_hash()
  team = home_or_away(team_name, data)
  team_players = data[team][:players]
  team_numbers = []
  team_players.each { |player| team_numbers << player[:number] }
  team_numbers
end

def player_stats(player_name)
  data = game_hash()
  stats = find_stats(player_name, data)
  stats.delete(:player_name)
  stats
end

def big_shoe_rebounds
  data = game_hash()

  home_players = data[:home][:players]
  away_players = data[:away][:players]

  home_players.sort_by! { |player| player[:shoe] }
  away_players.sort_by! { |player| player[:shoe] }

  if home_players[-1][:shoe] > away_players[-1][:shoe]
    return home_players[-1][:rebounds]
  else
    away_players[-1][:rebounds]
  end
end
