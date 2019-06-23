defmodule MsWeb.ProductView do
  use MsWeb, :view
  alias MsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{product: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      price: product.price,
      stock: product.stock,
      name: product.name,
      tax: product.tax}
  end
end
