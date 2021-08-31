defmodule CSSKatasWeb.KataController do
  use CSSKatasWeb, :controller

  def index(conn, _params) do
    {:ok, katas} = CSSKatas.get_katas()

    conn
    |> assign(:page_title, "Katas")
    |> render(:index, katas: katas)
  end

  def show(conn, params) do
    {:ok, kata} = CSSKatas.get_kata(params["slug"])

    conn
    |> render(:show, kata: kata)
  end
end
