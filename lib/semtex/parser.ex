defmodule Semtex.Parser do
  @parser_module Application.get_env(:semtex, :html_parser, nil)

  def parse(raw_html, opts \\ %{}) do
    case do_parse(raw_html, opts) do
      {:ok, nodes} ->
        {:ok, Semtex.Utils.apply_func_to_tags!(nodes, &apply_self_to_attrs_value/1)}

      {:error, _reason} = error ->
        error
    end
  end

  def parse!(raw_html, opts \\ %{}) do
    case parse(raw_html, opts) do
      {:ok, nodes} ->
        nodes

      {:error, reason} ->
        raise reason
    end
  end

  def parse_fragment(raw_html, opts \\ %{}) do
    case parse(raw_html, opts) do
      {:ok, nodes} ->
        {:ok, unwrapped_nodes} = Semtex.Utils.unwrap_nodes(nodes, ["html", "body"])
        {:ok, unwrapped_nodes}

      {:error, _reason} = error ->
        error
    end
  end

  def parse_fragment!(raw_html, opts \\ %{}) do
    case parse_fragment(raw_html, opts) do
      {:ok, nodes} ->
        nodes

      {:error, reason} ->
        raise reason
    end
  end

  defp do_parse(raw_html, %{parser_module: parser_module}) do
    do_parse_with(parser_module, raw_html)
  end

  defp do_parse(raw_html, _opts) do
    do_parse_with(@parser_module, raw_html)
  end

  defp do_parse_with(Html5ever, raw_html) do
    Html5ever.parse(raw_html)
  end

  defp do_parse_with(module, _raw_html) do
    raise "Invalid parser module -> #{module}"
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

  defp apply_self_to_attrs_value({tag, attrs, children}) do
    new_attrs =
      Enum.map(attrs, fn
        {key, _value} when key in @attributes_with_self_value ->
          {key, key}

        pair ->
          pair
      end)

    {tag, new_attrs, children}
  end
end
