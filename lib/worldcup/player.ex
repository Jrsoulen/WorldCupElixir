defmodule Worldcup.Player do
  use Worldcup.Web, :model

  schema "player" do
    field :player_name, :string, size: 100
    field :country_id, :integer
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:player_name, :country_id])
    |> validate_required([:player_name, :country_id])
  end
end
