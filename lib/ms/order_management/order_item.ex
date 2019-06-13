defmodule Ms.OrderManagement.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :amount, :integer
    field :unitPrice, :float
    field :product, :id
    field :order, :id

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:amount, :unitPrice])
    |> validate_required([:amount, :unitPrice])
  end
end
