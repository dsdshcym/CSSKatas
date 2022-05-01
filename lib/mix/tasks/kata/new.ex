defmodule Mix.Tasks.Kata.New do
  @shortdoc "Create new Kata"

  use Mix.Task

  @switches [category: :string, slug: :string, position: :float]

  @katas_home "./tracks"
  @default_position 0.1
  @default_category "tailwind-css-101"
  @default_files ["initial.html", "design.html", "instruction.md", "metadata.json"]

  @impl true
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: @switches)

    slug = Keyword.fetch!(parsed, :slug)
    position = Keyword.get(parsed, :position, @default_position)
    category = Keyword.get(parsed, :category, @default_category)

    dir = get_dir_from_category_slug(category, slug)
    title = get_title_from_slug(slug)
    create_files(dir, position, title)

    IO.puts("Please run command `mix compile --force` manually.")
  end

  defp get_dir_from_category_slug(category, slug) do
    Path.join([@katas_home, category, slug])
  end

  defp get_title_from_slug(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
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
