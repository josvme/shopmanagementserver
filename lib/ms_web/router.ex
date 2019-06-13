defmodule MsWeb.Router do
  use MsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MsWeb do
    pipe_through :api
  end
end
