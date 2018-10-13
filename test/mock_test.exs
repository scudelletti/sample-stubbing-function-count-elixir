defmodule MockTest do
  use ExUnit.Case

  test "generates different strings" do
    refute Mock.generate() == Mock.generate()
    assert is_binary(Mock.generate())
  end

  test "uses generate/0 function by default" do
    assert {:ok, value} = Mock.generate_for()
    assert is_binary(value)
  end

  test "uses stub" do
    {:ok, agent} = Agent.start_link(fn -> {[1, 2, 3], 0} end)

    func = fn ->
      Agent.get_and_update(agent, fn state ->
        {[h | t], count} = state
        {h, {t, count + 1}}
      end)
    end

    params = %{func: func}

    assert Mock.generate_for(params) == {:ok, 1}
    assert Mock.generate_for(params) == {:ok, 2}
    assert Mock.generate_for(params) == {:ok, 3}

    {_, count} = Agent.get(agent, & &1)
    assert count == 3
  end
end
