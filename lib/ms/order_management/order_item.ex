defmodule Ms.OrderManagement.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  # Automatically constructs a JSON with amount, id, unit_price, order_id, :product_id when we render an order_item.
  @derive {Jason.Encoder, only: [:amount, :id, :unit_price, :order_id, :product_id]}
  schema "order_items" do
    field :amount, :integer
    field :unit_price, :float
    belongs_to :product, Ms.InventoryManagement.Product
    belongs_to :order, Ms.OrderManagement.Order

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:amount, :unit_price, :order_id, :product_id])
    |> validate_required([:amount, :unit_price, :order_id, :product_id])
    |> foreign_key_constraint(:order)
  end
end
