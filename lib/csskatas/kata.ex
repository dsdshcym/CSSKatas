defmodule CSSKatas.Kata do
  def load_from_local(path) do
    metadata = path |> read!("metadata.json") |> Jason.decode!(keys: :atoms)

    %{
      title: metadata.title,
      slug: Path.basename(path),
      initial_html: path |> read!("initial.html"),
      design: path |> read!("design.html"),
      instruction: path |> read!("instruction.html")
    }
  end

  defp read!(dir, file) do
    dir
    |> Path.join(file)
    |> File.read!()
    |> String.trim()
  end
end
