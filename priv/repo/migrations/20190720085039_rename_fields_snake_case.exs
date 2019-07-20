defmodule Ms.Repo.Migrations.RenameFieldsSnakeCase do
  use Ecto.Migration

  def change do
    rename table("orders"), :creationDate, to: :creation_date
    rename table("order_items"), :unitPrice, to: :unit_price
    rename table("deliveries"), :orderitem, to: :order_item
  end
end
