defmodule Ms.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :amount, :integer
      add :unitPrice, :float
      add :product, references(:products, on_delete: :nothing)
      add :order, references(:orders, on_delete: :nothing)

      timestamps()
    end

    create index(:order_items, [:product])
    create index(:order_items, [:order])
  end
end
