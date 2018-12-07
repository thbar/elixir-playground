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
    x1 = coordinates
    |> Enum.map(&(elem(&1,0)))
    |> Enum.min
    
    x2 = coordinates
    |> Enum.map(&(elem(&1,0)))
    |> Enum.max
    
    y1 = coordinates
    |> Enum.map(&(elem(&1,1)))
    |> Enum.min

    y2 = coordinates
    |> Enum.map(&(elem(&1,1)))
    |> Enum.max

    %{x1: x1-1, y1: y1-1, x2: x2+1, y2: y2+1}
  end
  
  def process(file) do
    coordinates = file
    |> File.stream!
    |> Enum.map(&parse_line/1)
    
    bb = bounding_box(coordinates)
    
    closest = Enum.reduce (bb.y1..bb.y2), Map.new, fn(y, acc) -> 
      Enum.reduce (bb.x1..bb.x2), acc, fn(x, acc) ->
        border = cond do
          x == bb.x1 -> true
          x == bb.x2 -> true
          y == bb.y1 -> true
          y == bb.y2 -> true
          true -> false
        end
        Map.put acc, {x,y},
          %{
            closest: taxi_dist_closest(coordinates, {x,y}),
            border: border
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

