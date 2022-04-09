defmodule CSSKatasWeb.Features.KataTest do
  use CSSKatasWeb.WallabyCase, async: true

  feature "Kata Workflow", %{session: session} do
    session
    # Visits home page
    |> visit("/")

    # Visits Tracks index page
    |> click(link("Start Practicing", count: 2, at: 1))
    |> assert_has(css("h1", text: "Tracks"))
    |> assert_has(css("h2", text: "Tailwind CSS 101"))

    # Visits Kata show page
    |> click(link("Welcome to CSSKatas"))
    |> assert_has(css("h2", text: "Welcome to CSSKatas"))

    # Reads instruction and initial solution
    |> assert_text("This is CSSKatas dojo.")
    |> assert_filled_solution(~s{CSSKatas})

    # Checks solution that is not a match
    |> fill_solution(~s{CSSKatas is good!})
    |> click(button("Check"))
    |> assert_error_appeared()

    # Resets the editor
    |> click(button("Reset"))
    |> assert_filled_solution(~s{CSSKatas})
    |> assert_error_dismissed()

    # Checks solution that is a match
    |> fill_solution(~s{CSSKatas is awesome!})
    |> click(button("Check"))
    |> assert_show_congrat_message()

    # Redirects back to Tracks index page
    |> click(button("Pick next Kata"))
    |> assert_has(css("h1", text: "Tracks"))
  end

  test_kata("welcome-to-csskatas")
  test_kata("a-utility-first-framework")
  test_kata("text-color")
  test_kata("text-transform")
  test_kata("font-format")
  test_kata("button-with-paddings")
  test_kata("button-with-ring")
  test_kata("button-with-bg-color")
  test_kata("justify-between-two-buttons")
  test_kata("rounded-avatar")
  test_kata("text-decoration")
  test_kata("gradient-text")
  test_kata("decorative-quote-mark")
end
