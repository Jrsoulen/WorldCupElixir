defmodule Worldcup.Repo.Migrations.ChangeNameColumn do
  use Ecto.Migration

  def change do
    rename table(:country), :name, to: :country

  end
end
