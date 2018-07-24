defmodule ApiWorker do
  alias Worldcup.Country, as: Country
  alias Worldcup.Repo, as: Repo

  def team_url do
    "https://worldcup.sfg.io/teams/results"
  end

  def fetch_team() do
    now = DateTime.to_string(%{DateTime.utc_now| microsecond: {0,0}})
    %HTTPoison.Response{body: body} = HTTPoison.get! team_url()

    body
    |> Poison.decode!
    |> List.flatten
    |> Enum.map(fn (x) ->
       %Country{}
        |> Country.changeset(x)
        |> Repo.insert
    end)
  end

end
#parsing data from elixir maps
