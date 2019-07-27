defmodule Ms.CacheManagement do
  @moduledoc """
  The CacheManagement context.
  """

  alias Ms.CacheManagement.Product, as: ProductCache
  alias Ms.CacheManagement.Customer, as: CustomerCache

  @doc """
    Gets customers based on key
  """
  def get_customers(key) do
    CustomerCache.get(key)
  end

  def put_customer(key, value) do
    CustomerCache.put(key, value)
  end

  def clean_customer_cache() do
    CustomerCache.clean_cache()
  end

  def get_products(key) do
    ProductCache.get(key)
  end

  def put_product(key, value) do
    ProductCache.put(key, value)
  end

  def clean_product_cache() do
    ProductCache.clean_cache()
  end
end
