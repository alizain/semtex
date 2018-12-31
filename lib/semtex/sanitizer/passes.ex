defmodule Semtex.Sanitizer.Passes do
  def keep_allowed_tags({tag, _attrs, _children} = node, %{"allowed_tags" => allowed_tags}) do
    if tag in allowed_tags do
      node
    else
      nil
    end
  end

  def keep_allowed_tags(node, _config) do
    node
  end

  def keep_allowed_attrs({tag, attrs, children}, %{"allowed_attributes" => allowed_attributes}) do
    allowed_attrs_for_tag =
      (allowed_attributes["by_tag"][tag] || [])
      |> Enum.concat(allowed_attributes["all_tags"])
      |> MapSet.new()

    filtered_attrs =
      attrs
      |> Enum.filter(fn {key, _value} -> MapSet.member?(allowed_attrs_for_tag, key) end)

    {tag, filtered_attrs, children}
  end

  def keep_allowed_attrs(node, _config) do
    node
  end

  def dedupe_attrs_to_map({tag, attrs, children}, _config) do
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

  def dedupe_attrs_to_map(node, _config) do
    node
  end

  def keep_allowed_url_schemes({tag, attrs, children}, %{"allowed_url_scheme_attributes" => allowed_url_scheme_attributes, "allowed_url_schemes" => allowed_url_schemes}) do
    new_attrs =
      Enum.reduce(allowed_url_scheme_attributes, attrs, fn attr_to_check, curr_attrs ->
        curr_attrs
        |> Map.get(attr_to_check, nil)
        |> Semtex.Utils.scheme()
        |> case do
          nil ->
            curr_attrs

          scheme ->
            if not Enum.member?(allowed_url_schemes, scheme) do
              curr_attrs |> Map.delete(attr_to_check)
            else
              curr_attrs
            end
        end
      end)

    {tag, new_attrs, children}
  end

  def keep_allowed_url_schemes(node, _config) do
    node
  end

  def replace_anchor_rel_values({"a", attrs, children}, %{"anchor_rel_values" => anchor_rel_values}) do
    {"a", Map.put(attrs, "rel", Enum.join(anchor_rel_values, " ")), children}
  end

  def replace_anchor_rel_values(node, _config) do
    node
  end
end
