defmodule Ms.Repo.Migrations.RenameFieldsForForeignKeys do
  use Ecto.Migration

  def change do
    rename table("order_items"), :order, to: :order_id
    rename table("order_items"), :product, to: :product_id
    rename table("orders"), :customer, to: :customer_id
    rename table("deliveries"), :order_item, to: :order_item_id
    rename table("deliveries"), :customer, to: :customer_id
  end
end
