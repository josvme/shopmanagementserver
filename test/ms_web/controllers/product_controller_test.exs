defmodule MsWeb.ProductControllerTest do
  use MsWeb.ConnCase

  alias Ms.InventoryManagement
  alias Ms.InventoryManagement.Product

  @create_attrs %{
    name: "some name",
    price: 120.5,
    stock: 42,
    tax: 120.5
  }
  @update_attrs %{
    name: "some updated name",
    price: 456.7,
    stock: 43,
    tax: 456.7
  }
  @invalid_attrs %{name: nil, price: nil, stock: nil, tax: nil}

  def fixture(:product) do
    {:ok, product} = InventoryManagement.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.product_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "price" => 120.5,
               "stock" => 42,
               "tax" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.product_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "price" => 456.7,
               "stock" => 43,
               "tax" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, Routes.product_path(conn, :delete, product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_path(conn, :show, product))
      end
    end
  end

  describe "search products" do
    setup [:create_product]

    test "searches all products containing string", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :search, %{term: "ome"}))
      assert [%{"name" => "some name"}] = json_response(conn, 200)["data"]
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
