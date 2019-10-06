defmodule MsWeb.OrderControllerTest do
  use MsWeb.ConnCase

  alias Ms.OrderManagement
  alias Ms.InventoryManagement
  alias Ms.OrderManagement.Order

  @create_attrs %{
    "creation_date" => "2010-04-17T14:00:00Z",
   "details" => %{},
   "message" => "some message",
   "order_items" => []
  }
  @update_attrs %{
    "creation_date" => "2011-05-18T15:01:01Z",
    "details" => %{},
    "message" => "some updated message",
    "order_items" => []
  }
  @invalid_attrs %{"creation_date" => nil, "details" => nil, "message" => nil}

  def fixture(:order) do
    {:ok, order} = OrderManagement.create_order(@create_attrs)
    order
  end

  @create_attrs_product %{
    "name" => "some name",
    "price" => 120.5,
    "stock" =>  42,
    "tax" => 120.5
  }

  def fixture(:product) do
    {:ok, product} = InventoryManagement.create_product(@create_attrs_product)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all orders", %{conn: conn} do
      conn = get(conn, Routes.order_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create order" do
    setup [:create_product]
    test "renders order when data is valid", %{conn: conn, product: product} do
      order_items = %{"order_items" => [%{"amount" => 42, "unit_price" => 120.5, "product_id" => product.id}]}
      conn = post(
        conn,
        Routes.order_path(conn, :create),
        order: Map.merge(@create_attrs, order_items)
      )
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.order_path(conn, :show, id))

      assert %{
               "id" => id,
               "creation_date" => "2010-04-17T14:00:00Z",
               "details" => %{},
               "message" => "some message",
               "order_items" => [%{"amount" => 42, "unit_price" => 120.5, "order_id" => id}]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update order" do
    setup [:create_order]

    test "renders order when data is valid", %{conn: conn, order: %Order{id: id} = order} do
      conn = put(conn, Routes.order_path(conn, :update, order), order: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.order_path(conn, :show, id))

      assert %{
               "id" => id,
               "creation_date" => "2011-05-18T15:01:01Z",
               "details" => %{},
               "message" => "some updated message"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, order: order} do
      conn = put(conn, Routes.order_path(conn, :update, order), order: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete order" do
    setup [:create_order]

    test "deletes chosen order", %{conn: conn, order: order} do
      conn = delete(conn, Routes.order_path(conn, :delete, order))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.order_path(conn, :show, order))
      end
    end
  end

  defp create_order(_) do
    order = fixture(:order)
    {:ok, order: order}
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
