defmodule Ms.DeliveryManagement.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deliveries" do
    field :address, :map
    field :details, :map
    field :fare, :float
    # If a name ends with _id ecto consider it to be an id or a foreign key id.
    field :order_item_id, :id
    # belongs_to says that this deliveries schema has a foreign key reference to customers schema
    # Just like has_many, it too offers more flexibility, when querying using ecto
    belongs_to :customer, Ms.CustomerManagement.Customer

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:fare, :address, :details])
    |> validate_required([:fare, :address, :details])
  end
end
