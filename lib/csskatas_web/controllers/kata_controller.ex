defmodule CSSKatasWeb.KataController do
  use CSSKatasWeb, :controller

  def show(conn, params) do
    conn
    |> render(:show)
  end
end
