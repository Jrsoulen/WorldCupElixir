defmodule Worldcup.Match do
  use Worldcup.Web, :model


  schema "matches" do
    field :home_id, :integer
    field :away_id, :integer
    field :kickoff, :utc_datetime
    belongs_to :stage, Worldcup.Stage
    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:home_id, :away_id, :kickoff, :stage_id])
    |> validate_required([:home_id, :away_id, :kickoff, :stage_id])
  end
end
