defmodule PlotWeb.Users.User do
  use PlotWeb, :live_view

  alias Plot.Users
  alias Plot.SavePlots
  alias Plot.Repo

  def mount(params, _session, socket) do
    redirect_to = Map.get(params, "redirect_to")

    socket =
      socket
      |> assign(:redirect_to, redirect_to)
      |> assign(:user, nil)
      |> assign(:plots, [])
      |> assign(:changeset, nil)
      |> assign(:form, nil)

    case socket.assigns.live_action do
      :login ->
        changeset = Users.changeset(%Users{}, %{})
        {:ok, assign_form(socket, changeset)}

      :logout ->
        {:ok, redirect(socket, to: ~p"/users/login")}

      :show ->
        case SavePlots.get_user(params["id"]) do
          nil ->
            {:ok, redirect(socket, to: ~p"/users/login")}

          user ->
            user = Repo.preload(user, :plots)
            {:ok, assign(socket, user: user, plots: user.plots) |> redirect(to: ~p"/users/#{user.id}")}
        end
      :edit ->
        case SavePlots.get_user(params["id"]) do
          nil ->
            {:ok, redirect(socket, to: ~p"/users/login")}
          user ->
            changeset = Users.changeset(user, %{})
            {:ok, assign_form(socket, changeset)}
        end
    end
  end

  defp assign_form(socket, changeset) do
    IO.inspect(socket.assigns.form, label: "Assigned Form")

    socket
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset, as: :user))
  end

  @spec handle_event(<<_::48, _::_*16>>, map(), map()) :: {:noreply, map()}
  def handle_event("submit", %{"user" => %{"email" => email, "password" => password}}, socket) do
      IO.inspect({email, password}, label: "Login Attempt")
    case Users.authenticate_user(email, password) |> IO.inspect() do
      {:ok, user} ->
        socket =
          socket
          |> assign(:user, user)
          |> put_flash(:info, "Login successful.")

        redirect_to = socket.assigns.redirect_to || ~p"/"
        {:noreply, redirect(socket, to: redirect_to)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Login failed: #{reason}")}
    end
  end

  def handle_event("logout", _params, socket) do
    {:noreply, redirect(socket, to: ~p"/users/login")}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %Users{}
      |> Users.changeset(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_info(:refresh_plots, socket) do
    user = SavePlots.get_user(socket.assigns.user.id) |> Repo.preload(:plots)
    {:noreply, assign(socket, plots: user.plots)}
  end

  def handle_info({:refresh_plots, updated_plot}, socket) do
    updated_plots =
      socket.assigns.plots
      |> Enum.reject(&(&1.id == updated_plot.id))
      |> List.insert_at(0, updated_plot)

    {:noreply, assign(socket, plots: updated_plots)}
  end
end
