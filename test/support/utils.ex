defmodule SemtexTest.Utils do
  def generate_config(parser_module) do
    Map.merge(Semtex.config, %{parser_module: parser_module})
  end

  def all_eq?([]), do: true
  def all_eq?([_item]), do: true

  def all_eq?([head | tail]) do
    Enum.reduce_while(tail, head, fn head, last ->
      if head == last do
        {:cont, head}
      else
        {:halt, :error}
      end
    end)
    |> case do
      :error ->
        false

      _ ->
        true
    end
  end
end
