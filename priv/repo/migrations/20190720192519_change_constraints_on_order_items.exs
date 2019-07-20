defmodule Ms.Repo.Migrations.ChangeConstraintsOnOrderItems do
  use Ecto.Migration

  def change do
    drop constraint("order_items", "order_items_product_fkey")
    drop constraint("order_items", "order_items_order_fkey")

    alter table(:order_items) do
      modify(:product_id, references(:products, on_delete: :delete_all))
      modify(:order_id, references(:orders, on_delete: :delete_all))
    end
  end
end
