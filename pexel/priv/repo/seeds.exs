# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pexel.Repo.insert!(%Pexel.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Pexel.DBSeeder do
  alias Pexel.Repo
  alias Pexel.Canvas.Tile

  def insert_black_tile(x, y) do
    Repo.insert!(%Tile{
      x: x,
      y: y,
      color: 0
    })
  end

  def clear do
    Repo.delete_all(Tile)
  end
end

Pexel.DBSeeder.clear()

for x <- 0..99, y <- 0..99 do
  {x, y}
end
|> Enum.each(fn {x, y} -> Pexel.DBSeeder.insert_black_tile(x, y) end)
