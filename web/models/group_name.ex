defmodule Worldcup.GroupName do
  use Worldcup.Web, :model

  schema "group_name" do
    field :group_letter, :string, size: 1
    field :group_id, :integer
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_letter, :group_id])
    |> validate_required([:group_letter, :group_id])
  end
end
