defmodule Worldcup.Repo.Migrations.CreateCountry do
  use Ecto.Migration

  def change do
    create table(:country) do
      add :name, :string
      add :fifa_code, :string
      add :group_id, :integer

      timestamps()
    end
  end
end
