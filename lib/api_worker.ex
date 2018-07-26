defmodule ApiWorker do
  alias Worldcup.Country, as: Country
  alias Worldcup.GroupName, as: GroupName
  alias Worldcup.Player, as: Player
  alias Worldcup.Repo, as: Repo
  alias Worldcup.Match, as: Match
  alias Worldcup.Stage, as: Stage
  import Ecto.Query

  def match_stage do
    stage_dictionary = Repo.all(from Stage)
      |> Enum.map(fn (x) -> {String.to_atom(x.stage_name), x.id} end)
    country_dictionary = Repo.all(from Country)
      |> Enum.map(fn (x) -> {String.to_atom(x.country), x.id} end)

    %HTTPoison.Response{body: body} = HTTPoison.get! "https://worldcup.sfg.io/matches"
    body
    |> Poison.decode!
    |> Enum.each(fn (match) ->
      stage = match
        |> Map.fetch!("stage_name")
      home = match
        |> Map.fetch!("home_team_country")
      home = country_dictionary[String.to_atom(home)]
      away = match
        |> Map.fetch!("away_team_country")
      away = country_dictionary[String.to_atom(away)]
      match = from(m in Match, where: m.home_id == ^home and m.away_id == ^away)
        |> Repo.one
      match = Ecto.Changeset.change match, stage_id: stage_dictionary[String.to_atom(stage)]
      Repo.update! match
    end)
  end

  def fetch_matches do
    country_dictionary = Repo.all(from Country)
      |> Enum.map(fn (x) -> {String.to_atom(x.country), x.id} end)

    %HTTPoison.Response{body: body} = HTTPoison.get! "https://worldcup.sfg.io/matches"
    body
    |> Poison.decode!
    |> Enum.each(fn (match) ->
      home = match
        |> Map.fetch!("home_team_country")
      away = match
        |> Map.fetch!("away_team_country")
      kickoff = match
        |> Map.fetch!("datetime")
      new_match = %{home_id: country_dictionary[String.to_atom(home)], away_id: country_dictionary[String.to_atom(away)], kickoff: kickoff}
      IO.inspect(new_match, label: "hows this")
       %Match{}
       |> Match.changeset(new_match)
       |> Repo.insert
    end)
  end

  def fetch_codes do
    codes = Repo.all(from Country)
      |> Enum.map(fn (x) -> [x.fifa_code, x.id]end)
      Enum.each(codes, fn (x) -> IO.puts(List.first(x)) end)
      |>IO.inspect(label: "what do we have here.")
  end

  def fetch_players(match, country_id, country_code) do
    home_code = match
      |> Map.fetch!("home_team")
      |> Map.fetch!("code")
      IO.puts(home_code)
      cond do
            home_code == country_code ->
              IO.puts("STARTING 11")
              Map.fetch!(match, "home_team_statistics")
              |> Map.fetch!("starting_eleven")
              |> Enum.each(fn (player)->
                player = Map.fetch!(player, "name")
                existing = Repo.get_by(Player, player_name: player)
                if (is_nil(existing)) do
                  new_player = %{country_id: country_id, player_name: player}
                  %Player{}
                  |> Player.changeset(new_player)
                  |> Repo.insert
                end
              end)
              IO.puts("SUBSTITUTES")
              Map.fetch!(match, "home_team_statistics")
              |> Map.fetch!("substitutes")
              |> Enum.each(fn (player)->
                player = Map.fetch!(player, "name")
                existing = Repo.get_by(Player, player_name: player)
                if (is_nil(existing)) do
                  new_player = %{country_id: country_id, player_name: player}
                  %Player{}
                  |> Player.changeset(new_player)
                  |> Repo.insert
                end
              end)
            true ->
              Map.fetch!(match, "away_team_statistics")
              |> Map.fetch!("starting_eleven")
              |> Enum.each(fn (player)->
                player = Map.fetch!(player, "name")
                existing = Repo.get_by(Player, player_name: player)
                if (is_nil(existing)) do
                  new_player = %{country_id: country_id, player_name: player}
                  %Player{}
                  |> Player.changeset(new_player)
                  |> Repo.insert
                end
              end)
              IO.puts("SUBSTITUTES")
              Map.fetch!(match, "away_team_statistics")
              |> Map.fetch!("substitutes")
              |> Enum.each(fn (player)->
                player = Map.fetch!(player, "name")
                existing = Repo.get_by(Player, player_name: player)
                if (is_nil(existing)) do
                  new_player = %{country_id: country_id, player_name: player}
                  %Player{}
                  |> Player.changeset(new_player)
                  |> Repo.insert
                end
              end)
      end
  end

  def fetch_matches_by_country() do
    codes = Repo.all(from Country)
      |> Enum.map(fn (x) -> [x.fifa_code, x.id] end)
      |> IO.inspect(label: "whats my list look like then")

    Enum.each(codes, fn code ->
      %HTTPoison.Response{body: body} = HTTPoison.get! match_by_code_url() <> List.first(code)
      body
      |> Poison.decode!
      |> Enum.each(fn (match) ->
        fetch_players(match, List.last(code), List.first(code))
      end)
      :timer.sleep(10000)
    end)
  end

  def fetch_group_name() do
    %HTTPoison.Response{body: body} = HTTPoison.get! team_url()
    body
    |> Poison.decode!
    |> List.flatten
    |> Enum.map(fn (x) ->
        existing = Repo.get_by(GroupName, group_id: x["group_id"])
        if (is_nil(existing)) do
          %GroupName{}
          |> GroupName.changeset(x)
          |> Repo.insert
        end
    end)
  end

  def fetch_stages do
    %HTTPoison.Response{body: body} = HTTPoison.get! "https://worldcup.sfg.io/matches"
    body
    |> Poison.decode!
    |> List.flatten
    |> Enum.map(fn (x) ->
        existing = Repo.get_by(Stage, stage_name: x["stage_name"])
        if (is_nil(existing)) do
          %Stage{}
          |> Stage.changeset(x)
          |> Repo.insert
       end
    end)
  end

  def fetch_team() do
    dictionary = Repo.all(from GroupName)
      |> Enum.map(fn (x) -> {String.to_atom(Integer.to_string(x.group_id)), x.id} end)

    %HTTPoison.Response{body: body} = HTTPoison.get! team_url()

    body
    |> Poison.decode!
    |> List.flatten
    |> IO.inspect(label: "before")
    |> Enum.map(fn (x) -> Map.put(x, "group_id", dictionary[String.to_atom(Integer.to_string(Map.fetch!(x, "group_id")))]) end)
    |> IO.inspect(label: "after")
    |> Enum.map(fn (x) ->
       %Country{}
        |> Country.changeset(x)
        |> Repo.insert
    end)
  end

  def set_case do
    "dembele MUTUMBO"
    |> String.split(" ")
    |> Enum.map(fn (x) -> String.capitalize(x) end)
    |> Enum.join(" ")
  end

  def team_url do
    "https://worldcup.sfg.io/teams/results"
  end

  def match_by_code_url do
    "https://worldcup.sfg.io/matches/country?fifa_code="
  end
end
#parsing data from elixir maps
