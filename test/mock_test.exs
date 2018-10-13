defmodule MockTest do
  use ExUnit.Case

  test "generates de same thing twice" do
    IO.inspect Mock.generate
    IO.inspect Mock.generate
    IO.inspect Mock.generate
  end

  test "generates the same thing using a inner function" do
    {:ok, agent} = Agent.start_link fn -> {[1,1,2], 0} end

    func = fn -> Agent.get_and_update(agent, fn state -> {[h|t], count} = state; {h, {t, count + 1}} end) end
    params = %{func: func}

    IO.inspect Mock.generate_for(params)
    IO.inspect Mock.generate_for(params)
    IO.inspect Mock.generate_for(params)

    IO.inspect Agent.get(agent, &(&1))
    {_, count} = Agent.get(agent, &(&1))
    IO.inspect count
  end
end
