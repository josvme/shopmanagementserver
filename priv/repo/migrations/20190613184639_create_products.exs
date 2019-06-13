defmodule Ms.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :price, :float
      add :stock, :integer
      add :name, :string
      add :tax, :float

      timestamps()
    end

  end
end
