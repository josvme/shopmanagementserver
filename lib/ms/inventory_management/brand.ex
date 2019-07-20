defmodule Ms.InventoryManagement.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :details, :map
    field :name, :string
    has_many :products, Ms.InventoryManagement.Product

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :details])
    |> validate_required([:name, :details])
  end
end
