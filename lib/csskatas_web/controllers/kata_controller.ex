defmodule CSSKatasWeb.KataController do
  use CSSKatasWeb, :controller

  def show(conn, params) do
    {:ok, kata} = CSSKatas.get_kata(params["slug"])

    conn
    |> render(:show, kata: kata)
  end
end
