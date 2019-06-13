defmodule Ms.Repo do
  use Ecto.Repo,
    otp_app: :ms,
    adapter: Ecto.Adapters.Postgres
end
