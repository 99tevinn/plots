defmodule PlotWeb.Register.Register do
  use PlotWeb, :live_view

  alias Plot.Users
  alias Plot.SavePlots

  def mount(_params, _session, socket) do
    changeset = Users.changeset(%Users{}, %{})

    {:ok, assign(socket, form: to_form(changeset, as: :user))}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign(:redirect_to, Map.get(params, "redirect_to"))
      |> assign(:live_action, Map.get(params, "live_action", :new))

    {:noreply, socket}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = Users.changeset(%Users{}, params) |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: :user))}
  end

  def handle_event("submit", %{"user" => params}, socket) do

    case SavePlots.save_user(params) do
      {:ok, user} ->
        socket =
          socket
          |> assign(:user, user)
          |> put_flash(:info, "Registration successful.")
          |> redirect(to: ~p"/users/login")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
