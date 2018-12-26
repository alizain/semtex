defmodule Semtex.Sanitizer do
  @config %{
    "allowed_attributes" => %{
      "all_tags" => ["lang", "title"],
      "by_tag" => %{
        "a" => ["href", "hreflang"],
        "bdo" => ["dir"],
        "blockquote" => ["cite"],
        "col" => ["align", "char", "charoff", "span"],
        "colgroup" => ["align", "char", "charoff", "span"],
        "del" => ["cite", "datetime"],
        "hr" => ["align", "size", "width"],
        "img" => ["align", "alt", "height", "src", "width"],
        "ins" => ["cite", "datetime"],
        "ol" => ["start"],
        "q" => ["cite"],
        "table" => ["align", "char", "charoff", "summary"],
        "tbody" => ["align", "char", "charoff"],
        "td" => ["align", "char", "charoff", "colspan", "headers", "rowspan"],
        "tfoot" => ["align", "char", "charoff"],
        "th" => ["align", "char", "charoff", "colspan", "headers", "rowspan", "scope"],
        "thead" => ["align", "char", "charoff"],
        "tr" => ["align", "char", "charoff"]
      }
    },
    "allowed_tags" => [
      "a",
      "abbr",
      "acronym",
      "area",
      "article",
      "aside",
      "b",
      "bdi",
      "bdo",
      "blockquote",
      "br",
      "caption",
      "center",
      "cite",
      "code",
      "col",
      "colgroup",
      "data",
      "dd",
      "del",
      "details",
      "dfn",
      "div",
      "dl",
      "dt",
      "em",
      "figcaption",
      "figure",
      "footer",
      "h1",
      "h2",
      "h3",
      "h4",
      "h5",
      "h6",
      "header",
      "hgroup",
      "hr",
      "i",
      "img",
      "ins",
      "kbd",
      "kbd",
      "li",
      "map",
      "mark",
      "nav",
      "ol",
      "p",
      "pre",
      "q",
      "rp",
      "rt",
      "rtc",
      "ruby",
      "s",
      "samp",
      "small",
      "span",
      "strike",
      "strong",
      "sub",
      "summary",
      "sup",
      "table",
      "tbody",
      "td",
      "th",
      "thead",
      "time",
      "tr",
      "tt",
      "u",
      "ul",
      "var",
      "wbr"
    ],
    "allowed_url_scheme_on_attributes" => ["href", "src"],
    "allowed_url_schemes" => [
      "bitcoin",
      "ftp",
      "ftps",
      "geo",
      "http",
      "https",
      "im",
      "irc",
      "ircs",
      "magnet",
      "mailto",
      "mms",
      "mx",
      "news",
      "nntp",
      "openpgp4fpr",
      "sip",
      "sms",
      "smsto",
      "ssh",
      "tel",
      "url",
      "webcal",
      "wtai",
      "xmpp"
    ],
    "link_rel_values" => ["noopener", "noreferrer", "nofollow"],
    "strip_comments" => true
  }

  @sanitizer_passes [
    {Semtex.SanitizerPasses, :keep_allowed_tags},
    {Semtex.SanitizerPasses, :keep_allowed_attrs},
    {Semtex.SanitizerPasses, :keep_allowed_url_schemes},
    {Semtex.SanitizerPasses, :replace_link_rel_values},
  ]

  def sanitize!(raw_html, sanitizer_passes \\ @sanitizer_passes, config \\ @config) do
    {:ok, body_nodes} = parse_raw_html(raw_html)
    walk_nodes!(body_nodes, config, sanitizer_passes)
  end

  defp parse_raw_html(raw_html) do
    with {:ok, parsed_html} <- Html5ever.parse(raw_html) do
      unwrap_nodes(parsed_html, ["html", "body"])
    end
  end

  defp unwrap_nodes([], [_tag_to_find | _remaining_tags]) do
    {:error, "not found"}
  end

  defp unwrap_nodes([{:doctype, "html", "", ""} | nodes], remaining_tags) do
    unwrap_nodes(nodes, remaining_tags)
  end

  defp unwrap_nodes(nodes, [last_tag_to_find]) when is_list(nodes) do
    case find_node(nodes, last_tag_to_find) do
      nil ->
        {:error, "not found"}

      {_tag, _attrs, children} ->
        {:ok, children}
    end
  end

  defp unwrap_nodes(nodes, [tag_to_find | remaining_tags]) when is_list(nodes) do
    next_nodes =
      case find_node(nodes, tag_to_find) do
        nil ->
          nodes

        {_tag, _attrs, children} ->
          children
      end

    unwrap_nodes(next_nodes, remaining_tags)
  end

  defp find_node(nodes, tag_to_find) when is_list(nodes) do
    nodes
    |> Enum.find(nil, fn
      {^tag_to_find, _attrs, _children} ->
        true

      _node ->
        false
    end)
  end

  defp walk_nodes!(nodes, config, sanitizer_passes) when is_list(nodes) do
    nodes
    |> Enum.map(&walk_nodes!(&1, config, sanitizer_passes))
    |> Enum.reject(&is_nil/1)
  end

  defp walk_nodes!(node, _config, _sanitizer_passes) when is_binary(node) do
    Semtex.Escaper.escape_str(node)
  end

  defp walk_nodes!({:comment, _}, %{"strip_comments" => true}, _sanitizer_passes) do
    nil
  end

  defp walk_nodes!({:comment, _} = comment, %{"strip_comments" => false}, _sanitizer_passes) do
    comment
  end

  defp walk_nodes!(node = {_tag, _attrs, _children}, config, sanitizer_passes) do
    node
    |> dedupe_attrs_to_map()
    |> apply_sanitizer_passes(config, sanitizer_passes)
    |> walk_children(config, sanitizer_passes)
  end

  defp dedupe_attrs_to_map({tag, attrs, children}) do
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

  defp apply_sanitizer_passes(node, config, sanitizer_passes) do
    Enum.reduce_while(sanitizer_passes, node, fn {sanitizer_module, sanitizer_fn}, curr_node ->
      case apply(sanitizer_module, sanitizer_fn, [curr_node, config]) do
        {:pass} ->
          {:cont, curr_node}

        {:replace, new_node} ->
          {:cont, new_node}

        {:remove} ->
          {:halt, nil}
      end
    end)
  end

  defp walk_children(nil, _config, _sanitizer_passes) do
    nil
  end

  defp walk_children({tag, attrs, children}, config, sanitizer_passes) do
    {tag, attrs, walk_nodes!(children, config, sanitizer_passes)}
  end
end
