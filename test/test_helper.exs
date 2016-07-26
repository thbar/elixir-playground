ExUnit.start
if System.get_env("FOCUS") == "1" do
  ExUnit.configure(exclude: [:test, :pending], trace: true, include: :focus)
else
  ExUnit.configure exclude: :pending, trace: true
end
