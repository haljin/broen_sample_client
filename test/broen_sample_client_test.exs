defmodule BroenSampleClientTest do
  use ExUnit.Case
  doctest BroenSampleClient

  test "greets the world" do
    assert BroenSampleClient.hello() == :world
  end
end
