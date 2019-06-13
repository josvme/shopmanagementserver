defmodule Ms.Inventory.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :details, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :details])
    |> validate_required([:name, :details])
  end
end
