defmodule Worldcup.Repo.Migrations.CreateMatchStages do
  use Ecto.Migration

  def change do
    create table(:match_stages) do
      add :match_id, references(:matches, on_delete: :nothing)
      add :stage_id, references(:stages, on_delete: :nothing)

      timestamps()
    end

    create index(:match_stages, [:match_id])
    create index(:match_stages, [:stage_id])
  end
end
