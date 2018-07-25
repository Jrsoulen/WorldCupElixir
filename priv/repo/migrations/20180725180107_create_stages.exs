defmodule Worldcup.Repo.Migrations.CreateStages do
  use Ecto.Migration

  def change do
    create table(:stages) do
      add :stage_name, :string

      timestamps()
    end

  end
end
