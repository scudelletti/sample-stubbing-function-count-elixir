defmodule Mock do
  def generate do
    Base.encode16(:crypto.strong_rand_bytes(10))
  end

  def generate_for() do
    generate_for(%{func: &generate/0})
  end

  def generate_for(%{func: func}) do
    random = func.()
    {:ok, random}
  end
end
