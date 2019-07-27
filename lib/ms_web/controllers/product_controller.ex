defmodule MsWeb.ProductController do
  use MsWeb, :controller

  alias Ms.InventoryManagement
  alias Ms.InventoryManagement.Product
  alias Ms.CacheManagement

  action_fallback MsWeb.FallbackController

  def index(conn, _params) do
    products = InventoryManagement.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- InventoryManagement.create_product(product_params) do
      CacheManagement.clean_product_cache()

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = InventoryManagement.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = InventoryManagement.get_product!(id)

    with {:ok, %Product{} = product} <-
           InventoryManagement.update_product(product, product_params) do
      CacheManagement.clean_product_cache()
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = InventoryManagement.get_product!(id)

    with {:ok, %Product{}} <- InventoryManagement.delete_product(product) do
      CacheManagement.clean_product_cache()
      send_resp(conn, :no_content, "")
    end
  end

  def search(conn, %{"term" => term}) do
    # First, we try to get products from the cache
    products = CacheManagement.get_products(term)

    if products == [] do
      # If cache is empty, we fetch from database and write to cache
      products = InventoryManagement.search_product(term)
      CacheManagement.put_product(term, products)
    end

    # Load value again from cache
    products = CacheManagement.get_products(term)
    render(conn, "index.json", products: products)
  end
end
