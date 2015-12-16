# You can require a file using:
# Code.load_file("sublist.exs")
# also mark a spec as pending with
# @tag :pending

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule KoansTest do
  use ExUnit.Case, async: true

  # @tag :pending
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
    assert f.() != name

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

  test "Exercise: Functions-5" do
    original = Enum.map [1,2,3,4], fn x -> x + 2 end
    rewritten = Enum.map [1,2,3,4], &(&1 + 2)
    assert original == rewritten

#    original = Enum.map [1,2,3,4], fn x -> IO.inspect(x) end
#    rewritten = Enum.map [1,2,3,4], &(IO.inspect(&1))
#    rewritten = Enum.map [1,2,3,4], &IO.inspect/1
#    assert original == rewritten
  end

  test "Module" do
    # woot, I can define a module here?
    defmodule Times do
      # this way to declare a named function is actually sugar
      def double(n) do
        n * 2
      end

      # and the real syntax is just passing a "do" key and a block
      def triple(n), do: (
        n * 3
      )

      def quadruple(n), do: double(double(n))
    end

    assert Times.double(9) == 18
    assert Times.triple(10) == 30
    assert Times.quadruple(10) == 40
  end

  test "Factorial" do
    defmodule Factorial do
      # this is the same function (name + arity is identical)
      # but different clauses - pattern matched from first to last
      # as well, of(0) here is the functional anchor
      def of(0), do: 1
      # clauses must be grouped together!
      def of(n), do: n * of(n-1)
    end

    assert Factorial.of(0) == 1
    assert Factorial.of(1) == 1
    assert Factorial.of(3) == 6
  end

  test "ModulesAndFunctions-5" do
    defmodule GCD do
      def gcd(x,0), do: x
      def gcd(x,y), do: gcd(y, rem(x,y))
    end

    assert GCD.gcd(10,0) == 10
    assert GCD.gcd(10,5) == 5
  end

  test "Chop" do
    # defmodule Chop do
    #   def guess(n, (low.._)) when n == low, do: n
    #   def guess(n, (_..high)) when n == high, do: n
    #   def guess(n, (low..high)) when
    #   def guess(_, (_.._)), do: "I don't know yet"
    # end

#    assert Chop.guess(1, (1..10)) == 1
#    assert Chop.guess(10, (1..10)) == 10
#    assert Chop.guess(4, (1..10)) == 4
  end

  test "Pipeline" do
    output = (1..10) |> Enum.map(&(&1 * 10)) |> Enum.filter(&(&1 > 50))
    assert output == [60, 70, 80, 90, 100]
  end

  test "Import" do
    # this is undocumented (afaik) but seems to work too
    # import List, [:flatten, 1]
    # official syntax
    import List, only: [flatten: 1]
    assert flatten([1, [2, 3]]) == [1, 2, 3]
  end

  test "List of tuples syntax" do
    assert [flatten: 1, foo: "bar"] == [ { :flatten, 1 },{ :foo, "bar" }]
  end

  test "Alias" do
    alias List, as: MyLinkedList
    import MyLinkedList, only: [flatten: 1]
    # NOTE: "alias This.That.FooBar" is the same as
    # alias This.That.FooBar, as: FooBar
  end

  test "Attributes" do
    defmodule Hello do
      # Often used like constants in Ruby
      @planet "Earth"

      def planet do
        @planet
      end
    end

    assert Hello.planet == "Earth"
  end

  test "Modules" do
    # Elixir modules are actually... atoms of a specific form
    assert List == :"Elixir.List"
  end

  test "ModulesAndFunctions-7 format" do
    # formatting (calling io will apparently put on screen, so I call io_lib)
    x = :io_lib.format("~.2f", [55.1234])
    # at this point we have ['55.12'] rather than "55.12"
    x = :erlang.iolist_to_binary(x)
    assert x == "55.12"
  end

  test "ModulesAndFunctions-7 env var" do
    # not overly needed, but just to practice a bit
    import System, only: [get_env: 1]

    assert get_env("_system_name") == "OSX"
  end

  test "ModulesAndFunctions-7 ext name" do
    assert Path.extname("dave/dave_test.exs") == ".exs"
  end

  test "ModulesAndFunctions-7 current path" do
    {:ok, _} = File.cwd()
    _ = File.cwd!()

    # raise error unless exit code is 0, using pattern matching
    {output, 0} = System.cmd("pwd", [])

    assert output |> String.strip == File.cwd!()
  end

  test "ModulesAndFunctions-7 parsing JSON" do
    _ = "{\"age\":10,\"name\":\"Mael\"}"
    # Exercise does not require to actually parse but just list libraries
    # This one could work https://github.com/devinus/poison
  end
end
