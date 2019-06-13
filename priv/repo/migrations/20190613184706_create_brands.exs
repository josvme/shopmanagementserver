defmodule Ms.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string
      add :details, :map

      timestamps()
    end

  end
end
