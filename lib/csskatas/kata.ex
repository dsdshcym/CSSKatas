defmodule CSSKatas.Kata do
  def load_from_local(path) do
    %{
      slug: Path.basename(path),
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
