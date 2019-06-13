defmodule MsWeb.CustomerController do
  use MsWeb, :controller

  alias Ms.CustomerManagement
  alias Ms.CustomerManagement.Customer

  action_fallback MsWeb.FallbackController

  def index(conn, _params) do
    customers = CustomerManagement.list_customers()
    render(conn, "index.json", customers: customers)
  end

  def create(conn, %{"customer" => customer_params}) do
    with {:ok, %Customer{} = customer} <- CustomerManagement.create_customer(customer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.customer_path(conn, :show, customer))
      |> render("show.json", customer: customer)
    end
  end

  def show(conn, %{"id" => id}) do
    customer = CustomerManagement.get_customer!(id)
    render(conn, "show.json", customer: customer)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = CustomerManagement.get_customer!(id)

    with {:ok, %Customer{} = customer} <- CustomerManagement.update_customer(customer, customer_params) do
      render(conn, "show.json", customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = CustomerManagement.get_customer!(id)

    with {:ok, %Customer{}} <- CustomerManagement.delete_customer(customer) do
      send_resp(conn, :no_content, "")
    end
  end
end
