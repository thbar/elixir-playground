defmodule Tableizer do
  def ascii_table(list_of_maps, fields) do
    convert_to_array(list_of_maps, fields)
    |> stringify
    |> ljust
    |> tableize
  end

  def convert_to_array(list_of_maps, fields) do
    # I used "take" before but order was not guaranteed
    fetcher = fn (row) -> Enum.map(fields, &(row[&1])) end

    # for pick the right values in the right order
    [fields | Enum.map(list_of_maps, fetcher)]
  end

  @doc """
  Convert each item to string in a list of list

  ## Examples

      iex> Tableizer.stringify([[1, :test], [100.5, "hello"]])
      [["1","test"],["100.5","hello"]]
  """
  def stringify(rows) do
    # I cannot call to_string on a list of atoms without an exception
    # so I'm baking a working version of this here
    stringify = fn (list) -> Enum.map(list, &(to_string(&1))) end

    # I can now convert fields and values to a list of list of strings
    Enum.map(rows, stringify)
  end

  def compute_max_width(rows) do
    columns = rows |> Enum.at(0) |> Enum.count
    for column <- (0..columns-1) do
      col_values = Enum.map(rows, &(Enum.at(&1, column)))
      Enum.reduce(col_values, 0, fn(x, max) -> Enum.max([String.length(x), max]) end)
    end
  end

  def ljust(rows) do
    widths = compute_max_width(rows)

    [fields | _] = rows
    columns = (0..Enum.count(fields)-1)

    # justify each column
    for row <- rows do
      for column <- columns do
        String.ljust(Enum.at(row, column), Enum.at(widths, column))
      end
    end
  end

  def tableize(rows) do
    # tie everything together
    [h | v] = rows
    top = Enum.join(h, " | ")
    border = Enum.map_join(h, "-+-", &(String.replace(&1, ~r/./, "-")))
    rows = for row <- v, do: Enum.join(row, " | ")
    Enum.join([top | [border | rows]], "\n") <> "\n"
  end
end
