defmodule Worldcup.Country do
  use Worldcup.Web, :model

  schema "country" do
    field :country, :string
    field :fifa_code, :string
    field :group_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country, :fifa_code, :group_id])
    |> validate_required([:country, :fifa_code, :group_id])
  end
end
