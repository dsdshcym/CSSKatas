defmodule CSSKatas do
  @moduledoc """
  CSSKatas keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_kata("button-with-paddings") do
    kata = %{
      initial_html: ~s{<button class="border rounded">Submit</button>},
      design: ~s{<button class="border rounded px-4 py-2">Submit</button>},
      title: ~s{Tailwind CSS 101 - Paddings},
      instruction: ~s{<p>This is how padding works in Tailwind CSS</p>}
    }

    {:ok, kata}
  end
end
