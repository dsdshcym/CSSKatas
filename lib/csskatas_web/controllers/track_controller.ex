defmodule CSSKatasWeb.TrackController do
  use CSSKatasWeb, :controller

  def index(conn, _params) do
    {:ok, tracks} = CSSKatas.get_tracks()

    conn
    |> assign(:tracks, tracks)
    |> assign(:page_title, "Tracks")
    |> render(:index)
  end
end
