defmodule CSSKatasWeb.Features.KataTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  feature "Kata Workflow", %{session: session} do
    session
    # Visits home page
    |> visit("/")

    # Visits Tracks index page
    |> click(link("Start Practicing", count: 2, at: 1))
    |> assert_has(css("h1", text: "Tracks"))
    |> assert_has(css("h2", text: "Tailwind CSS 101"))

    # Visits Kata show page
    |> touch_scroll(link("Paddings"), 0, 1)
    |> click(link("Paddings"))
    |> assert_has(css("h2", text: "Paddings"))

    # Reads instruction and initial solution
    |> assert_text("To make a button, we need to add some spaces")
    |> assert_filled_solution(~s{<button class="border rounded">Button</button>})

    # Checks solution that is not a match
    |> fill_solution(~s{<button class="border rounded px-4">Button</button>})
    |> click(button("Check"))
    |> assert_error_appeared()

    # Resets the editor
    |> click(button("Reset"))
    |> assert_filled_solution(~s{<button class="border rounded">Button</button>})
    |> assert_error_dismissed()

    # Checks solution that is a match
    |> fill_solution(~s{<button class="border rounded px-4 py-2">Button</button>})
    |> click(button("Check"))
    |> assert_show_congrat_message()

    # Redirects back to Tracks index page
    |> click(button("Pick next Kata"))
    |> assert_has(css("h1", text: "Tracks"))
  end

  describe "test kata by slug" do
    setup context do
      slug =
        context[:test]
        |> Atom.to_string()
        |> String.split()
        |> List.last()

      {:ok, kata} = CSSKatas.get_kata(slug)
      {:ok, kata: kata}
    end

    feature("welcome-to-csskatas", context, do: do_test_kata(context))
    feature("a-utility-first-framework", context, do: do_test_kata(context))
    feature("text-color", context, do: do_test_kata(context))
    feature("text-transform", context, do: do_test_kata(context))
    feature("font-format", context, do: do_test_kata(context))
    feature("button-with-paddings", context, do: do_test_kata(context))
    feature("button-with-ring", context, do: do_test_kata(context))
    feature("button-with-bg-color", context, do: do_test_kata(context))
    feature("justify-between-two-buttons", context, do: do_test_kata(context))
    feature("rounded-avatar", context, do: do_test_kata(context))
    feature("gradient-text", context, do: do_test_kata(context))
    feature("decorative-quote-mark", context, do: do_test_kata(context))
  end

  defp do_test_kata(%{session: session, kata: %{slug: "a-utility-first-framework"} = kata}) do
    session
    |> visit("/katas/#{kata.slug}")
    |> assert_has(css("h2", text: kata.title))
    |> assert_filled_solution(kata.initial_html)

    # Checks initial is just the solution
    |> click(button("Check"))
    |> assert_show_congrat_message()
  end

  defp do_test_kata(%{session: session, kata: kata}) do
    session
    |> visit("/katas/#{kata.slug}")
    |> assert_has(css("h2", text: kata.title))
    |> assert_filled_solution(kata.initial_html)

    # Checks initial html is not a match
    |> click(button("Check"))
    |> assert_error_appeared()

    # Reset the editor
    |> click(button("Reset"))
    |> assert_error_dismissed()

    # Checks solution that is not a match
    |> fill_solution(Regex.replace(~r/[a-z]/, kata.design, "!", global: false))
    |> click(button("Check"))
    |> assert_error_appeared()

    # Reset the editor
    |> click(button("Reset"))
    |> assert_filled_solution(kata.initial_html)
    |> assert_error_dismissed()

    # Checks solution that is a match
    |> fill_solution(kata.design)
    |> click(button("Check"))
    |> assert_show_congrat_message()
  end

  defp assert_filled_solution(session, text) do
    session
    |> execute_script("return window.editor_view.state.doc.toString()", [], fn result ->
      assert result =~ text
    end)
  end

  defp fill_solution(session, text) do
    session
    |> execute_script(
      "window.editor_view.dispatch({changes: {from: 0, to: window.editor_view.state.doc.length, insert: arguments[0]}})",
      [text]
    )
  end

  defp assert_show_congrat_message(session) do
    session
    |> assert_has(css("h3", text: "Congratulations"))
  end

  defp assert_error_appeared(session) do
    session
    |> assert_has(css("p", text: "Oops, Preview doesn't match the Design"))
  end

  defp assert_error_dismissed(session) do
    assert {:ok, :error_HUD_dismissed} =
             retry(fn ->
               if has?(session, css("p", text: "Oops, Preview doesn't match the Design")),
                 do: {:error, :still_has_error_HUD},
                 else: {:ok, :error_HUD_dismissed}
             end)

    session
  end
end
