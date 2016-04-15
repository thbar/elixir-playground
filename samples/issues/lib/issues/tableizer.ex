defmodule Tableizer do
  # A first ugly yet working method to format as ascii table
  def tableize(list_of_maps, fields) do
    # for pick the right values in the right order
    values = list_of_maps
    |> Enum.map(&(Map.values(Map.take(&1, fields))))
    
    # I cannot call to_string on a list of atoms without an exception
    # so I'm baking a working version of this here
    stringify = fn (list) -> Enum.map(list, &(to_string(&1))) end
    
    # I can now convert fields and values to a list of list of strings
    rows = [fields | values]
    |> Enum.map(stringify)
    
    columns = (0..Enum.count(fields)-1)
    
    # which allows me to compute the width of each column
    widths = for column <- columns do
      col_values = Enum.map(rows, &(Enum.at(&1, column)))
      Enum.reduce(col_values, 0, fn(x, max) -> Enum.max([String.length(x), max]) end)
    end
        
    # justify each column
    rows = for row <- rows do
      for column <- columns do
        String.ljust(Enum.at(row, column), Enum.at(widths, column))
      end
    end
    
    # tie everything together
    [h | v] = rows
    top = Enum.join(h, " | ") <> "\n"
    border = Enum.join(Enum.map(h, &(String.replace(&1, Regex.compile!("."), "-"))), "-+-") <> "\n"
    rows = for row <- v, do: Enum.join(row, " | ") <> "\n"
    Enum.join([top | [border | rows]])
  end
end