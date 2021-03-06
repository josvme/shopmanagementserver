defmodule Ms.OrderManagement.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :creation_date, :utc_datetime
    field :details, :map
    field :message, :string
    belongs_to :customer, Ms.CustomerManagement.Customer
    has_many :order_items, Ms.OrderManagement.OrderItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:creation_date, :message, :details])
    |> validate_required([:creation_date, :message, :details])
  end
end
