defmodule MsWeb.Router do
  use MsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MsWeb do
    pipe_through :api

    scope "/v1" do
      get "/products/search", ProductController, :search
      get "/customers/search", CustomerController, :search
      resources "/products", ProductController
      resources "/brands", BrandController
      resources "/orders", OrderController
      resources "/customers", CustomerController
      resources "/order_items", OrderItemController
      resources "/deliveries", DeliveryController
    end
  end
end
