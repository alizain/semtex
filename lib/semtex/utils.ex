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

  def unwrap_nodes([], [_tag_to_find | _remaining_tags]) do
    {:error, "not found"}
  end

  def unwrap_nodes([{:doctype, "html", "", ""} | nodes], remaining_tags) do
    unwrap_nodes(nodes, remaining_tags)
  end

  def unwrap_nodes(nodes, [last_tag_to_find]) when is_list(nodes) do
    case find_node(nodes, last_tag_to_find) do
      nil ->
        {:error, "not found"}

      {_tag, _attrs, children} ->
        {:ok, children}
    end
  end

  def unwrap_nodes(nodes, [tag_to_find | remaining_tags]) when is_list(nodes) do
    next_nodes =
      case find_node(nodes, tag_to_find) do
        nil ->
          nodes

        {_tag, _attrs, children} ->
          children
      end

    unwrap_nodes(next_nodes, remaining_tags)
  end

  def find_node(nodes, tag_to_find) when is_list(nodes) do
    nodes
    |> Enum.find(nil, fn
      {^tag_to_find, _attrs, _children} ->
        true

      _node ->
        false
    end)
  end
end
