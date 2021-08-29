defmodule CSSKatas do
  @moduledoc """
  CSSKatas keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_kata("button-with-paddings") do
    path = Path.expand("../katas/button-with-paddings", __DIR__)

    kata = load_kata(path)

    {:ok, kata}
  end

  defp load_kata(path) do
    %{
      initial_html: path |> Path.join("initial.html") |> File.read!(),
      design: path |> Path.join("design.html") |> File.read!(),
      title:
        path
        |> Path.join("metadata.json")
        |> File.read!()
        |> Jason.decode!()
        |> Map.fetch!("title"),
      instruction: path |> Path.join("instruction.html") |> File.read!()
    }
  end
end
