defmodule CSSKatas.Kata do
  def load_from_local(path) do
    %{
      slug: Path.basename(path),
      initial_html: path |> read!("initial.html"),
      design: path |> read!("design.html"),
      title:
        path
        |> read!("metadata.json")
        |> Jason.decode!()
        |> Map.fetch!("title"),
      instruction: path |> read!("instruction.html")
    }
  end

  defp read!(dir, file) do
    dir
    |> Path.join(file)
    |> File.read!()
  end
end
