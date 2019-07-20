defmodule MsWeb.OrderView do
  use MsWeb, :view
  alias MsWeb.OrderView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{id: order.id,
      creation_date: order.creation_date,
      message: order.message,
      details: order.details}
  end
end
