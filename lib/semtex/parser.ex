defmodule Semtex.Parser do
  def parse!(raw_html) do
    case parse(raw_html) do
      {:ok, body_nodes} ->
        body_nodes

      {:error, reason} ->
        raise reason
    end
  end

  def parse(raw_html) do
    Html5ever.parse(raw_html)
  end
end
