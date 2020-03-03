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

def all_players_sorted(data, sort_by)
  all_players = []
  all_players.push(data[:home][:players], data[:away][:players])
  if sort_by == "name"
    all_players.flatten!.sort_by!{ |player| player[:player_name].length }
  else
    all_players.flatten!.sort_by!{ |player| player[sort_by] }
  end
end

def big_shoe_rebounds
  data = game_hash()

  all_players = all_players_sorted(data, :shoe)
  all_players[-1][:rebounds]
end

def most_points_scored
  data = game_hash()

  all_players = all_players_sorted(data, :points)
  all_players[-1][:player_name]
end

def winning_team
  data = game_hash()
  home_players = data[:home][:players]
  home_points = 0
  home_players.each { |player| home_points += player[:number] }

  away_players = data[:away][:players]
  away_points = 0
  away_players.each { |player| away_points += player[:number] }

  if home_points > away_points
    data[:home][:team_name]
  else
    data[:away][:team_name]
  end
end

def player_with_longest_name
  data = game_hash()

  all_players = all_players_sorted(data, "name")
  all_players[-1][:player_name]
end

def long_name_steals_a_ton?
  data = game_hash()

  all_players_by_name = all_players_sorted(data, "name")
  all_players_by_steals = all_players_sorted(data, :steals)
  all_players_by_name[-1] == all_players_by_steals[-1]
end
