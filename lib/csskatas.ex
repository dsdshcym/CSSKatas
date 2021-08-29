defmodule CSSKatas do
  @moduledoc """
  CSSKatas keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  katas =
    "../katas"
    |> Path.expand(__DIR__)
    |> Path.join("*")
    |> Path.wildcard()
    |> Enum.map(fn path ->
      @external_resource path

      CSSKatas.Kata.load_from_local(path)
    end)

  for kata <- katas do
    def get_kata(unquote(kata.slug)) do
      {:ok, unquote(Macro.escape(kata))}
    end
  end
end
