defmodule CSSKatasWeb.HomeController do
  use CSSKatasWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
