defmodule Pexel.Canvas.Tile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pexel.Canvas.Tile

  @max_color 16

  @primary_key false
  schema "tiles" do
    field :color, :integer
    field :x, :integer, primary_key: true
    field :y, :integer, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(%Tile{} = tile, attrs) do
    tile
    |> cast(attrs, [:x, :y, :color])
    |> validate_required([:x, :y, :color])
    |> validate_number(:color, greater_than_or_equal_to: 0, less_than: @max_color)
  end
end
