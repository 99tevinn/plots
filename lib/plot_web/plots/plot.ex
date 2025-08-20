defmodule PlotWeb.Plots.Plot do
  use PlotWeb, :live_view

  alias Plot.SavePlots
  alias Plot.Plot

  def mount(_params, _session, socket) do
    plot = %Plot{}
    changeset = Plot.changeset(plot, %{})

    {:ok,
     socket
     |> assign(:plot, plot)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))
     |> assign(:plots, [])
     |> assign(:live_action, :new)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("validate", %{"plot" => plot_params}, socket) do
    changeset =
      %Plot{}
      |> Plot.changeset(plot_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("submit", %{"plot" => plot_params}, socket) do
    case SavePlots.save_plot(plot_params) do
      {:ok, plot} ->
        changeset = Plot.changeset(plot, %{})

        {:noreply,
         socket
         |> put_flash(:info, "Plot created successfully.")
         |> assign(:plot, plot)
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  defp apply_action(socket, :index, _params), do: socket

  defp apply_action(socket, :new, _params) do
    plot = %Plot{}
    changeset = Plot.changeset(plot, %{})

    socket
    |> assign(:plot, plot)
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case SavePlots.get_plot(id) do
      nil ->
        socket
        |> put_flash(:error, "Plot not found.")
        |> assign(:plot, %Plot{})
        |> assign(:changeset, Plot.changeset(%Plot{}, %{}))
        |> assign(:form, to_form(Plot.changeset(%Plot{}, %{})))

      plot ->
        changeset = Plot.changeset(plot, %{})

        socket
        |> assign(:plot, plot)
        |> assign(:changeset, changeset)
        |> assign(:form, to_form(changeset))
    end
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    case SavePlots.get_plot(id) do
      nil ->
        socket
        |> put_flash(:error, "Plot not found.")
        |> assign(:plot, %Plot{})

      plot ->
        assign(socket, :plot, plot)
    end
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    case SavePlots.delete_plot(id) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "Plot deleted successfully.")
        |> assign(:plot, %Plot{})

      {:error, _} ->
        socket
        |> put_flash(:error, "Failed to delete plot.")
        |> assign(:plot, %Plot{})
    end
  end
end
