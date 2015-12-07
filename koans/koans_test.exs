# You can require a file using:
# Code.load_file("sublist.exs")
# also mark a spec as pending with
# @tag :pending

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule KoansTest do
  use ExUnit.Case, async: true

  test "function declaration and invocation" do
    # declare an anonymous function 
    # a and b are /not/ assigned (this doesn't exist in Elixir)
    # but rather, pattern matched
    sum = fn (a, b) -> a + b end
    # use a dot to call anonymous function
    assert sum.(2, 10) == 12
    
    # the fact that pattern matching is used allows for more complex calls
    tuple_sum = fn { a, b, c, d } -> a + b + c + d end
    assert tuple_sum.({ 10, 100, 1000, 10000 }) == 11110
  end
  
  test "Function-1 exercise" do
    list_concat = fn (a, b) -> a ++ b end
    assert list_concat.([:a , :b], [:c, :d]) == [:a, :b, :c, :d]
    
    sum = fn (a, b, c) -> a + b + c end
    assert sum.(1, 2, 3) == 6
    
    pair_tuple_to_list = fn { a, b } -> [a, b] end
    assert pair_tuple_to_list.({ 1234, 5678 }) == [1234, 5678]
  end
  
#  @tag :pending
  test "Multiple bodies" do
    # here we have multiple bodies for the same function
    # the args are pattern matched to figure out what should be invoked
    # :file refers to the Erlang File module, not to the File elixir module
    handle_open = fn
      { :ok, opened_file } -> IO.read(opened_file, :all)
      { _, error } -> :file.format_error(error)
    end
    
    output = handle_open.(File.open("koans_test.exs"))
    assert String.contains?(output, "KoansTest")

    output = handle_open.(File.open("do_not_exist"))
    # NOTE: I cannot compare using contains? - I believe the output
    # maps to :binary.match/2, which fails
    # assert String.contains?(output, "no such file or directory")
    assert output == 'no such file or directory'
  end
  
  test "FizzBuzz" do
    fizzbuzz = fn
      (0, 0, _) -> "FizzBuzz"
      (0, _, _) -> "Fizz"
      (_, 0, _) -> "Buzz"
      (_, _, word) -> word
    end
    
    assert fizzbuzz.(0, 0, "Foo") == "FizzBuzz"
    assert fizzbuzz.(0, 100, "Foo") == "Fizz"
    assert fizzbuzz.(100, 0, "Foo") == "Buzz"
    assert fizzbuzz.(100, 100, "Foo") == "Foo"
    
    func = fn (n) -> fizzbuzz.(rem(n,3), rem(n,5), n) end
    
    result = Enum.join(Enum.map((10..16), func), ", ")
    assert result == "Buzz, 11, Fizz, 13, 14, FizzBuzz, 16"
  end
  
  test "Function context" do
    name = "Franck"
    f = fn -> name end
    name = "Barry"
    
    assert f.() == "Franck"
    
    f = fn (from) ->
      fn (to) -> "Hello #{to} from #{from}" end
    end
    
    x = f.("John")
    assert x.("Marisa") == "Hello Marisa from John"
    assert x.("Theresa") == "Hello Theresa from John"
  end
  
  test "Parameterized functions" do
    prefix = fn (the_prefix) -> fn(the_string) -> "#{the_prefix} #{the_string}" end end
    mrs = prefix.("Mrs")
    assert mrs.("Smith") == "Mrs Smith"
    assert prefix.("Elixir").("Rocks") == "Elixir Rocks"
  end

  test "Passing functions as arguments" do
    times_2 = fn (x) -> 2 * x end
    apply = fn (fun, value) -> fun.(value) end
    
    assert apply.(times_2, 8) == 16
  end
  
  test "The & notation" do
    times_2 = &(&1 * 2)
    assert times_2.(9) == 18
    
    multiply = &(&1 * &2)
    assert multiply.(20, 10) == 200
    
    # Elixir will remove the indirection here
    # &(IO.puts(&1))
  end
  
  test "Tuples functions" do
    divrem = fn (a, b) -> { div(a, b), rem(a, b) } end
    assert divrem.(10, 3) == { 3, 1 }
    
    short_divrem = &{div(&1, &2), rem(&1, &2)}
    assert short_divrem.(10, 3) == { 3, 1 }
  end
end
