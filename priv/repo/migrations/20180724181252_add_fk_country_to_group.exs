defmodule Worldcup.Repo.Migrations.AddFkCountryToGroup do
  use Ecto.Migration

  def change do
    alter table (:country) do
      modify :group_id, references(:group_name)
    end
  end
end
