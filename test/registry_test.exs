defmodule Companion.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Companion.Registry.start_link
    {:ok, registry: registry}
  end

  test "spawn buckets", %{registry: registry} do

  end
end
