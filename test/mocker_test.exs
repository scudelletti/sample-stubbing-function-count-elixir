defmodule MockerTest do
  use ExUnit.Case

  test "register function with multiple arguments and count its calls" do
    fun = fn (a, b, c) -> {a, b, c} end

    {agent, function} = Mocker.register(fun, 3)

    assert Mocker.counter(agent) == 0
    assert function.(1, 2, 3) == {1, 2, 3}
    assert function.(4, 5, 6) == {4, 5, 6}
    assert function.(7, 8, 9) == {7, 8, 9}
    assert Mocker.counter(agent) == 3
  end

  test "register function without arguments and count its calls" do
    fun = fn () -> :nothing end

    {agent, function} = Mocker.register(fun, 0)

    assert Mocker.counter(agent) == 0
    assert function.() == :nothing
    assert function.() == :nothing
    assert Mocker.counter(agent) == 2
  end

  test "register function without arguments, count its calls and returns controlled results" do
    {agent, function} = Mocker.register([1,2,3], 0)

    assert Mocker.counter(agent) == 0
    assert function.() == 1
    assert function.() == 2
    assert function.() == 3
    assert Mocker.counter(agent) == 3
  end

  test "register function with multiple arguments, count its calls and returns controlled results" do
    {agent, function} = Mocker.register([1,2,3], 2)

    assert Mocker.counter(agent) == 0
    assert function.(1, 2) == 1
    assert function.(1, 2) == 2
    assert function.(1, 2) == 3
    assert Mocker.counter(agent) == 3
  end
end
