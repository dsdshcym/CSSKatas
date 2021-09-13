defmodule CSSKatasWeb.TrackLive do
  use CSSKatasWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, tracks} = CSSKatas.get_tracks()

    {
      :ok,
      socket
      |> assign(:tracks, tracks)
      |> assign(:page_title, "Tracks")
    }
  end

  def render(assigns) do
    render(CSSKatasWeb.TrackView, "index.html", assigns)
  end
end
