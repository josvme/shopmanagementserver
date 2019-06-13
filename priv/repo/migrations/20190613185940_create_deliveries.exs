defmodule Ms.Repo.Migrations.CreateDeliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :fare, :float
      add :address, :map
      add :details, :map
      add :orderitem, references(:order_items, on_delete: :nothing)
      add :customer, references(:customers, on_delete: :nothing)

      timestamps()
    end

    create index(:deliveries, [:orderitem])
    create index(:deliveries, [:customer])
  end
end
