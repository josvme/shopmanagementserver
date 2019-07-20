defmodule Ms.OrderManagement.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :amount, :integer
    field :unit_price, :float
    field :product, :id
    field :order, :id

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:amount, :unit_price])
    |> validate_required([:amount, :unit_price])
  end
end
