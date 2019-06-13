defmodule Ms.DeliveryManagementTest do
  use Ms.DataCase

  alias Ms.DeliveryManagement

  describe "deliveries" do
    alias Ms.DeliveryManagement.Delivery

    @valid_attrs %{address: %{}, details: %{}, fare: 120.5}
    @update_attrs %{address: %{}, details: %{}, fare: 456.7}
    @invalid_attrs %{address: nil, details: nil, fare: nil}

    def delivery_fixture(attrs \\ %{}) do
      {:ok, delivery} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DeliveryManagement.create_delivery()

      delivery
    end

    test "list_deliveries/0 returns all deliveries" do
      delivery = delivery_fixture()
      assert DeliveryManagement.list_deliveries() == [delivery]
    end

    test "get_delivery!/1 returns the delivery with given id" do
      delivery = delivery_fixture()
      assert DeliveryManagement.get_delivery!(delivery.id) == delivery
    end

    test "create_delivery/1 with valid data creates a delivery" do
      assert {:ok, %Delivery{} = delivery} = DeliveryManagement.create_delivery(@valid_attrs)
      assert delivery.address == %{}
      assert delivery.details == %{}
      assert delivery.fare == 120.5
    end

    test "create_delivery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DeliveryManagement.create_delivery(@invalid_attrs)
    end

    test "update_delivery/2 with valid data updates the delivery" do
      delivery = delivery_fixture()
      assert {:ok, %Delivery{} = delivery} = DeliveryManagement.update_delivery(delivery, @update_attrs)
      assert delivery.address == %{}
      assert delivery.details == %{}
      assert delivery.fare == 456.7
    end

    test "update_delivery/2 with invalid data returns error changeset" do
      delivery = delivery_fixture()
      assert {:error, %Ecto.Changeset{}} = DeliveryManagement.update_delivery(delivery, @invalid_attrs)
      assert delivery == DeliveryManagement.get_delivery!(delivery.id)
    end

    test "delete_delivery/1 deletes the delivery" do
      delivery = delivery_fixture()
      assert {:ok, %Delivery{}} = DeliveryManagement.delete_delivery(delivery)
      assert_raise Ecto.NoResultsError, fn -> DeliveryManagement.get_delivery!(delivery.id) end
    end

    test "change_delivery/1 returns a delivery changeset" do
      delivery = delivery_fixture()
      assert %Ecto.Changeset{} = DeliveryManagement.change_delivery(delivery)
    end
  end
end
