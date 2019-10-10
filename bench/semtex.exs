load_fixture = fn file ->
  "./test/fixtures/#{file}.raw.html"
  |> File.read!()
  |> String.trim()
end

inputs = %{
  "nytimes-article" => load_fixture.("nytimes-article"),
}

Benchee.run(%{
  "parse" => fn raw_html ->
    raw_html
    |> Semtex.Parser.parse!(%{parser_module: Html5ever})
  end,
  "parse + minify" => fn raw_html ->
    raw_html
    |> Semtex.Parser.parse!(%{parser_module: Html5ever})
    |> Semtex.Minifier.minify!()
  end
}, inputs: inputs, warmup: 5, time: 10)
