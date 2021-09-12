defmodule CSSKatasWeb.TrackController do
  use CSSKatasWeb, :controller

  def index(conn, _params) do
    {:ok, katas} = CSSKatas.get_katas()

    conn
    |> assign(:katas, katas)
    |> assign(:page_title, "Katas")
    |> render(:index)
  end
end
