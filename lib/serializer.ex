defmodule Semtex.Serializer do
  def ast_to_html!(nodes) do
    nodes
    |> ast_to_interchange!()
    |> interchange_to_html!()
  end

  def ast_to_json!(nodes) do
    nodes
    |> ast_to_interchange!()
    |> Jason.encode!(pretty: true)
  end

  def json_to_html!(nodes_str) do
    nodes_str
    |> Jason.decode!()
    |> interchange_to_html!()
  end

  defp ast_to_interchange!(nodes) when is_list(nodes) do
    Enum.map(nodes, &ast_to_interchange!(&1))
  end

  defp ast_to_interchange!(text_value) when is_binary(text_value) do
    %{
      "type" => "text",
      "value" => Semtex.Escaper.escape_str(text_value)
    }
  end

  defp ast_to_interchange!({:comment, comment_value}) do
    %{
      "type" => "comment",
      "value" => comment_value
    }
  end

  defp ast_to_interchange!({tag, attrs, children}) do
    %{
      "type" => "element",
      "tag" => tag,
      "attrs" => attrs,
      "children" => ast_to_interchange!(children)
    }
  end

  defp interchange_to_html!(nodes) when is_list(nodes) do
    nodes
    |> Enum.map(&interchange_to_html!(&1))
    |> Enum.join("")
  end

  defp interchange_to_html!(%{"type" => "text", "value" => text_value}) do
    Semtex.Escaper.escape_str(text_value)
  end

  defp interchange_to_html!(%{"type" => "comment", "value" => comment_value}) do
    "<!--#{comment_value}-->"
  end

  defp interchange_to_html!(%{"type" => "element", "tag" => tag, "attrs" => attrs, "children" => children}) do
    "<#{tag}#{attrs_to_html!(attrs)}>#{interchange_to_html!(children)}</#{tag}>"
  end

  defp attrs_to_html!(attrs) when attrs == %{} do
    ""
  end

  defp attrs_to_html!(attrs) when is_map(attrs) do
    serialized_attrs =
      attrs
      |> Enum.map(fn {key, value} -> "#{key}=\"#{value}\"" end)
      |> Enum.join(" ")

    " #{serialized_attrs}"
  end
end
