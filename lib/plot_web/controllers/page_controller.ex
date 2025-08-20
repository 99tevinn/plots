defmodule PlotWeb.PageController do
  alias Plot.SavePlots
  use PlotWeb, :controller

  def home(conn, _params) do
    current_user = %{id: 1, name: "tev"} # Implement this function to fetch the current user
    recent_plots = SavePlots.list_user_plots(current_user.id)
    render(conn, :home, current_user: current_user, recent_plots: recent_plots)
  end
end
