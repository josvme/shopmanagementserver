defmodule Ms.Repo.Migrations.AddProductDetails do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :brand_id, references(:brands, on_delete: :delete_all)
      add :details, :map
    end
  end
end
