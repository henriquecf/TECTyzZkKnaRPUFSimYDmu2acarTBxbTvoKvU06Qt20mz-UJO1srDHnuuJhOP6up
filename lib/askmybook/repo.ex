defmodule Askmybook.Repo do
  use Ecto.Repo,
    otp_app: :askmybook,
    adapter: Ecto.Adapters.Postgres
end
