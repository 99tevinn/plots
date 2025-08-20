defmodule Plot.Repo do
  use Ecto.Repo,
    otp_app: :plot,
    adapter: Ecto.Adapters.Postgres
end
