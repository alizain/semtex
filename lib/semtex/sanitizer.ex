defmodule Semtex.Sanitizer do
  alias Semtex.Sanitizer.Passes

  def sanitize!(raw_html, config) do
    {:ok, body_nodes} = parse_and_unwrap(raw_html)
    walk_nodes!(body_nodes, config)
  end

  defp parse_and_unwrap(raw_html) do
    with {:ok, parsed_html} <- Semtex.Parser.parse(raw_html) do
      Semtex.Utils.unwrap_nodes(parsed_html, ["html", "body"])
    end
  end

  defp walk_nodes!(nodes, config) when is_list(nodes) do
    nodes
    |> Enum.map(&walk_nodes!(&1, config))
    |> Enum.reject(&is_nil/1)
  end

  defp walk_nodes!(node, _config) when is_binary(node) do
    node
  end

  defp walk_nodes!({:comment, _}, %{"strip_comments" => true}) do
    nil
  end

  defp walk_nodes!({:comment, _} = comment, %{"strip_comments" => false}) do
    comment
  end

  defp walk_nodes!(node = {_tag, _attrs, _children}, config) do
    node
    |> Passes.keep_allowed_tags(config)
    |> Passes.keep_allowed_attrs(config)
    |> Passes.dedupe_attrs_to_map(config)
    |> Passes.keep_allowed_url_schemes(config)
    |> Passes.replace_link_rel_values(config)
    |> walk_children(config)
  end

  defp walk_children(nil, _config) do
    nil
  end

  defp walk_children({tag, attrs, children}, config) do
    {tag, attrs, walk_nodes!(children, config)}
  end
end
