defmodule Worldcup.CountryTest do
  use Worldcup.ModelCase

  alias Worldcup.Country

  @valid_attrs %{fifa_code: "some fifa_code", group_id: 42, name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Country.changeset(%Country{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Country.changeset(%Country{}, @invalid_attrs)
    refute changeset.valid?
  end
end
