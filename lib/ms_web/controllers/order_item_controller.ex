defmodule MsWeb.OrderItemController do
  use MsWeb, :controller

  alias Ms.OrderManagement
  alias Ms.OrderManagement.OrderItem

  action_fallback MsWeb.FallbackController

  def index(conn, _params) do
    order_items = OrderManagement.list_order_items()
    render(conn, "index.json", order_items: order_items)
  end

  def create(conn, %{"order_item" => order_item_params}) do
    with {:ok, %OrderItem{} = order_item} <- OrderManagement.create_order_item(order_item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.order_item_path(conn, :show, order_item))
      |> render("show.json", order_item: order_item)
    end
  end

  def show(conn, %{"id" => id}) do
    order_item = OrderManagement.get_order_item!(id)
    render(conn, "show.json", order_item: order_item)
  end

  def update(conn, %{"id" => id, "order_item" => order_item_params}) do
    order_item = OrderManagement.get_order_item!(id)

    with {:ok, %OrderItem{} = order_item} <- OrderManagement.update_order_item(order_item, order_item_params) do
      render(conn, "show.json", order_item: order_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item = OrderManagement.get_order_item!(id)

    with {:ok, %OrderItem{}} <- OrderManagement.delete_order_item(order_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
