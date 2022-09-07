defmodule Commandline.CLI do
  @spec main([binary]) :: :ok
  def main(args) do
    options = [
      switches: [file: :string, reset: :boolean, auth: :string],
      aliases: [f: :file, r: :reset]
    ]

    {opts, _, _} = OptionParser.parse(args, options)

    if length(opts) === 0 do
      IO.puts(
        "Usage: walgreens_pics_elixir -f <file containing map of collections> [-r] -a <auth token>"
      )

      exit(:normal)
    end

    if Keyword.get(opts, :auth) == nil do
      IO.puts(
        "Usage: walgreens_pics_elixir -f <file containing map of collections> [-r] -a <auth token>"
      )

      exit(:normal)
    end

    WalgreensPicsElixir.run(
      Keyword.get(opts, :file),
      Keyword.get(opts, :auth),
      Keyword.get(opts, :reset)
    )
  end
end
