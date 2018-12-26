defmodule SemtexTest do
  use ExUnit.Case
  doctest Semtex

  @config_file "./default_config.json"
  @config with body <- File.read!(@config_file),
               json <- Jason.decode!(body), do: json

  @html_str """
            <CENTER something="not"><IMG SRC="clouds.jpg" ALIGN="BOTTOM"> </CENTER>
            <HR>
            <!-- this is a comment -->
            <a href="http://somegreatsite.com" rel="hahaha haha haha">Link Name</a>
            is a link to another nifty site
            <H1>This is a Header</H1>
            <H2>This is a Medium Header</H2>
            Send me mail at <a href="mailto:support@yourcompany.com">
            support@yourcompany.com</a>.
            <P> This is a new paragraph!
            <P> <B>This is a new paragraph!</B>
            <BR> <B><I>This is a new sentence without a paragraph break, in bold italics.</I></B>
            <HR>
            """

  test "greets the world" do
    assert Semtex.sanitize(@html_str, @config) == :world
  end
end
