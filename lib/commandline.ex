defmodule Commandline.CLI do
  import WalgreensPicsElixir.Console

  def main(args) do
    options = [switches: [file: :string, reset: :boolean], aliases: [f: :file, r: :reset]]
    {opts, _, _} = OptionParser.parse(args, options)
    WalgreensPicsElixir.run(Keyword.get(opts, :file), Keyword.get(opts, :reset, false))
  end

  def report(data) do
    errors = data |> Enum.filter(fn {status, _, _, _, _, _} -> status !== :ok end) |> IO.inspect()

    if Enum.count(errors) > 0 do
      IO.puts("-------- [ Error report ] ----------")
    end

    errors
    |> Enum.group_by(fn {_status, _, _, reason, _, _} -> reason end)
    |> Enum.each(fn {status, items} ->
      IO.puts(
        white(
          "--- [ #{red(atom_to_explanation(status))}#{white(" ] (#{Enum.count(items)}) ---")}"
        )
      )

      items
      |> Enum.each(fn {_status, name, url, _reason, date, album_id} ->
        IO.puts(
          white("---") <>
            date <>
            " " <> red(Path.basename(url)) <> white(" in album #{yellow(name)} #{album_id}")
        )
      end)
    end)

    :ok
  end
end
