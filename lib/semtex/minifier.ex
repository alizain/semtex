defmodule Semtex.Minifier do
  @whitespace_collapse_tags [
    "p",
    "a",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "figcaption",
  ]

  @whitespace_trim_tags [
    "script",
    "style",
  ]

  @whitespace_ignore_tags [
    "script",
    "style",
    "pre",
    "textarea",
  ]

  def minify!(ast, config \\ %{}) when is_list(ast) do
    minify!(ast, nil, config)
  end

  def minify!(ast, parent_tag, config) when is_list(ast) do
    ast
    |> Enum.map(&minify!(&1, parent_tag, config))
    |> remove_leading_and_trailing_whitespace(parent_tag, config)
    |> Enum.reject(fn node -> node == "" end)
  end

  def minify!({tag, attrs, children}, _parent_tag, config) do
    {tag, attrs, minify!(children, tag, config)}
  end

  def minify!(node, parent_tag, _config) when is_binary(node) and parent_tag in @whitespace_collapse_tags do
    collapse_whitespace(node)
  end

  def minify!(node, parent_tag, _config) when is_binary(node) and parent_tag in @whitespace_trim_tags do
    trim_whitespace(node)
  end

  def minify!(node, parent_tag, _config) when is_binary(node) and parent_tag not in @whitespace_ignore_tags do
    trim_newlines(node)
  end

  def minify!(node, _parent_tag, _config) do
    node
  end

  defp remove_leading_and_trailing_whitespace(ast, parent_tag, config) do
    ast
    |> remove_leading_whitespace(parent_tag, config)
    |> Enum.reverse()
    |> remove_leading_whitespace(parent_tag, config)
    |> Enum.reverse()
  end

  defp remove_leading_whitespace(ast, _parent_tag, _config) do
    {new_ast, _state} =
      Enum.map_reduce(ast, %{found_content?: false}, fn
        node, %{found_content?: false} when is_binary(node) ->
          if trim_whitespace(node) == "" do
            {"", %{found_content?: false}}
          else
            {node, %{found_content?: true}}
          end

        node, state ->
          {node, state}
      end)

    new_ast
  end

  defp collapse_whitespace(str) do
    String.replace(str, ~r/[\n\r\f\t\s]+/, " ")
  end

  def trim_whitespace(str) do
    String.trim(str)
  end

  defp trim_newlines(str) do
    String.replace(str, ~r/[\n\r\f\t]+\s*/, "")
  end
end
