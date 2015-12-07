handle_error = fn
  { :ok, file } -> IO.read(file, :line)
  { _, message } -> "Error: #{:file.format_error(message)}"
end

IO.puts handle_error.(File.open('koans_test.exs'))
IO.puts handle_error.(File.open('fail.exs'))
