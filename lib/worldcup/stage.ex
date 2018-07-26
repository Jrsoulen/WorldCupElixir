defmodule Worldcup.Stage do
  use Ecto.Schema
  import Ecto.Changeset
  use Worldcup.Web, :model


  schema "stages" do
    field :stage_name, :string

    timestamps()
  end

  @doc false
  def changeset(stage, params \\ %{}) do
    stage
    |> cast(params, [:stage_name])
    |> validate_required([:stage_name])
  end
end
