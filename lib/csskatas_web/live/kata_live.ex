defmodule CSSKatasWeb.KataLive do
  use CSSKatasWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, kata} = CSSKatas.get_kata(params["slug"])

    {:ok,
     socket
     |> assign(:page_title, kata.title)
     |> assign(:kata, kata)}
  end

  def render(assigns) do
    render(CSSKatasWeb.KataView, "show.html", assigns)
  end
end
