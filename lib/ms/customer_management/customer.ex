defmodule Ms.CustomerManagement.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :details, :map
    field :name, :string
    field :phone, :string
    field :pincode, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :phone, :pincode, :details])
    |> validate_required([:name, :phone, :pincode, :details])
  end
end
