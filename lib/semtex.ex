defmodule Semtex do
  @sanitizers [
    {Semtex.Sanitizers, :keep_allowed_tags},
    {Semtex.Sanitizers, :keep_allowed_attrs},
    {Semtex.Sanitizers, :keep_allowed_url_schemes},
    {Semtex.Sanitizers, :replace_link_rel_values},
  ]

  def sanitize(raw_html, config) do
    case parse_raw_html(raw_html) do
      {:ok, body_nodes} ->
        walk_node(body_nodes, config, @sanitizers)

      {:error, _} = error ->
        error
    end
  end

  def parse_raw_html(raw_html) do
    with {:ok, parsed_html} <- Html5ever.parse(raw_html) do
      unwrap_nodes(parsed_html, ["html", "body"])
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

  def walk_node(nodes, config, sanitizers) when is_list(nodes) do
    nodes
    |> Enum.map(&walk_node(&1, config, sanitizers))
    |> Enum.reject(&is_nil/1)
  end

  def walk_node(node, _config, _sanitizers) when is_binary(node) do
    node
  end

  def walk_node({:comment, _}, %{"strip_comments" => true}, _sanitizers) do
    nil
  end

  def walk_node({:comment, _} = comment, %{"strip_comments" => false}, _sanitizers) do
    comment
  end

  def walk_node(node = {_tag, _attrs, _children}, config, sanitizers) do
    node
    |> dedupe_attrs_to_map()
    |> apply_sanitizers(config, sanitizers)
    |> walk_children(config, sanitizers)
  end

  def dedupe_attrs_to_map({tag, attrs, children}) do
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

  def apply_sanitizers(node, config, sanitizers) do
    Enum.reduce_while(sanitizers, node, fn {sanitizer_module, sanitizer_fn}, curr_node ->
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

  def walk_children(nil, _config, _sanitizers) do
    nil
  end

  def walk_children({tag, attrs, children}, config, sanitizers) do
    {tag, attrs, walk_node(children, config, sanitizers)}
  end
end
