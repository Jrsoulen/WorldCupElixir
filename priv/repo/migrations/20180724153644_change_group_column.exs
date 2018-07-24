defmodule Worldcup.Repo.Migrations.ChangeGroupColumn do
  use Ecto.Migration

  def change do
      rename table(:group_name), :group, to: :group_letter
  end
end
