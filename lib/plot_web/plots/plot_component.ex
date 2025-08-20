defmodule PlotWeb.Plots.PlotComponent do
  use PlotWeb, :live_component

  alias Plot.SavePlots

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    case SavePlots.save_plot(plot_params) do
      {:ok, _plot} ->
        send(self(), :refresh_plots)
        {:noreply, put_flash(socket, :info, "Plot saved successfully.")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("update", %{"plot" => plot_params}, socket) do
    case SavePlots.update_plot(socket.assigns.plot.id, plot_params) do
      {:ok, _plot} ->
        send(self(), :refresh_plots)
        {:noreply, put_flash(socket, :info, "Plot updated successfully.")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("delete", _params, socket) do
    case SavePlots.delete_plot(socket.assigns.plot.id) do
      {:ok, _} ->
        send(self(), :refresh_plots)
        {:noreply, put_flash(socket, :info, "Plot deleted successfully.")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to delete plot.")}
    end
  end

  def handle_event("get_plot", %{"id" => id}, socket) do
    case SavePlots.get_plot(id) do
      nil ->
        {:noreply, put_flash(socket, :error, "Plot not found.")}

      plot ->
        send(self(), {:refresh_plots, plot})
        {:noreply, assign(socket, plot: plot)}
    end
  end
end
