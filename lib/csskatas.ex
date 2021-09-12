defmodule CSSKatas do
  @moduledoc """
  CSSKatas keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  track_paths =
    "../tracks"
    |> Path.expand(__DIR__)
    |> Path.join("*")
    |> Path.wildcard()

  tracks =
    for track_path <- track_paths do
      kata_paths =
        track_path
        |> Path.join("*")
        |> Path.wildcard()
        |> Enum.filter(&File.dir?/1)

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
        |> Enum.sort_by(& &1.position)

      track =
        track_path
        |> Path.join("track.json")
        |> File.read!()
        |> Jason.decode!(keys: :atoms)
        |> Map.merge(%{katas: katas})

      track
    end

  katas =
    tracks
    |> Enum.flat_map(& &1.katas)

  def get_katas() do
    {:ok, unquote(Macro.escape(katas))}
  end

  for kata <- katas do
    def get_kata(unquote(kata.slug)) do
      {:ok, unquote(Macro.escape(kata))}
    end
  end
end
