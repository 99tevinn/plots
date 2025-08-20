defmodule Plot.SavePlots do
  alias Plot.Users
  alias Plot.Repo
  alias Plot.Plot
  import Ecto.Query, warn: false


  def save_plot(attrs) do
    %Plot{}
    |> Plot.changeset(attrs)
    |> Repo.insert()
  end

  def update_plot(id, attrs) do
    plot = Repo.get!(Plot, id)

    plot
    |> Plot.changeset(attrs)
    |> Repo.update()
  end

  def delete_plot(id) do
    plot = Repo.get!(Plot, id)
    Repo.delete(plot)
  end

  def get_plot(id) do
    Repo.get(Plot, id)
  end

  def save_user(attrs) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

  def list_user_plots(user_id) do
    Repo.all(from p in Plot, where: p.user_id == ^user_id)
  end

  def get_user(id) do
    Repo.get(Users, id)
    |> Repo.preload(:plots)
  end

  def list_user_options do
    Repo.all(Users)
    |> Enum.map(&{&1.name, &1.id})
  end

  def update_user(id, attrs) do
    user = Repo.get!(Users, id)

    user
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) do
    user = Repo.get!(Users, id)
    Repo.delete(user)
  end
end
