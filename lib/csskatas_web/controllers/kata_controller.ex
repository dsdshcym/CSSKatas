defmodule CSSKatasWeb.KataController do
  use CSSKatasWeb, :controller

  def show(conn, params) do
    kata = %{
      initial_html: ~s{<button class="border rounded">Submit</button>},
      design: ~s{<button class="border rounded px-4 py-2">Submit</button>},
      title: ~s{Tailwind CSS 101 - Paddings},
      instruction: ~s{<p>This is how padding works in Tailwind CSS</p>}
    }

    conn
    |> render(:show, kata: kata)
  end
end
