defmodule Ms.InventoryManagementTest do
  use Ms.DataCase

  alias Ms.InventoryManagement

  describe "products" do
    alias Ms.InventoryManagement.Product

    @valid_attrs %{name: "some name", price: 120.5, stock: 42, tax: 120.5}
    @update_attrs %{name: "some updated name", price: 456.7, stock: 43, tax: 456.7}
    @invalid_attrs %{name: nil, price: nil, stock: nil, tax: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> InventoryManagement.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert InventoryManagement.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert InventoryManagement.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = InventoryManagement.create_product(@valid_attrs)
      assert product.name == "some name"
      assert product.price == 120.5
      assert product.stock == 42
      assert product.tax == 120.5
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InventoryManagement.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      assert {:ok, %Product{} = product} =
               InventoryManagement.update_product(product, @update_attrs)

      assert product.name == "some updated name"
      assert product.price == 456.7
      assert product.stock == 43
      assert product.tax == 456.7
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()

      assert {:error, %Ecto.Changeset{}} =
               InventoryManagement.update_product(product, @invalid_attrs)

      assert product == InventoryManagement.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = InventoryManagement.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> InventoryManagement.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = InventoryManagement.change_product(product)
    end
  end

  describe "brands" do
    alias Ms.InventoryManagement.Brand

    @valid_attrs %{details: %{}, name: "some name"}
    @update_attrs %{details: %{}, name: "some updated name"}
    @invalid_attrs %{details: nil, name: nil}

    def brand_fixture(attrs \\ %{}) do
      {:ok, brand} =
        attrs
        |> Enum.into(@valid_attrs)
        |> InventoryManagement.create_brand()

      brand
    end

    test "list_brands/0 returns all brands" do
      brand = brand_fixture()
      assert InventoryManagement.list_brands() == [brand]
    end

    test "get_brand!/1 returns the brand with given id" do
      brand = brand_fixture()
      assert InventoryManagement.get_brand!(brand.id) == brand
    end

    test "create_brand/1 with valid data creates a brand" do
      assert {:ok, %Brand{} = brand} = InventoryManagement.create_brand(@valid_attrs)
      assert brand.details == %{}
      assert brand.name == "some name"
    end

    test "create_brand/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InventoryManagement.create_brand(@invalid_attrs)
    end

    test "update_brand/2 with valid data updates the brand" do
      brand = brand_fixture()
      assert {:ok, %Brand{} = brand} = InventoryManagement.update_brand(brand, @update_attrs)
      assert brand.details == %{}
      assert brand.name == "some updated name"
    end

    test "update_brand/2 with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = InventoryManagement.update_brand(brand, @invalid_attrs)
      assert brand == InventoryManagement.get_brand!(brand.id)
    end

    test "delete_brand/1 deletes the brand" do
      brand = brand_fixture()
      assert {:ok, %Brand{}} = InventoryManagement.delete_brand(brand)
      assert_raise Ecto.NoResultsError, fn -> InventoryManagement.get_brand!(brand.id) end
    end

    test "change_brand/1 returns a brand changeset" do
      brand = brand_fixture()
      assert %Ecto.Changeset{} = InventoryManagement.change_brand(brand)
    end
  end
end
