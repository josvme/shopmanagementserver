defmodule MsWeb.CustomerView do
  use MsWeb, :view
  alias MsWeb.CustomerView

  def render("index.json", %{customers: customers}) do
    %{data: render_many(customers, CustomerView, "customer.json")}
  end

  def render("show.json", %{customer: customer}) do
    %{data: render_one(customer, CustomerView, "customer.json")}
  end

  def render("customer.json", %{customer: customer}) do
    %{id: customer.id,
      name: customer.name,
      phone: customer.phone,
      pincode: customer.pincode,
      details: customer.details}
  end
end
