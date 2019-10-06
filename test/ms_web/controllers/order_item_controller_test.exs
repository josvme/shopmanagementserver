defmodule MsWeb.OrderItemControllerTest do
  use MsWeb.ConnCase

  alias Ms.OrderManagement
  alias Ms.InventoryManagement
  alias Ms.OrderManagement.OrderItem

  @valid_attrs_order %{
    "creation_date" => "2010-04-17T14:00:00Z",
    "details" => %{},
    "message" => "some message",
    "order_items" => []
  }
  @update_attrs_order %{
    "creation_date" => "2011-05-18T15:01:01Z",
    "details" => %{},
    "message" => "some updated message",
    "order_items" => []
  }
  @invalid_attrs_order %{"creation_date" => nil, "details" => nil, "message" => nil}

  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(@valid_attrs_order)
      |> OrderManagement.create_order()

    order
  end

  @create_attrs_product %{
    name: "some name",
    price: 120.5,
    stock: 42,
    tax: 120.5
  }
  def product_fixture() do
    {:ok, product} = InventoryManagement.create_product(@create_attrs_product)
    product
  end

  @create_attrs_order_item %{
    "amount" => 42,
    "unit_price" => 120.5
  }

  @update_attrs_order_item %{
    "amount" => 43,
    "unit_price" => 456.7
  }

  @invalid_attrs_order_item %{amount: nil, unit_price: nil}

  def order_item_fixture() do
    order = order_fixture()
    product = product_fixture()
    create_attrs_order_item = Map.put(@create_attrs_order_item, "order_id", order.id)
    create_attrs_order_item = Map.put(create_attrs_order_item, "product_id", product.id)
    {:ok, order_item} = OrderManagement.create_order_item(create_attrs_order_item)
    order_item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all order_items", %{conn: conn} do
      conn = get(conn, Routes.order_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create order_item" do
    setup [:create_product, :create_order]
    test "renders order_item when data is valid", %{conn: conn, product: product, order: order} do
      create_attrs = Map.merge(@create_attrs_order_item, %{"order_id": order.id, "product_id": product.id})
      conn = post(conn, Routes.order_item_path(conn, :create), order_item: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.order_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 42,
               "unit_price" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_item_path(conn, :create), order_item: @invalid_attrs_order_item)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update order_item" do
    setup [:create_order_item]

    test "renders order_item when data is valid", %{conn: conn, order_item: %OrderItem{id: id} = order_item} do
      conn = put(conn, Routes.order_item_path(conn, :update, order_item), order_item: @update_attrs_order_item)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.order_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 43,
               "unit_price" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, order_item: order_item} do
      conn = put(conn, Routes.order_item_path(conn, :update, order_item), order_item: @invalid_attrs_order_item)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete order_item" do
    setup [:create_order_item]

    test "deletes chosen order_item", %{conn: conn, order_item: order_item} do
      conn = delete(conn, Routes.order_item_path(conn, :delete, order_item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.order_item_path(conn, :show, order_item))
      end
    end
  end

  defp create_order_item(_) do
    order_item = order_item_fixture()
    {:ok, order_item: order_item}
  end

  defp create_order(_) do
    order= order_fixture()
    {:ok, order: order}
  end

  defp create_product(_) do
    product = product_fixture()
    {:ok, product: product}
  end
end
