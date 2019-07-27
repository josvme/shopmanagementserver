defmodule Ms.OrderManagement do
  @moduledoc """
  The OrderManagement context.
  """

  import Ecto.Query, warn: false
  alias Ms.Repo

  alias Ms.OrderManagement.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order) |> Repo.preload(:order_items)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id, params \\%{}) do
    Repo.get!(Order, id)
    |> Repo.preload(:order_items)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    response = %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()

    case response do
      {:ok, order} ->
        Enum.map(attrs["order_items"], fn oi -> create_order_item(Map.merge(oi, %{"order_id" => order.id})) end)
        {:ok, order |> Repo.preload(:order_items) }

      {:error, e} -> {:error, e}
    end
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    response = order
               |> Order.changeset(attrs)
               |> Repo.update()

    with {:ok, order} <- response do
      preloaded_order = order |> Repo.preload(:order_items)
      existing_order_items = preloaded_order.order_items
      # If order items doesn't exist we provide []
      new_order_items = attrs["order_items"] || []

      # We delete all existing order items which are not in new order items
      for order_item <- existing_order_items do
        case Enum.filter(new_order_items, fn x -> Map.get(x, "id") == Map.get(order_item, "id") end) do
          [] -> delete_order_item(order_item)
          _ -> []
        end
      end

      # We loop through all new order items and if already existing in our order, we just update them.
      for order_item <- new_order_items do
        case Enum.filter(existing_order_items, fn x -> Map.get(x, "id") == Map.get(order_item, "id") end) do
          [] -> create_order_item(Map.merge(order_item, %{"order_id" => order.id}))
          [found] -> update_order_item(found, Map.merge(order_item, %{"order_id" => order.id}))
        end
      end

      {
        :ok,
        order
        |> Repo.preload(:order_items)
      }
    end
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end

  alias Ms.OrderManagement.OrderItem

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItem)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderItem.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_order_item(order_item)
      %Ecto.Changeset{source: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item) do
    OrderItem.changeset(order_item, %{})
  end
end
