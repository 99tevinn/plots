defmodule PlotWeb.Plots.Plot do
  use PlotWeb, :live_view

  alias Plot.Repo
  alias Plot.SavePlots
  alias Plot.Plot


  def mount(_params, _session, socket) do
    user_options = SavePlots.list_user_options()

    {:ok,
     socket
     |> assign(:user_options, user_options)
     |> assign(:plots, [])
     |> assign(:live_action, :new)
     |> blank_plot_assigns(:new)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("validate", %{"plot" => plot_params}, socket) do
    changeset =
      case socket.assigns.form_mode do
        :edit -> Plot.changeset(socket.assigns.plot, plot_params)
        :new -> Plot.changeset(%Plot{}, plot_params)
      end
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, form: to_form(changeset))}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    case SavePlots.save_plot(plot_params) do
      {:ok, plot} ->
        plot = Repo.preload(plot, :user)
        changeset = Plot.changeset(plot, %{})

        {:noreply,
         socket
         |> put_flash(:info, "Plot created successfully.")
         |> assign(:plot, plot)
         |> assign(:form_mode, :show)
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  defp blank_plot_assigns(socket, mode) do
    plot = %Plot{}
    changeset = Plot.changeset(plot, %{})

    socket
    |> assign(:plot, plot)
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
    |> assign(:form_mode, mode)
  end

  defp apply_action(socket, :new, _params) do
    blank_plot_assigns(socket, :new)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case SavePlots.get_plot(id) do
      nil ->
        socket
        |> put_flash(:error, "Plot not found.")
        |> blank_plot_assigns(:edit)

      plot ->
        changeset = Plot.changeset(plot, %{})

        socket
        |> assign(:plot, plot)
        |> assign(:changeset, changeset)
        |> assign(:form, to_form(changeset))
        |> assign(:form_mode, :edit)
    end
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    case SavePlots.get_plot(id) do
      nil ->
        socket
        |> put_flash(:error, "Plot not found.")
        |> blank_plot_assigns(:show)

      plot ->
        changeset = Plot.changeset(plot, %{})

        socket
        |> assign(:plot, plot)
        |> assign(:changeset, changeset)
        |> assign(:form, to_form(changeset))
        |> assign(:form_mode, :show)
    end
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    case SavePlots.get_plot(id) do
      nil ->
        socket
        |> put_flash(:error, "Plot not found.")
        |> blank_plot_assigns(:delete)

      plot ->
        changeset = Plot.changeset(plot, %{})

        socket
        |> assign(:plot, plot)
        |> assign(:changeset, changeset)
        |> assign(:form, to_form(changeset))
        |> assign(:form_mode, :delete)
    end
  end
end
