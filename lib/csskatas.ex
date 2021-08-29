defmodule CSSKatas do
  @moduledoc """
  CSSKatas keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  kata_paths =
    "../katas"
    |> Path.expand(__DIR__)
    |> Path.join("*")
    |> Path.wildcard()

  for kata_path <- kata_paths do
    for file_path <- kata_path |> Path.join("*") |> Path.wildcard() do
      @external_resource file_path
    end
  end

  katas =
    kata_paths
    |> Enum.map(fn path ->
      CSSKatas.Kata.load_from_local(path)
    end)

  for kata <- katas do
    def get_kata(unquote(kata.slug)) do
      {:ok, unquote(Macro.escape(kata))}
    end
  end
end
