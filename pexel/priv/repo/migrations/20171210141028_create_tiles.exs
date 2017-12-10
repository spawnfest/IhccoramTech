defmodule Pexel.Repo.Migrations.CreateTiles do
  use Ecto.Migration

  def change do
    create table(:tiles, primary_key: false) do
      add :x, :integer, primary_key: true
      add :y, :integer, primary_key: true
      add :color, :integer

      timestamps()
    end

  end
end
