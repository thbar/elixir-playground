defmodule Day0601 do
  def parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  def taxi_dist({px, py}, {x, y}), do: abs(px-x) + abs(py-y)

  def taxi_dist_closest(coordinates, p) do
    {_d, winners} = coordinates
    |> Enum.group_by(&(taxi_dist(&1, p)))
    |> Enum.min_by(fn {d, _} -> d end)

    winners
  end
  
  def bounding_box(coordinates) do
    {x, y} = Enum.unzip(coordinates)
    %{
      x1: Enum.min(x) - 1,
      y1: Enum.min(y) - 1,
      x2: Enum.max(x) + 1,
      y2: Enum.max(y) + 1
    }
  end
  
  def process(file) do
    coordinates = file
    |> File.stream!
    |> Enum.map(&parse_line/1)
    
    bb = bounding_box(coordinates)
    
    closest = Enum.reduce (bb.y1..bb.y2), Map.new, fn(y, acc) -> 
      Enum.reduce (bb.x1..bb.x2), acc, fn(x, acc) ->
        Map.put acc, {x,y},
          %{
            closest: taxi_dist_closest(coordinates, {x,y}),
            border: (x == bb.x1) || (x == bb.x2) || (y == bb.y1) || (y == bb.y2)
          }
      end
    end

    closest = closest
    |> Enum.reject(fn {_,%{closest: c}} -> Enum.count(c) > 1 end)
    
    infinites = closest
    |> Enum.filter(fn {_,v} -> v.border end)
    |> Enum.map(fn {_,v} -> v.closest end)
    |> List.flatten
    |> Enum.uniq
    
    closest
    |> Enum.group_by(fn {_, %{closest: [c]}} -> c end)
    |> Map.drop(infinites)
    |> Enum.map(fn {_,v} -> Enum.count(v) end)
    |> Enum.max
  end
end

