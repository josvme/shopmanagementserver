defmodule MsWeb.DeliveryView do
  use MsWeb, :view
  alias MsWeb.DeliveryView

  def render("index.json", %{deliveries: deliveries}) do
    %{data: render_many(deliveries, DeliveryView, "delivery.json")}
  end

  def render("show.json", %{delivery: delivery}) do
    %{data: render_one(delivery, DeliveryView, "delivery.json")}
  end

  def render("delivery.json", %{delivery: delivery}) do
    %{id: delivery.id,
      fare: delivery.fare,
      address: delivery.address,
      details: delivery.details}
  end
end
