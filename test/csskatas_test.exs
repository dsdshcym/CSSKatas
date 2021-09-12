defmodule CSSKatasTest do
  use ExUnit.Case, async: true

  describe "get_tracks/0" do
    test "returns all the tracks" do
      assert {
               :ok,
               [
                 %{name: "Intro to CSSKatas", slug: "intro-to-csskatas", katas: _},
                 %{name: "Tailwind CSS 101", slug: "tailwind-css-101", katas: _},
                 %{name: "Tailwind CSS Advanced", slug: "tailwind-css-advanced", katas: _}
               ]
             } = CSSKatas.get_tracks()
    end
  end

  describe "get_track/1" do
    test "returns track for intro-to-csskatas" do
      assert {
               :ok,
               %{
                 name: "Intro to CSSKatas",
                 slug: "intro-to-csskatas",
                 katas: [%{title: "Welcome to CSSKatas"}]
               }
             } = CSSKatas.get_track("intro-to-csskatas")
    end
  end
end
