defmodule MsWeb.DeliveryControllerTest do
  use MsWeb.ConnCase

  alias Ms.DeliveryManagement
  alias Ms.DeliveryManagement.Delivery

  @create_attrs %{
    address: %{},
    details: %{},
    fare: 120.5
  }
  @update_attrs %{
    address: %{},
    details: %{},
    fare: 456.7
  }
  @invalid_attrs %{address: nil, details: nil, fare: nil}

  def fixture(:delivery) do
    {:ok, delivery} = DeliveryManagement.create_delivery(@create_attrs)
    delivery
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all deliveries", %{conn: conn} do
      conn = get(conn, Routes.delivery_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create delivery" do
    test "renders delivery when data is valid", %{conn: conn} do
      conn = post(conn, Routes.delivery_path(conn, :create), delivery: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.delivery_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => %{},
               "details" => %{},
               "fare" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.delivery_path(conn, :create), delivery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update delivery" do
    setup [:create_delivery]

    test "renders delivery when data is valid", %{conn: conn, delivery: %Delivery{id: id} = delivery} do
      conn = put(conn, Routes.delivery_path(conn, :update, delivery), delivery: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.delivery_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => %{},
               "details" => %{},
               "fare" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, delivery: delivery} do
      conn = put(conn, Routes.delivery_path(conn, :update, delivery), delivery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete delivery" do
    setup [:create_delivery]

    test "deletes chosen delivery", %{conn: conn, delivery: delivery} do
      conn = delete(conn, Routes.delivery_path(conn, :delete, delivery))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.delivery_path(conn, :show, delivery))
      end
    end
  end

  defp create_delivery(_) do
    delivery = fixture(:delivery)
    {:ok, delivery: delivery}
  end
end
