defmodule Plot.SavePlots do
  alias Plot.Users
  alias Plot.Repo
  alias Plot.Plot


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

  def get_user(id) do
    Repo.get(User, id)
    |> Repo.preload(:plots)
  end

  def update_user(id, attrs) do
    user = Repo.get!(User, id)

    user
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) do
    user = Repo.get!(User, id)
    Repo.delete(user)
  end
end
