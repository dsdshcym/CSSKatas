defmodule Mix.Tasks.Kata.New do
  @shortdoc "Create new Kata"

  @moduledoc """
  Create a new Kata.

  This task would only overwrite `metadata.json` if Kata files already exist.
  So you can change position by running the same command with a new position value.

  ## Options
  - `--title` - name of the track, e.g. "rounded avatar". (required)
  - `--track` - a directory name chosed from the tracks directory. (default: "tailwind-css-101")
  - `--position` - a float number, smaller value has a higher order. (default: 0.1)

  ## Examples

      $ mix kata.new --title "rounded avatar"

  Is equivalent to:

      $ mix kata.new --title "rounded avatar" --track "tailwind-css-101" --position=0.1

  """

  use Mix.Task

  @switches [title: :string, track: :string, position: :float]

  @katas_home "./tracks"
  @default_position 0.1
  @default_track "tailwind-css-101"
  @default_files ["initial.html", "design.html", "instruction.md", "metadata.json"]

  @impl true
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: @switches)

    title = Keyword.fetch!(parsed, :title)
    position = Keyword.get(parsed, :position, @default_position)
    track = Keyword.get(parsed, :track, @default_track)

    slug = get_slug_from_title(title)
    dir = get_dir_from_track_slug(track, slug)
    create_files(dir, position, title)

    IO.puts("Please run command `mix compile --force` manually. to compile this new Kata.")
  end

  defp get_slug_from_title(title) do
    title
    |> String.downcase()
    |> String.split()
    |> Enum.join("-")
  end

  defp get_dir_from_track_slug(track, slug) do
    Path.join([@katas_home, track, slug])
  end

  defp create_files(dir, position, title) do
    File.mkdir_p!(dir)

    Enum.each(@default_files, fn file ->
      path = Path.join(dir, file)

      File.exists?(path) ||
        (File.touch!(path) && IO.puts("Created: #{path}"))

      if file == "metadata.json" do
        metadata = %{position: position, title: title}
        File.write!(path, Jason.encode!(metadata, pretty: true))
        IO.puts("Updated: #{path}")
      end
    end)
  end
end
