defmodule CSSKatas do
  @moduledoc """
  CSSKatas keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_kata("button-with-paddings") do
    path = Path.expand("../katas/button-with-paddings", __DIR__)

    kata = CSSKatas.Kata.load_from_local(path)

    {:ok, kata}
  end
end
