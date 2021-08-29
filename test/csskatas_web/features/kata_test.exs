defmodule CSSKatasWeb.Features.KataTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  feature "Kata Workflow", %{session: session} do
    session
    # Visits Kata show page
    |> visit("/katas/button-with-paddings")
    |> assert_has(css("h2", text: "Tailwind CSS 101 - Paddings"))

    # Reads instruction and initial solution
    |> assert_has(css("p", text: "This is how padding works in Tailwind CSS"))
    |> assert_filled_solution("<button class=\"border rounded\">Submit</button>")

    # Checks solution that is not a match
    |> execute_script(
      "window.editor_view.dispatch({changes: {from: 0, to: window.editor_view.state.doc.length, insert: arguments[0]}})",
      ["<button class=\"border rounded px-4\">Submit</button>"]
    )
    |> click(button("Check"))
    |> assert_has(css("p", text: "Oops, Preview doesn't match the Design"))

    # Checks solution that is a match
    |> execute_script(
      "window.editor_view.dispatch({changes: {from: 0, to: window.editor_view.state.doc.length, insert: arguments[0]}})",
      ["<button class=\"border rounded px-4 py-2\">Submit</button>"]
    )
    |> click(button("Check"))
    |> assert_has(css("p", text: "success"))
  end

  defp assert_filled_solution(session, text) do
    session
    |> execute_script("return window.editor_view.state.doc.toString()", [], fn result ->
      assert result =~ text
    end)
  end
end
