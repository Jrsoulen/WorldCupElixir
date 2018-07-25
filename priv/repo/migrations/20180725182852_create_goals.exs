defmodule Worldcup.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :minute, :string
      add :match_id, references(:matches, on_delete: :nothing)
      add :player_id, references(:player, on_delete: :nothing)

      timestamps()
    end

    create index(:goals, [:match_id])
    create index(:goals, [:player_id])
  end
end
