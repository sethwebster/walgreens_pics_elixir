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
end
