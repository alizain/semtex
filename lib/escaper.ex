defmodule Semtex.Escaper do
  # From https://github.com/mathiasbynens/he
  @escape_regex ~r/["&'<>`]/
  @escape_replacements %{
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
  }

  def escape_str(raw_str) when is_binary(raw_str) do
    Regex.replace(
      @escape_regex,
      raw_str,
      fn char ->
        @escape_replacements[char]
      end,
      global: true
    )
  end
end
