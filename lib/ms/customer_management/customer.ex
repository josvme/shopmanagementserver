defmodule Ms.CustomerManagement.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :details, :map
    field :name, :string
    field :phone, :string
    field :pincode, :string
    # has_many tells that there can be multiple orders from a customer
    # This can be used to preload all orders from a customer
    has_many :orders, Ms.OrderManagement.Order

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :phone, :pincode, :details])
    |> validate_required([:name, :phone, :pincode, :details])
  end
end
