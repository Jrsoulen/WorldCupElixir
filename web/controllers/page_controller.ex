defmodule Worldcup.PageController do
  use Worldcup.Web, :controller
  alias Worldcup.Country

  def index(conn, _params) do
    teams = Repo.all(Country)

    final = get_query("where s.id = 6")
    final = Ecto.Adapters.SQL.query!(Repo, final, [])
      |> Map.fetch!(:rows)

    a_matches = get_query("where b.group_id = 16 and s.id = 1")
    a_matches = Ecto.Adapters.SQL.query!(Repo, a_matches, [])
      |> Map.fetch!(:rows)
    #will this work?
    b_matches = get_query("where b.group_id = 15 and s.id = 1")
    b_matches = Ecto.Adapters.SQL.query!(Repo, b_matches, [])
      |> Map.fetch!(:rows)

    c_matches = get_query("where b.group_id = 13 and s.id = 1")
    c_matches = Ecto.Adapters.SQL.query!(Repo, c_matches, [])
      |> Map.fetch!(:rows)

    d_matches = get_query("where b.group_id = 14 and s.id = 1")
    d_matches = Ecto.Adapters.SQL.query!(Repo, d_matches, [])
      |> Map.fetch!(:rows)

    e_matches = get_query("where b.group_id = 10 and s.id = 1")
    e_matches = Ecto.Adapters.SQL.query!(Repo, e_matches, [])
      |> Map.fetch!(:rows)

    f_matches = get_query("where b.group_id = 9 and s.id = 1")
    f_matches = Ecto.Adapters.SQL.query!(Repo, f_matches, [])
      |> Map.fetch!(:rows)

    g_matches = get_query("where b.group_id = 11 and s.id = 1")
    g_matches = Ecto.Adapters.SQL.query!(Repo, g_matches, [])
      |> Map.fetch!(:rows)

    h_matches = get_query("where b.group_id = 12 and s.id = 1")
    h_matches = Ecto.Adapters.SQL.query!(Repo, h_matches, [])
      |> Map.fetch!(:rows)

    matches = Ecto.Adapters.SQL.query!(Repo, get_query(""), [])
      |>Map.fetch!(:rows)

    render(conn, "index.html", teams: teams, matches: matches, a_matches: a_matches, b_matches: b_matches, c_matches: c_matches, d_matches: d_matches, final: final)
  end

  def get_query(where) do
    ~s{
      select a.id as match,
        s.stage_name as stage,
        b.country as home,
        COUNT (DISTINCT d.id) as home_goals,
        COUNT (DISTINCT e.id) as away_goals,
        c.country as away
      from matches a
        inner join stages s on a.stage_id = s.id
        inner join country b on b.id = a.home_id
        inner join country c on c.id = a.away_id
        left join goals d on d.match_id = a.id and d.country_id = b.id
        left join goals e on e.match_id = a.id and e.country_id = c.id
      #{where}
      group by a.id, s.stage_name, b.country, c.country
      order by a.id, b.country, c.country
    }
  end

  def test do
    qry = """
      select a.id as match,
        s.stage_name as stage,
        b.country as home,
        COUNT (DISTINCT d.id) as home_goals,
        COUNT (DISTINCT e.id) as away_goals,
        c.country as away
      from matches a
        inner join stages s on a.stage_id = s.id
        inner join country b on b.id = a.home_id
        inner join country c on c.id = a.away_id
        left join goals d on d.match_id = a.id and d.country_id = b.id
        left join goals e on e.match_id = a.id and e.country_id = c.id
      group by a.id, s.stage_name, b.country, c.country
      order by a.id, b.country, c.country
      """
    matches = Ecto.Adapters.SQL.query!(Repo, qry, [])
      |> Map.fetch!(:rows)
    IO.inspect(List.first(List.first(matches)), label: "matches")
  end
end
