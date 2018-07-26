defmodule Worldcup.Goal do
  use Ecto.Schema
  import Ecto.Changeset


  schema "goals" do
    field :minute, :string
    belongs_to :match, Worldcup.Match
    belongs_to :player, Worldcup.Player
    belongs_to :country, Worldcup.Country

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:minute, :match_id, :player_id, :country_id])
    |> validate_required([:minute, :match_id, :player_id, :country_id])
  end
end
