defmodule MsWeb.BrandController do
  use MsWeb, :controller

  alias Ms.InventoryManagement
  alias Ms.InventoryManagement.Brand

  action_fallback MsWeb.FallbackController

  def index(conn, _params) do
    brands = InventoryManagement.list_brands()
    render(conn, "index.json", brands: brands)
  end

  def create(conn, %{"brand" => brand_params}) do
    with {:ok, %Brand{} = brand} <- InventoryManagement.create_brand(brand_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.brand_path(conn, :show, brand))
      |> render("show.json", brand: brand)
    end
  end

  def show(conn, %{"id" => id}) do
    brand = InventoryManagement.get_brand!(id)
    render(conn, "show.json", brand: brand)
  end

  def update(conn, %{"id" => id, "brand" => brand_params}) do
    brand = InventoryManagement.get_brand!(id)

    with {:ok, %Brand{} = brand} <- InventoryManagement.update_brand(brand, brand_params) do
      render(conn, "show.json", brand: brand)
    end
  end

  def delete(conn, %{"id" => id}) do
    brand = InventoryManagement.get_brand!(id)

    with {:ok, %Brand{}} <- InventoryManagement.delete_brand(brand) do
      send_resp(conn, :no_content, "")
    end
  end
end
