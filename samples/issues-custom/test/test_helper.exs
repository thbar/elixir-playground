ExUnit.start()
# trace: true is apparently activating the "documentation" kind of formatter
ExUnit.configure exclude: :pending, trace: true