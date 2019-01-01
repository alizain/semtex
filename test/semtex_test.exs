defmodule SemtexTest do
  use ExUnit.Case
  # doctest Semtex

  def test_html_sanitization(html_str) do
    html_str
    |> String.trim()
    |> Semtex.sanitize!()
    |> Semtex.serialize!()
  end

  def test_html_minification(html_str, config) do
    html_str
    |> Semtex.Parser.parse!()
    |> Semtex.minify!(config)
    |> Semtex.serialize!(config)
  end

  describe "Big List of Naughty Strings (BLNS)" do
    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&lt;script&gt;alert&#x28;&#x27;123&#x27;&#x29;&#x3B;&lt;&#x2F;script&gt;" == test_html_sanitization("&lt;script&gt;alert(&#39;123&#39;);&lt;/script&gt;")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=alert(123) />")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<svg><script>123<1>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&gt;" == test_html_sanitization("\"><script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&gt;" == test_html_sanitization("'><script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&gt;" == test_html_sanitization("><script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("</script><script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "onfocus&#x3D;JaVaSCript:alert&#x28;123&#x29;&#x20;autofocus" == test_html_sanitization(" onfocus=JaVaSCript:alert(123) autofocus")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x20;onfocus&#x3D;JaVaSCript:alert&#x28;123&#x29;&#x20;autofocus" == test_html_sanitization("\" onfocus=JaVaSCript:alert(123) autofocus")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&#x20;onfocus&#x3D;JaVaSCript:alert&#x28;123&#x29;&#x20;autofocus" == test_html_sanitization("' onfocus=JaVaSCript:alert(123) autofocus")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "＜script＞alert&#x28;123&#x29;＜&#x2F;script＞" == test_html_sanitization("＜script＞alert(123)＜/script＞")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<sc<script>ript>alert(123)</sc</script>ript>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x2D;&#x2D;&gt;" == test_html_sanitization("--><script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x3B;alert&#x28;123&#x29;&#x3B;t&#x3D;&quot;" == test_html_sanitization("\";alert(123);t=\"")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&#x3B;alert&#x28;123&#x29;&#x3B;t&#x3D;&#x27;" == test_html_sanitization("';alert(123);t='")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "JavaSCript:alert&#x28;123&#x29;" == test_html_sanitization("JavaSCript:alert(123)")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x3B;alert&#x28;123&#x29;&#x3B;" == test_html_sanitization(";alert(123);")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "src&#x3D;JaVaSCript:prompt&#x28;132&#x29;" == test_html_sanitization("src=JaVaSCript:prompt(132)")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&gt;" == test_html_sanitization("\"><script>alert(123);</script x=\"")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&gt;" == test_html_sanitization("'><script>alert(123);</script x='")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&gt;" == test_html_sanitization("><script>alert(123);</script x=")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x20;autofocus&#x20;onkeyup&#x3D;&quot;javascript:alert&#x28;123&#x29;" == test_html_sanitization("\" autofocus onkeyup=\"javascript:alert(123)")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&#x20;autofocus&#x20;onkeyup&#x3D;&#x27;javascript:alert&#x28;123&#x29;" == test_html_sanitization("' autofocus onkeyup='javascript:alert(123)")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x20type=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x3Etype=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x0Dtype=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x09type=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x0Ctype=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x2Ftype=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script\\x0Atype=\"text/javascript\">javascript:alert(1);</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&#x60;&quot;&gt;&lt;\\x3Cscript&gt;javascript:alert&#x28;1&#x29;" == test_html_sanitization("'`\"><\\x3Cscript>javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x27;&#x60;&quot;&gt;&lt;\\x00script&gt;javascript:alert&#x28;1&#x29;" == test_html_sanitization("'`\"><\\x00script>javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x\\x3Aexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:expression\\x5C(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:expression\\x00(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:exp\\x00ression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:exp\\x5Cression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x0Aexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x09expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE3\\x80\\x80expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x84expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xC2\\xA0expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x80expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x8Aexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x0Dexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x0Cexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x87expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xEF\\xBB\\xBFexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x20expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x88expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x00expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x8Bexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x86expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x85expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x82expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\x0Bexpression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x81expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x83expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "ABC<div>DEF</div>" == test_html_sanitization("ABC<div style=\"x:\\xE2\\x80\\x89expression(javascript:alert(1)\">DEF")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x0Bjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x0Fjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xC2\\xA0javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x05javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE1\\xA0\\x8Ejavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x18javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x11javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x88javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x89javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x80javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x17javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x03javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x0Ejavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x1Ajavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x00javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x10javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x82javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x20javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x13javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x09javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x8Ajavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x14javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x19javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\xAFjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x1Fjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x81javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x1Djavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x87javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x07javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE1\\x9A\\x80javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x83javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x04javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x01javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x08javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x84javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x86javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE3\\x80\\x80javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x12javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x0Djavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x0Ajavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x0Cjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x15javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\xA8javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x16javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x02javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x1Bjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x06javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\xA9javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x80\\x85javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x1Ejavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\xE2\\x81\\x9Fjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"\\x1Cjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"javascript\\x00:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"javascript\\x3A:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"javascript\\x09:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"javascript\\x0D:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">test</a>" == test_html_sanitization("<a href=\"javascript\\x0A:javascript:alert(1)\" id=\"fuzzelement1\">test</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x0Aonerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x22onerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x0Bonerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x0Donerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x2Fonerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x09onerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x0Conerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x00onerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x27onerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&#x60;&quot;&#x27;&gt;<img/>" == test_html_sanitization("`\"'><img src=xxx:x \\x20onerror=javascript:alert(1)>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x3Bjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x0Djavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xEF\\xBB\\xBFjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x81javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x84javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE3\\x80\\x80javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x09javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x89javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x85javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x88javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x00javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\xA8javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x8Ajavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE1\\x9A\\x80javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x0Cjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x2Bjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xF0\\x90\\x96\\x9Ajavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>-javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x0Ajavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\xAFjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x7Ejavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x87javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x81\\x9Fjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\xA9javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xC2\\x85javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xEF\\xBF\\xAEjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x83javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x8Bjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xEF\\xBF\\xBEjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x80javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x21javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x82javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE2\\x80\\x86javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xE1\\xA0\\x8Ejavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x0Bjavascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\x20javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&quot;&#x60;&#x27;&gt;" == test_html_sanitization("\"`'><script>\\xC2\\xA0javascript:alert(1)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x00src=x onerror=\"alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x47src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x11src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x12src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img\\x47src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img\\x10src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img\\x13src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img\\x32src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img\\x47src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img\\x11src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x47src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x34src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x39src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img \\x00src=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x09=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x10=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x13=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x32=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x12=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x11=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x00=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src\\x47=x onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x\\x09onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x\\x10onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x\\x11onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x\\x12onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x\\x13onerror=\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<img[a][b][c]src[d]=x[e]onerror=[f]\"alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=\\x09\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=\\x10\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=\\x11\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=\\x12\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=\\x32\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=x onerror=\\x00\"javascript:alert(1)\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a rel=\"noopener&#x20;noreferrer&#x20;nofollow\">XXX</a>" == test_html_sanitization("<a href=java&#1&#2&#3&#4&#5&#6&#7&#8&#11&#12script:javascript:alert(1)>XXX</a>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<img src=\"x` `<script>javascript:alert(1)</script>\"` `>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img src=\"\"/>" == test_html_sanitization("<img src onerror /\" '\"= alt=javascript:alert(1)//\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<title onpropertychange=javascript:alert(1)></title><title title=>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<a href=\"http://foo.bar/#x=%60y\" rel=\"noopener&#x20;noreferrer&#x20;nofollow\"></a><img alt=\"&#x60;&gt;&lt;img&#x20;src&#x3D;x:x&#x20;onerror&#x3D;javascript:alert&#x28;1&#x29;&gt;&lt;&#x2F;a&gt;\"/>" == test_html_sanitization("<a href=http://foo.bar/#x=`y></a><img alt=\"`><img src=x:x onerror=javascript:alert(1)></a>\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<!--[if]><script>javascript:alert(1)</script -->")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<!--[if<img src=x onerror=javascript:alert(1)//]> -->")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script src=\"/\\%(jscript)s\"></script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<script src=\"\\\\%(jscript)s\"></script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>&quot;&gt;" == test_html_sanitization("<IMG \"\"\"><SCRIPT>alert(\"XSS\")</SCRIPT>\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=# onmouseover=\"alert('xxs')\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC= onmouseover=\"alert('xxs')\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG onmouseover=\"alert('xxs')\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=\"jav   ascript:alert('XSS');\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=\"jav&#x09;ascript:alert('XSS');\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=\"jav&#x0A;ascript:alert('XSS');\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=\"jav&#x0D;ascript:alert('XSS');\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "perl&#x20;&#x2D;e&#x20;&#x27;print&#x20;&quot;<img/>&quot;&#x3B;&#x27;&#x20;&gt;&#x20;out" == test_html_sanitization("perl -e 'print \"<IMG SRC=java\\0script:alert(\\\"XSS\\\")>\";' > out")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<img/>" == test_html_sanitization("<IMG SRC=\" &#14;  javascript:alert('XSS');\">")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<SCRIPT/XSS SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<BODY onload!#$%&()*~+-_.,:;?@[/|\\]^`=alert(\"XSS\")>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<SCRIPT/SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&lt;" == test_html_sanitization("<<SCRIPT>alert(\"XSS\");//<</SCRIPT>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<SCRIPT SRC=http://ha.ckers.org/xss.js?< B >")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<SCRIPT SRC=//ha.ckers.org/.j>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<IMG SRC=\"javascript:alert('XSS')\"")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<iframe src=http://ha.ckers.org/scriptlet.html <")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "\\&quot;&#x3B;alert&#x28;&#x27;XSS&#x27;&#x29;&#x3B;&#x2F;&#x2F;" == test_html_sanitization("\\\";alert('XSS');//")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<u>&#x20;Copy&#x20;me</u>" == test_html_sanitization("<u oncopy=alert()> Copy me</u>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "<i>&#x20;Scroll&#x20;over&#x20;me&#x20;</i>" == test_html_sanitization("<i onwheel=alert(1)> Scroll over me </i>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("<plaintext>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "http:&#x2F;&#x2F;a&#x2F;&#x25;&#x25;30&#x25;30" == test_html_sanitization("http://a/%%30%30")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "" == test_html_sanitization("</textarea><script>alert(123)</script>")
    end

    test "#{System.unique_integer([:positive, :monotonic])}" do
      assert "&lt;&#x20;&#x2F;&#x20;script&#x20;&gt;&lt;&#x20;script&#x20;&gt;alert&#x28;123&#x29;&lt;&#x20;&#x2F;&#x20;script&#x20;&gt;" == test_html_sanitization("< / script >< script >alert(123)< / script >")
    end
  end

  def round_trip_file(file, config) do
    actual =
      "#{file}.raw.html"
      |> File.read!()
      |> String.trim()
      |> test_html_minification(config)

    expected =
      "#{file}.expected.html"
      |> File.read!()
      |> String.trim()

    {actual, expected}
  end

  describe "Parse, minify, and serialize" do
    setup do
      config = %{ Semtex.config() | "escape_serialization" => false }
      {:ok, config: config}
    end

    test "h5bp", %{config: config} do
      {actual, expected} =
        round_trip_file("./test/fixtures/h5bp", config)

      assert actual == expected
    end

    test "nytimes-article", %{config: config} do
      {actual, expected} =
        round_trip_file("./test/fixtures/nytimes-article", config)

      assert actual == expected
    end

    test "ots-admin-listing-show", %{config: config} do
      {actual, expected} =
        round_trip_file("./test/fixtures/ots-admin-listing-show", config)

      assert actual == expected
    end
  end
end
