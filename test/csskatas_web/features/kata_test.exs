defmodule CSSKatasWeb.Features.KataTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  feature "Kata Workflow", %{session: session} do
    session
    # Visits home page
    |> visit("/")

    # Visits Katas index page
    |> click(link("Start Practicing", count: 2, at: 1))

    # Visits Kata show page
    |> visit("/katas/button-with-paddings")
    |> assert_has(css("h2", text: "Tailwind CSS 101 - Paddings"))

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
