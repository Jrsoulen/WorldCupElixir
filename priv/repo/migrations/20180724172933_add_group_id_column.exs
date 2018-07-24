defmodule Worldcup.Repo.Migrations.AddGroupIdColumn1 do
  use Ecto.Migration

  def change do
    alter table (:group_name) do
      add :group_id, :integer
    end
  end
end
