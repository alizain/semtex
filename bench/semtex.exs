load_fixture = fn file ->
  "./test/fixtures/#{file}.raw.html"
  |> File.read!()
  |> String.trim()
end

inputs = %{
  "nytimes-article" => load_fixture.("nytimes-article"),
  # "ots-admin-listing-show" => load_fixture.("ots-admin-listing-show"),
  # "h5bp" => load_fixture.("h5bp"),
}

Benchee.run(%{
  "parse" => fn raw_html ->
    raw_html
    |> Semtex.Parser.parse!()
  end,
  "parse + minify" => fn raw_html ->
    raw_html
    |> Semtex.Parser.parse!()
    |> Semtex.minify!()
  end
}, inputs: inputs, warmup: 5, time: 10)
