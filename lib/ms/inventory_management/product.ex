defmodule Ms.InventoryManagement.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :float
    field :stock, :integer
    field :tax, :float
    field :details, :map
    belongs_to :brand, Ms.InventoryManagement.Brand

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:price, :stock, :name, :tax, :details])
    |> validate_required([:price, :stock, :name, :tax])
  end
end
