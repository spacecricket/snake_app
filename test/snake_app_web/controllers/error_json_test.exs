defmodule SnakeAppWeb.ErrorJSONTest do
  use SnakeAppWeb.ConnCase, async: true

  test "renders 404" do
    assert SnakeAppWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert SnakeAppWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
