defmodule Ms.OrderManagement.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :creationDate, :utc_datetime
    field :details, :map
    field :message, :string
    field :customer, :id

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:creationDate, :message, :details])
    |> validate_required([:creationDate, :message, :details])
  end
end
