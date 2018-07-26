defmodule Worldcup.Repo.Migrations.AddFkGoalToCountry do
  use Ecto.Migration

  def change do
      alter table (:goals) do
        add :country_id, references(:country)
      end
  end
end
