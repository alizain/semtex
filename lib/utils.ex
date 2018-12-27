defmodule Semtex.Utils do
  def scheme(nil) do
    nil
  end

  def scheme(raw_str) when is_binary(raw_str) do
    raw_str
    |> String.trim()
    |> String.split(":", parts: 2, trim: true)
    |> case do
      [scheme | _] ->
        scheme

      _ ->
        nil
    end
  end
end
