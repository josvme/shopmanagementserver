defmodule Ms.DeliveryManagement.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deliveries" do
    field :address, :map
    field :details, :map
    field :fare, :float
    field :order_item, :id
    field :customer, :id

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:fare, :address, :details])
    |> validate_required([:fare, :address, :details])
  end
end
