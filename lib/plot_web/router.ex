defmodule PlotWeb.Router do
  use PlotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PlotWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlotWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/users/login", Users.User, :login
    live "/users/logout", Users.User, :logout
    live "/users/:id/edit", Users.User, :edit
    live "/users/:id", Users.User, :show
    live "/plots/new", Plots.Plot, :new
    live "/plots/:id/edit", Plots.Plot, :edit
    live "/plots/:id", Plots.Plot, :show
    live "/plots/:id/delete", Plots.Plot, :delete
    live "/register", Register.Register, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlotWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:plot, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PlotWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
