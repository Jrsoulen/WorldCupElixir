defmodule Worldcup.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :home_id, references(:country, on_delete: :nothing)
      add :away_id, references(:country, on_delete: :nothing)
      add :kickoff, :utc_datetime

      timestamps()
    end
  end
end
