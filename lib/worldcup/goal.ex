defmodule Worldcup.Goal do
  use Ecto.Schema
  import Ecto.Changeset


  schema "goals" do
    field :goal, :string
    field :match_id, :id
    field :player_id, :id

    timestamps()
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:goal])
    |> validate_required([:goal])
  end
end
