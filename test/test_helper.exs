ExUnit.start
if System.get_env("FOCUS") == "1" do
  # When focusing, I use trace false to unclutter the output from non-focused tests
  ExUnit.configure(exclude: [:test, :pending], trace: false, include: :focus)
else
  ExUnit.configure exclude: :pending, trace: true
end
