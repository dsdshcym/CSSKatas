defmodule CSSKatasWeb.Router do
  use CSSKatasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CSSKatasWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CSSKatasWeb do
    pipe_through :browser

    live "/", PageLive, :index

    resources "/katas", KataController,
      param: "slug",
      only: [
        :show
      ]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CSSKatasWeb do
  #   pipe_through :api
  # end

  import Phoenix.LiveDashboard.Router

  pipeline :live_dashboard_basic_auth do
    plug :auth

    defp auth(conn, _opts) do
      Plug.BasicAuth.basic_auth(
        conn,
        username: "admin",
        password: System.fetch_env!("LIVE_DASHBOARD_PASSWORD")
      )
    end
  end

  scope "/" do
    pipe_through :browser
    pipe_through :live_dashboard_basic_auth

    live_dashboard "/dashboard", metrics: CSSKatasWeb.Telemetry
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
