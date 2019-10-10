defmodule Semtex.Serializer do
  # https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#XSS_Prevention_Rules
  # https://stackoverflow.com/questions/7381974/which-characters-need-to-be-escaped-on-html/7382443#7382443

  @self_closing_tags [
    "area",
    "base",
    "br",
    "col",
    "command",
    "embed",
    "hr",
    "img",
    "input",
    "keygen",
    "link",
    "meta",
    "param",
    "source",
    "track",
    "wbr"
  ]

  def serialize!(node, config) when is_list(node) do
    node
    |> Enum.map(&serialize!(&1, config))
    |> Enum.join("")
  end

  def serialize!({:doctype, "html", "", ""}, _config) do
    "<!doctype html>"
  end

  def serialize!({:comment, comment}, _config) do
    "<!--#{comment}-->"
  end

  def serialize!({tag, attrs, _children}, config) when tag in @self_closing_tags do
    "<#{tag}#{serialize_attrs!(attrs, config)}/>"
  end

  def serialize!({tag, attrs, children}, config) do
    "<#{tag}#{serialize_attrs!(attrs, config)}>#{serialize!(children, config)}</#{tag}>"
  end

  def serialize!(node, %{"escape_serialization" => true}) when is_binary(node) do
    Semtex.Escaper.escape_str(node)
  end

  def serialize!(node, %{"escape_serialization" => false}) when is_binary(node) do
    node
  end

  def serialize_attrs!(attrs, _config) when attrs == [] or attrs == %{} do
    ""
  end

  def serialize_attrs!(attrs, config) do
    " " <> (attrs
            |> escape_attrs(config)
            |> Enum.map(fn {key, value} -> "#{key}=\"#{value}\"" end)
            |> Enum.join(" "))
  end

  def escape_attrs(attrs, %{"escape_serialization" => true, "url_encode_attributes" => url_encode_attributes}) do
    Enum.map(attrs, fn {attr_key, attr_value} ->
      if Enum.member?(url_encode_attributes, attr_key) do
        case Semtex.Utils.scheme(attr_value) do
          nil ->
            {attr_key, Semtex.Escaper.escape_str(attr_value)}

          _ ->
            {attr_key, URI.encode(attr_value)}
        end
      else
        {attr_key, Semtex.Escaper.escape_str(attr_value)}
      end
    end)
  end

  def escape_attrs(attrs, %{"escape_serialization" => false}) do
    attrs
  end
end
