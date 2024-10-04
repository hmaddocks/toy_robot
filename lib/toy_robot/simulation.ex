defmodule ToyRobot.Simulation do
  alias ToyRobot.Robot
  alias ToyRobot.Simulation
  alias ToyRobot.Table

  defstruct [:table, :robot]

  @doc """
  Simulate placing a robot on a table.

  ## Examples

  When the robot is paced in a valid position

      iex> alias ToyRobot.{Robot, Table, Simulation}
      [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
      iex> table = %Table{north_boundary: 4, east_boundary: 4}
      %Table{east_boundary: 4, north_boundary: 4}
      iex> Simulation.place(table, %{north: 0, east: 0, facing: :north})
      {
        :ok,
        %Simulation{
          table: table,
          robot: %Robot{east: 0, north: 0, facing: :north},
        }
      }

  When the robot is placed in an invalid position:

      iex> alias ToyRobot.{Table, Simulation}
      [ToyRobot.Table, ToyRobot.Simulation]
      iex> table = %Table{north_boundary: 4, east_boundary: 4}
      %Table{north_boundary: 4, east_boundary: 4}
      iex> Simulation.place(table, %{north: 6, east: 0, facing: :north})
      {:error, :invalid_placement}

  """
  def place(table, placement) do
    if Table.valid_position?(table, placement) do
      {
        :ok,
        %Simulation{
          table: table,
          robot: struct(Robot, placement)
        }
      }
    else
      {:error, :invalid_placement}
    end
  end
end
