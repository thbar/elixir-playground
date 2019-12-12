defmodule Clock do
  def start(f) do
    run(f, 0)
  end
  
  def run(function, count) do
    function.(count)
    new_count = Counter.Core.inc(count)
    :timer.sleep(1000)
    run(function, new_count)
  end
  
  def demo do
    Clock.start(fn(tick) -> IO.puts "Clock is ticking (#{tick})" end)
  end
end