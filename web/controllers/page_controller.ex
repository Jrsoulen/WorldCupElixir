defmodule Worldcup.PageController do
  use Worldcup.Web, :controller
  alias Worldcup.Country

  def index(conn, _params) do
    teams = Repo.all(Country)

    final = get_query("where s.id = 6")
    final = Ecto.Adapters.SQL.query!(Repo, final, [])
      |> Map.fetch!(:rows)

    groups = Ecto.Adapters.SQL.query!(Repo, get_groups(), [])
      |> Map.fetch!(:rows)

    matches = Ecto.Adapters.SQL.query!(Repo, get_query("where s.id = 1"), [])
      |>Map.fetch!(:rows)

    render(conn, "index.html", teams: teams, matches: matches,  final: final, groups: groups)
  end

  def get_groups do
    """
    select group_id,	group_letter
    from group_name
    order by group_id, group_letter
    """
  end

  def get_query(where) do
    qry = """
        select a.id as match,
        	s.stage_name as stage,
        	b.country as home,
        	COUNT (DISTINCT d.id) as home_goals,
        	COUNT (DISTINCT e.id) as away_goals,
        	c.country as away,
        	g.group_letter as group_letter,
        	g.group_id as group_id
        from matches a
        	inner join stages s on a.stage_id = s.id
        	inner join country b on b.id = a.home_id
        	inner join country c on c.id = a.away_id
        	inner join group_name g on g.id = c.group_id
        	left join goals d on d.match_id = a.id and d.country_id = b.id
        	left join goals e on e.match_id = a.id and e.country_id = c.id
        #{where}
        group by a.id, s.stage_name, b.country, c.country, g.group_letter, g.group_id
        order by g.group_letter, b.country, c.country
      """
    end
end
