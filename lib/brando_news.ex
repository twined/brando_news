defmodule Brando.News do
  @doc """
  Gets the configuration for `module` under :brando,
  as set in config.exs
  """
  def config(key) do
    case Application.get_env(:brando, Brando.News) do
      nil -> nil
      mod -> Keyword.get(mod, key, nil)
    end
  end
end
