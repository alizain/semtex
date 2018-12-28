defmodule Semtex.Parser do
  def parse!(raw_html) do
    case parse(raw_html) do
      {:ok, nodes} ->
        nodes

      {:error, reason} ->
        raise reason
    end
  end

  def parse(raw_html) do
    case Html5ever.parse(raw_html) do
      {:ok, nodes} ->
        fixed_nodes =
          Semtex.Utils.apply_func_to_tags!(nodes, &apply_self_to_attrs_value/1)

        {:ok, fixed_nodes}

      {:error, _reason} = error ->
        error
    end
  end

  @attributes_with_self_value [
    "checked",
    "compact",
    "declare",
    "defer",
    "disabled",
    "ismap",
    "multiple",
    "nohref",
    "noresize",
    "noshade",
    "nowrap",
    "readonly",
    "selected",
  ]

  def apply_self_to_attrs_value({tag, attrs, children}) do
    new_attrs =
      Enum.map(attrs, fn
        {key, ""} when key in @attributes_with_self_value ->
          {key, key}

        pair ->
          pair
      end)

    {tag, new_attrs, children}
  end
end
