defmodule Semtex.Minifier do
  @whitespace_no_collapse_tags [
    "script",
    "style",
    "pre",
    "textarea"
  ]

  def minify!(ast, config \\ %{}) when is_list(ast) do
    minify!(ast, nil, config)
  end

  def minify!(ast, parent_tag, config) when is_list(ast) do
    ast
    |> Enum.map(&minify!(&1, parent_tag, config))
  end

  def minify!({tag, attrs, children}, _parent_tag, config) do
    {tag, attrs, minify!(children, tag, config)}
  end

  def minify!(node, parent_tag, _config) when is_binary(node) and parent_tag not in @whitespace_no_collapse_tags do
    collapse_newlines(node)
  end

  def minify!(node, "script", _config) when is_binary(node) do
    trim_whitespace(node)
  end

  def minify!(node, _parent_tag, _config) do
    node
  end

  def collapse_newlines(str) do
    String.replace(str, ~r/[\n\r\f\t]+\s*/, "")
  end

  def trim_whitespace(str) do
    String.trim(str)
  end
end
