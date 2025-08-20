defmodule PlotWeb.PageController do
  use PlotWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
