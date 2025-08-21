defmodule Plot.SavePlots do
  @moduledoc """
  Context module for managing Plot and User resources.
  Provides CRUD operations and preload-aware accessors.
  """

  alias Plot.{Repo, Plot, Users}
  import Ecto.Query, warn: false

  # -- PLOTS --

  @doc "Creates a new plot and preloads its user association."
  @spec save_plot(map()) :: {:ok, Plot.t()} | {:error, Ecto.Changeset.t()}
  def save_plot(attrs) do
    %Plot{}
    |> Plot.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, plot} -> {:ok, Repo.preload(plot, :user)}
      error -> error
    end
  end

  @doc "Updates an existing plot and preloads its user association."
  @spec update_plot(integer(), map()) :: {:ok, Plot.t()} | {:error, Ecto.Changeset.t()}
  def update_plot(id, attrs) do
    plot = Repo.get!(Plot, id)

    plot
    |> Plot.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_plot} -> {:ok, Repo.preload(updated_plot, :user)}
      error -> error
    end
  end

  @doc "Deletes a plot by ID."
  @spec delete_plot(integer()) :: {:ok, Plot.t()} | {:error, Ecto.Changeset.t()}
  def delete_plot(id) do
    plot = Repo.get!(Plot, id)
    Repo.delete(plot)
  end

  @doc "Fetches a plot by ID with optional preloads (defaults to :user)."
  @spec get_plot(integer(), list(atom())) :: Plot.t() | nil
  def get_plot(id, preloads \\ [:user]) do
    Repo.get(Plot, id)
    |> Repo.preload(preloads)
  end

  @doc "Lists all plots with optional preloads."
  @spec list_plots(list(atom())) :: [Plot.t()]
  def list_plots(preloads \\ [:user]) do
    Repo.all(Plot)
    |> Repo.preload(preloads)
  end

  @doc "Lists all plots for a given user ID, with optional preloads."
  @spec list_user_plots(integer(), list(atom())) :: [Plot.t()]
  def list_user_plots(user_id, preloads \\ []) do
    Repo.all(from p in Plot, where: p.user_id == ^user_id)
    |> Repo.preload(preloads)
  end

  # -- USERS --

  @doc "Creates a new user."
  @spec save_user(map()) :: {:ok, Users.t()} | {:error, Ecto.Changeset.t()}
  def save_user(attrs) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Updates an existing user."
  @spec update_user(integer(), map()) :: {:ok, Users.t()} | {:error, Ecto.Changeset.t()}
  def update_user(id, attrs) do
    user = Repo.get!(Users, id)

    user
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  @doc "Deletes a user by ID."
  @spec delete_user(integer()) :: {:ok, Users.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(id) do
    user = Repo.get!(Users, id)
    Repo.delete(user)
  end

  @doc "Fetches a user by ID with optional preloads (defaults to :plots)."
  @spec get_user(integer(), list(atom())) :: Users.t() | nil
  def get_user(id, preloads \\ [:plots]) do
    Repo.get(Users, id)
    |> Repo.preload(preloads)
  end

  @doc "Lists all users as {name, id} tuples for form selects."
  @spec list_user_options() :: [{String.t(), integer()}]
  def list_user_options do
    Repo.all(Users)
    |> Enum.map(&{&1.name, &1.id})
  end
end
