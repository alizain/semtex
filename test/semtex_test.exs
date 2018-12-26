defmodule SemtexTest do
  use ExUnit.Case
  # doctest Semtex

  @config_file "./default_config.json"
  @config with body <- File.read!(@config_file),
               json <- Jason.decode!(body), do: json

end
