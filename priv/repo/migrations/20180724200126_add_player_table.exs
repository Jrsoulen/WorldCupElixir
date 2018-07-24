defmodule Worldcup.Repo.Migrations.AddPlayerTable do
  use Ecto.Migration

  def up do
    create table("player") do
      add :player_name, :string, size: 100
      add :country_id, references(:country)
      timestamps()
    end
  end
  def down do
    drop table("player")
  end
end
