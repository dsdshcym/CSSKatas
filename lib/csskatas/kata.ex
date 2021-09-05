defmodule CSSKatas.Kata do
  def load_from_local(path) do
    metadata = path |> read!("metadata.json") |> Jason.decode!(keys: :atoms)

    %{
      title: metadata.title,
      position: metadata.position,
      slug: Path.basename(path),
      initial_html: path |> read!("initial.html"),
      design: path |> read!("design.html"),
      instruction:
        path |> read!("instruction.html") |> Earmark.as_html!(compact_output: true, escape: false)
    }
  end

  defp read!(dir, file) do
    dir
    |> Path.join(file)
    |> File.read!()
    |> String.trim()
  end
end
