defmodule MsWeb.OrderController do
  use MsWeb, :controller

  alias Ms.OrderManagement
  alias Ms.OrderManagement.Order

  action_fallback MsWeb.FallbackController

  def index(conn, _params) do
    orders = OrderManagement.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{} = order} <- OrderManagement.create_order(order_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.order_path(conn, :show, order))
      |> render("show.json", order: order)
    end
  end

  def show(conn, %{"id" => id}) do
    order = OrderManagement.get_order!(id)
    render(conn, "show.json", order: order)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = OrderManagement.get_order!(id)

    with {:ok, %Order{} = order} <- OrderManagement.update_order(order, order_params) do
      render(conn, "show.json", order: order)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = OrderManagement.get_order!(id)

    with {:ok, %Order{}} <- OrderManagement.delete_order(order) do
      send_resp(conn, :no_content, "")
    end
  end
end
