defmodule Worldcup.Repo.Migrations.AddStagesToMatches do
    use Ecto.Migration

    def change do
      alter table (:matches) do
        add :stage_id, references(:stages)
      end
    end
  end
