defmodule Ms.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :creationDate, :utc_datetime
      add :message, :string
      add :details, :map
      add :customer, references(:customers, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:customer])
  end
end
