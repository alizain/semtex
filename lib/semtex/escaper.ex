defmodule Semtex.Escaper do
  @escape_replacements %{
    # From https://github.com/mathiasbynens/he
    "\"" => "&quot;",
    "&" => "&amp;",
    "'" => "&#x27;",
    "<" => "&lt;",
    # See https://mathiasbynens.be/notes/ambiguous-ampersands: in HTML, the
    # following is not strictly necessary unless it’s part of a tag or an
    # unquoted attribute value. We’re only escaping it to support those
    # situations, and for XML support.
    ">" => "&gt;",
    # In Internet Explorer ≤ 8, the backtick character can be used
    # to break out of (un)quoted attribute values or HTML comments.
    # See http://html5sec.org/#102, http://html5sec.org/#108, and
    # http://html5sec.org/#133.
    "`" => "&#x60;",
    # More characters to escape from https://wonko.com/post/html-escaping
    " " => "&#x20;",
    "!" => "&#x21;",
    "@" => "&#x40;",
    "$" => "&#x24;",
    "%" => "&#x25;",
    "(" => "&#x28;",
    ")" => "&#x29;",
    "=" => "&#x3D;",
    "+" => "&#x2B;",
    "{" => "&#x7B;",
    "}" => "&#x7D;",
    "[" => "&#x5B;",
    "]" => "&#x5D;",
    "/" => "&#x2F;",
    "*" => "&#x2A;",
    "," => "&#x2C;",
    "-" => "&#x2D;",
    ";" => "&#x3B;",
    "^" => "&#x5E;",
    "|" => "&#x7C;",
  }

  @escape_replacement_codepoints @escape_replacements
    |> Enum.map(fn {<<codepoint::utf8>>, replacement} ->
      {codepoint, replacement}
    end)
    |> Enum.into(%{})

  def escape_str(raw_str) when is_binary(raw_str) do
    escape_str(raw_str, "")
  end

  def escape_str(<<codepoint::utf8, rem_raw_str::binary>>, acc) do
    char = Map.get(@escape_replacement_codepoints, codepoint, <<codepoint::utf8>>)
    escape_str(rem_raw_str, acc <> char)
  end

  def escape_str(<<>>, acc) do
    acc
  end
end
