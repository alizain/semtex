defmodule Semtex.SanitizerPasses do
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

  def keep_allowed_url_schemes({tag, attrs, children}, %{"allowed_url_scheme_on_attributes" => allowed_url_scheme_on_attributes, "allowed_url_schemes" => allowed_url_schemes}) do
    new_attrs =
      Enum.reduce(allowed_url_scheme_on_attributes, attrs, fn attr_to_check, curr_attrs ->
        case Map.get(curr_attrs, attr_to_check, nil) do
          nil ->
            curr_attrs

          attr_value ->
            attr_value
            |> String.trim()
            |> String.split(":", parts: :infinity, trim: true)
            |> case do
              [scheme | _] ->
                if scheme in allowed_url_schemes do
                  curr_attrs
                else
                  Map.delete(curr_attrs, attr_to_check)
                end

              [] ->
                curr_attrs
            end
        end
      end)

    {:replace, {tag, new_attrs, children}}
  end

  def keep_allowed_url_schemes(_node, _config) do
    {:pass}
  end

  def replace_link_rel_values({"a", attrs, children}, %{"link_rel_values" => link_rel_values}) do
    {:replace, {"a", Map.put(attrs, "rel", Enum.join(link_rel_values, " ")), children}}
  end

  def replace_link_rel_values(_node, _config) do
    {:pass}
  end
end
