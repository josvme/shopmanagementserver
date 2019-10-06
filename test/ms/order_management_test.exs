defmodule Ms.OrderManagementTest do
  use Ms.DataCase

  alias Ms.OrderManagement
  alias Ms.InventoryManagement

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

  @valid_attrs_product %{name: "some name", price: 120.5, stock: 42, tax: 120.5}

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(@valid_attrs_product)
      |> InventoryManagement.create_product()

    product
  end

  describe "orders" do
    alias Ms.OrderManagement.Order

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert OrderManagement.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OrderManagement.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = OrderManagement.create_order(@valid_attrs_order)
      assert order.creation_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert order.details == %{}
      assert order.message == "some message"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderManagement.create_order(@invalid_attrs_order)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = OrderManagement.update_order(order, @update_attrs_order)
      assert order.creation_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert order.details == %{}
      assert order.message == "some updated message"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderManagement.update_order(order, @invalid_attrs_order)
      assert order == OrderManagement.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = OrderManagement.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> OrderManagement.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = OrderManagement.change_order(order)
    end
  end

  describe "order_items" do
    alias Ms.OrderManagement.OrderItem

    @valid_attrs %{"amount" => 42, "unit_price" => 120.5}
    @update_attrs %{"amount" => 43, "unit_price" => 456.7}
    @invalid_attrs %{"amount" => nil, "unit_price" => nil}

    def order_item_fixture(attrs \\ %{}) do
      order = order_fixture()
      product = product_fixture()
      valid_attrs = Map.merge(@valid_attrs, %{"order_id" => order.id, "product_id" => product.id})
      {:ok, order_item} =
        attrs
        |> Enum.into(valid_attrs)
        |> OrderManagement.create_order_item()

      order_item
    end

    test "list_order_items/0 returns all order_items" do
      order_item = order_item_fixture()
      assert OrderManagement.list_order_items() == [order_item]
    end

    test "get_order_item!/1 returns the order_item with given id" do
      order_item = order_item_fixture()
      assert OrderManagement.get_order_item!(order_item.id) == order_item
    end

    test "create_order_item/1 with valid data creates a order_item" do
      order = order_fixture()
      product = product_fixture()
      valid_attrs = Map.merge(@valid_attrs, %{"order_id" => order.id, "product_id" => product.id})
      assert {:ok, %OrderItem{} = order_item} = OrderManagement.create_order_item(valid_attrs)
      assert order_item.amount == 42
      assert order_item.unit_price == 120.5
    end

    test "create_order_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderManagement.create_order_item(@invalid_attrs)
    end

    test "update_order_item/2 with valid data updates the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{} = order_item} = OrderManagement.update_order_item(order_item, @update_attrs)
      assert order_item.amount == 43
      assert order_item.unit_price == 456.7
    end

    test "update_order_item/2 with invalid data returns error changeset" do
      order_item = order_item_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderManagement.update_order_item(order_item, @invalid_attrs)
      assert order_item == OrderManagement.get_order_item!(order_item.id)
    end

    test "delete_order_item/1 deletes the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{}} = OrderManagement.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> OrderManagement.get_order_item!(order_item.id) end
    end

    test "change_order_item/1 returns a order_item changeset" do
      order_item = order_item_fixture()
      assert %Ecto.Changeset{} = OrderManagement.change_order_item(order_item)
    end
  end
end
