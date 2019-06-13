defmodule Ms.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string
      add :phone, :string
      add :pincode, :string
      add :details, :map

      timestamps()
    end

  end
end
