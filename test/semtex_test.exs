defmodule SemtexTest do
  use ExUnit.Case
  # doctest Semtex

  test "sanitize/3" do
    result =
      """
      <a href="https://google.com" onclick="javascript:alert('XSS')"></a>
      """
      |> String.trim()
      |> Semtex.sanitize!()
      |> Floki.raw_html()

    assert result == "<a href=\"https://google.com\" rel=\"noopener noreferrer nofollow\"></a>"
  end
end
