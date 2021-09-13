defmodule CSSKatasWeb.HomeLive do
  use CSSKatasWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Home")
    }
  end

  def render(assigns) do
    render(CSSKatasWeb.HomeView, "show.html", assigns)
  end
end
