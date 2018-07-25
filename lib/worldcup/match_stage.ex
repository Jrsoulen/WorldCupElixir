defmodule Worldcup.MatchStage do
  use Ecto.Schema
  import Ecto.Changeset


  schema "match_stages" do
    field :match_id, :id
    field :stage_id, :id

    timestamps()
  end

  @doc false
  def changeset(match_stage, attrs) do
    match_stage
    |> cast(attrs, [])
    |> validate_required([])
  end
end
