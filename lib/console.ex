defmodule WalgreensPicsElixir.Console do
  def red(str) do
    IO.ANSI.red() <> str <> IO.ANSI.reset()
  end

  def green(str) do
    IO.ANSI.green() <> str <> IO.ANSI.reset()
  end

  def white(str) do
    IO.ANSI.white() <> str <> IO.ANSI.reset()
  end

  def yellow(str) do
    IO.ANSI.yellow() <> str <> IO.ANSI.reset()
  end

  def atom_to_explanation(atom) do
    case atom do
      :ok -> "Success"
      :timeout -> "Timeout encountered while downloading"
      :enetunreach -> "Network unreachable"
    end
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
