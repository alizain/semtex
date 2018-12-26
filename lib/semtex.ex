defmodule Semtex do
  defdelegate sanitize!(raw_html), to: Semtex.Sanitizer
  defdelegate sanitize!(raw_html, sanitizers), to: Semtex.Sanitizer
  defdelegate sanitize!(raw_html, sanitizers, config), to: Semtex.Sanitizer
end
