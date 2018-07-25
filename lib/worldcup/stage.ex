defmodule Worldcup.Stage do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stages" do
    field :stage_name, :string

    timestamps()
  end

  @doc false
  def changeset(stage, attrs) do
    stage
    |> cast(attrs, [:stage_name])
    |> validate_required([:stage_name])
  end
end
