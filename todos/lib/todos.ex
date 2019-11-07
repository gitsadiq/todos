defmodule TodoList do
  @moduledoc """
  Abstraction Excersise To do list with CRUD implementation in a struct
  """

  defstruct auto_id: 1, entries: %{}

  @doc """
  Create a sturct of todolist  and adding entries  it expect list of maps and it delegate to add_entry/3
  sample-> entries =
  [
  %{date:~D[2018-12-19], title: "Dentist"},
  %{date:~D[2018-12-20], title: "Shopping"},
  %{date:~D[2018-12-19], title: "Movies"}
  ]
  """
  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, &add_entry(&2, &1))
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  @doc """
  list entries by date from a todo_list
  """
  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  @doc """
  update entry with patern matching it expect a todolist and an entry that is a map and it delegates to update_entry/3
  the updater lambda ignores the old value and return the new value 
  """
  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  @doc """
  delete and entry from a todo list by an id and return new struct
  """
  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end
end