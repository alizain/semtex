defmodule Semtex.Sanitizers do
  def keep_allowed_tags({tag, _attrs, _children}, %{"allowed_tags" => allowed_tags}) do
    if tag in allowed_tags do
      {:pass}
    else
      {:remove}
    end
  end

  def keep_allowed_attrs({tag, attrs, children}, %{"allowed_attributes" => allowed_attributes}) do
    allowed_attrs_for_tag =
      (allowed_attributes["by_tag"][tag] || [])
      |> Enum.concat(allowed_attributes["all_tags"])
      |> MapSet.new()

    filtered_attrs =
      attrs
      |> Enum.filter(fn {key, _value} -> MapSet.member?(allowed_attrs_for_tag, key) end)
      |> Enum.into(%{})

    {:replace, {tag, filtered_attrs, children}}
  end

  def keep_allowed_url_schemes({tag, %{"href" => href} = attrs, children}, %{"allowed_url_schemes" => allowed_url_schemes}) do
    [scheme | _] =
      href
      |> String.trim()
      |> String.split(":", parts: :infinity, trim: true)
      
    if scheme in allowed_url_schemes do
      {:pass}
    else
      {:replace, {tag, Map.delete(attrs, "href"), children}}
    end
  end

  def keep_allowed_url_schemes(_node, _config) do
    {:pass}
  end

  def replace_link_rel_values({"a", attrs, children} = node, %{"link_rel_values" => link_rel_values}) do
    {:replace, {"a", Map.put(attrs, "rel", Enum.join(link_rel_values, " ")), children}}
  end

  def replace_link_rel_values(_node, _config) do
    {:pass}
  end
end
