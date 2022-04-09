defmodule CSSKatasWeb.WallabyCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import Wallaby.Query
      import unquote(__MODULE__)

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
                 retry(
                   fn ->
                     if has?(session, css("p", text: "Oops, Preview doesn't match the Design")),
                       do: {:error, :still_has_error_HUD},
                       else: {:ok, :error_HUD_dismissed}
                   end,
                   1_000
                 )

        session
      end
    end
  end

  defmacro test_kata(slug) do
    {:ok, kata} = CSSKatas.get_kata(slug)

    quote do
      feature unquote(kata.title), %{session: session} do
        session
        |> visit("/katas/#{unquote(kata.slug)}")
        |> assert_has(css("h2", text: "#{unquote(kata.title)}"))
        |> assert_filled_solution(unquote(kata.initial_html))

        # Checks initial html is not a match
        |> click(button("Check"))
        |> assert_error_appeared()

        # Checks solution that is not a match
        |> fill_solution(Enum.join([unquote(kata.design), "mask"]))
        |> click(button("Check"))
        |> assert_error_appeared()

        # Reset the editor
        |> click(button("Reset"))
        |> assert_filled_solution(unquote(kata.initial_html))
        |> assert_error_dismissed()

        # Checks solution that is a match
        |> fill_solution(unquote(kata.design))
        |> click(button("Check"))
        |> assert_show_congrat_message()
      end
    end
  end
end
