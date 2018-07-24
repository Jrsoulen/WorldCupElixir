defmodule ApiWorker do
  alias Worldcup.Country, as: Country
  alias Worldcup.GroupName, as: GroupName
  alias Worldcup.Repo, as: Repo
  import Ecto.Query

  def team_url do
    "https://worldcup.sfg.io/teams/results"
  end

  def match_by_code_url do
    "https://worldcup.sfg.io/matches/country?fifa_code="
  end

  def fetch_codes do
    codes = Repo.all(from Country)
      |> Enum.map(fn (x) -> [x.fifa_code, x.id]end)
      Enum.each(codes, fn (x) -> IO.puts(List.first(x)) end)
      |>IO.inspect(label: "what do we have here.")
  end

  def fetch_matches() do
    codes = Repo.all(from Country)
      |> Enum.map(fn (x) -> [x.fifa_code, x.id] end)
      |> Enum.fetch!(0)
      |> List.wrap

    Enum.each(codes, fn code ->
      %HTTPoison.Response{body: body} = HTTPoison.get! match_by_code_url() <> "KOR"
      body
      |> IO.inspect(label: "Mathces")
      #|> Poison.decode!
      #|> List.flatten
      #|> IO.inspect(label: "Mathces")
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

end
#parsing data from elixir maps
