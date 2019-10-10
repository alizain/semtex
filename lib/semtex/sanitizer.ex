defmodule Semtex.Sanitizer do
  alias Semtex.Sanitizer.Passes

  def sanitize!(node, config) when is_list(node) do
    node
    |> Enum.map(&sanitize!(&1, config))
    |> Enum.reject(&is_nil/1)
  end

  def sanitize!(node, _config) when is_binary(node) do
    node
  end

  def sanitize!({:comment, _}, %{"strip_comments" => true}) do
    nil
  end

  def sanitize!({:comment, _} = comment, %{"strip_comments" => false}) do
    comment
  end

  def sanitize!(node = {_tag, _attrs, _children}, config) do
    node
    |> Passes.keep_allowed_tags(config)
    |> Passes.keep_allowed_attrs(config)
    |> Passes.dedupe_attrs_to_map(config)
    |> Passes.keep_allowed_url_schemes(config)
    |> Passes.replace_anchor_rel_values(config)
    |> walk_children(config)
  end

  defp walk_children(nil, _config) do
    nil
  end

  defp walk_children({tag, attrs, children}, config) do
    {tag, attrs, sanitize!(children, config)}
  end
end
