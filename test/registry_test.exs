defmodule Companion.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Companion.Registry.start_link
    {:ok, registry: registry}
  end

  test "spawn buckets", %{registry: registry} do
    assert Companion.Registry.lookup(registry, "names") == :error
    Companion.Registry.create(registry, "names")
    assert {:ok, bucket} = Companion.Registry.lookup(registry, "names")

    Companion.Bucket.put(bucket, "creator", "Joao")
    assert Companion.Bucket.get(bucket, "creator") == "Joao"
  end

  test "removes buckets on exit", %{registry: registry} do
    Companion.Registry.create(registry, "names")
    {:ok, bucket} = Companion.Registry.lookup(registry, "names")
    Agent.stop(bucket)
    assert Companion.Registry.lookup(registry, "names") == :error
  end
end
