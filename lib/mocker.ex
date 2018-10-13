defmodule Mocker do
  defstruct counter: 0, function: nil, list: nil

  use Agent

  @max_number_of_arguments 5

  Enum.each(0..@max_number_of_arguments, fn n ->
    def register(list, unquote(n)) when is_list(list) do
      {:ok, agent} = Agent.start_link(fn -> %Mocker{list: list} end)

      funx = fn unquote_splicing(Macro.generate_arguments(n, __MODULE__)) ->
        Agent.get_and_update(agent, fn state ->
          [h | t] = state.list
          {h, %{state | list: t, counter: state.counter + 1}}
        end)
      end

      {agent, funx}
    end

    def register(function, unquote(n)) when is_function(function) do
      {:ok, agent} = Agent.start_link(fn -> %Mocker{function: function} end)

      {agent, generate_function(agent, unquote(n))}
    end

    def generate_function(agent, unquote(n)) do
      fn unquote_splicing(Macro.generate_arguments(n, __MODULE__)) ->
        Agent.get_and_update(agent, fn state ->
          {state.function.(unquote_splicing(Macro.generate_arguments(n, __MODULE__))),
           %{state | counter: state.counter + 1}}
        end)
      end
    end
  end)

  def counter(pid) do
    Agent.get(pid, & &1.counter)
  end
end
