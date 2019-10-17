defmodule Ms.Release do
  """
  Release script for running migrations. migrate function runs all migrations
  """
  @app :ms

  def migrate do
    # Get all repos and run ecto migrate
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  # loads all repos for our app
  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
