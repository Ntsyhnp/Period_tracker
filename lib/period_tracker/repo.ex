defmodule PeriodTracker.Repo do
  use Ecto.Repo,
    otp_app: :period_tracker,
    adapter: Ecto.Adapters.Postgres
end
