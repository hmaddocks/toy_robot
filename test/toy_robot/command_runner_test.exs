defmodule ToyRobot.CommandRunnerTest do
  use ExUnit.Case, async: true
  alias ToyRobot.{CommandRunner, Simulation}
  import ExUnit.CaptureIO

  test "handles a vlaid place command" do
    %Simulation{robot: robot} =
      CommandRunner.run([{:place, %{east: 1, north: 2, facing: :north}}])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "handles an invalid place command" do
    simulation = CommandRunner.run([{:place, %{east: 10, north: 10, facing: :north}}])
    assert simulation == nil
  end

  test "ignores commands unitl a valid place command is given" do
    %Simulation{robot: robot} =
      [:move, {:place, %{east: 1, north: 2, facing: :north}}]
      |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "handles a place + a move command" do
    %Simulation{robot: robot} =
      [{:place, %{east: 1, north: 2, facing: :north}}, :move]
      |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 3
    assert robot.facing == :north
  end

  test "handles a place + an invalid move command" do
    %Simulation{robot: robot} =
      [{:place, %{east: 1, north: 4, facing: :north}}, :move]
      |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 4
    assert robot.facing == :north
  end

  test "handles a place + a turn_left command" do
    %Simulation{robot: robot} =
      [
        {:place, %{east: 1, north: 2, facing: :north}},
        :turn_left
      ]
      |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :west
  end

  test "handles a place + a turn_right command" do
    %Simulation{robot: robot} =
      [
        {:place, %{east: 1, north: 2, facing: :north}},
        :turn_right
      ]
      |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :east
  end

  test "handle a place + a report command" do
    commands = [{:place, %{east: 1, north: 2, facing: :north}}, :report]

    output = capture_io(fn -> CommandRunner.run(commands) end)

    assert output == "The robot is at (1, 2) and is facing NORTH\n"
  end

  test "handl a place + an invlaid command" do
    %Simulation{robot: robot} =
      [
        {:place, %{east: 1, north: 2, facing: :north}},
        {:invalid, "EXTERMINATE"}
      ]
      |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end
end
