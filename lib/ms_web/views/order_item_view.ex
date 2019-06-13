defmodule MsWeb.OrderItemView do
  use MsWeb, :view
  alias MsWeb.OrderItemView

  def render("index.json", %{order_items: order_items}) do
    %{data: render_many(order_items, OrderItemView, "order_item.json")}
  end

  def render("show.json", %{order_item: order_item}) do
    %{data: render_one(order_item, OrderItemView, "order_item.json")}
  end

  def render("order_item.json", %{order_item: order_item}) do
    %{id: order_item.id,
      amount: order_item.amount,
      unitPrice: order_item.unitPrice}
  end
end
