defmodule Semtex.Sanitizer do
  @sanitizer_passes [
    {Semtex.Sanitizer.Passes, :keep_allowed_tags},
    {Semtex.Sanitizer.Passes, :keep_allowed_attrs},
    {Semtex.Sanitizer.Passes, :keep_allowed_url_schemes},
    {Semtex.Sanitizer.Passes, :replace_link_rel_values},
  ]

  def sanitize!(raw_html, config, sanitizer_passes \\ @sanitizer_passes) do
    {:ok, body_nodes} = parse_and_unwrap(raw_html)
    walk_nodes!(body_nodes, config, sanitizer_passes)
  end

  defp parse_and_unwrap(raw_html) do
    with {:ok, parsed_html} <- Semtex.Parser.parse(raw_html) do
      Semtex.Utils.unwrap_nodes(parsed_html, ["html", "body"])
    end
  end

  defp walk_nodes!(nodes, config, sanitizer_passes) when is_list(nodes) do
    nodes
    |> Enum.map(&walk_nodes!(&1, config, sanitizer_passes))
    |> Enum.reject(&is_nil/1)
  end

  defp walk_nodes!(node, _config, _sanitizer_passes) when is_binary(node) do
    node
  end

  defp walk_nodes!({:comment, _}, %{"strip_comments" => true}, _sanitizer_passes) do
    nil
  end

  defp walk_nodes!({:comment, _} = comment, %{"strip_comments" => false}, _sanitizer_passes) do
    comment
  end

  defp walk_nodes!(node = {_tag, _attrs, _children}, config, sanitizer_passes) do
    node
    |> dedupe_attrs_to_map()
    |> apply_sanitizer_passes(config, sanitizer_passes)
    |> walk_children(config, sanitizer_passes)
  end

  defp dedupe_attrs_to_map({tag, attrs, children}) do
    new_attrs =
      Enum.reduce(attrs, %{}, fn {key, value}, final_attrs ->
        if not Map.has_key?(final_attrs, key) do
          Map.put(final_attrs, key, value)
        else
          final_attrs
        end
      end)

    {tag, new_attrs, children}
  end

  defp apply_sanitizer_passes(node, config, sanitizer_passes) do
    Enum.reduce_while(sanitizer_passes, node, fn {sanitizer_module, sanitizer_fn}, curr_node ->
      case apply(sanitizer_module, sanitizer_fn, [curr_node, config]) do
        {:pass} ->
          {:cont, curr_node}

        {:replace, new_node} ->
          {:cont, new_node}

        {:remove} ->
          {:halt, nil}
      end
    end)
  end

  defp walk_children(nil, _config, _sanitizer_passes) do
    nil
  end

  defp walk_children({tag, attrs, children}, config, sanitizer_passes) do
    {tag, attrs, walk_nodes!(children, config, sanitizer_passes)}
  end
end