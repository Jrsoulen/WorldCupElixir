defmodule Worldcup.Repo.Migrations.CreateGroupTable do
  use Ecto.Migration

  def up do
    create table("group_name") do
      add :group, :string, size: 1
      timestamps()
    end
  end

  def down do
    drop table("group_name")
  end
end
