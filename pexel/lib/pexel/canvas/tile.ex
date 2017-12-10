defmodule Pexel.Canvas.Tile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pexel.Canvas.Tile


  schema "tiles" do
    field :color, :binary
    field :x, :integer
    field :y, :integer

    timestamps()
  end

  @doc false
  def changeset(%Tile{} = tile, attrs) do
    tile
    |> cast(attrs, [:x, :y, :color])
    |> validate_required([:x, :y, :color])
  end
end
