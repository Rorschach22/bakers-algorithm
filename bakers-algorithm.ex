#Ryan McArthur and Mitch Finzel


#borrowed this fib function from https://gist.github.com/kyanny/2026028

defmodule Fib do
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end
end

defmodule Manager do
  def thing([], []) do
    receive do
      {:addCustomer, sender} ->
        thing([sender] ,[])
      {:addServer, sender} ->
        thing([],[sender])
    end
  end
  def thing([c|customer],[]) do
    receive do
      {:addCustomer, sender} ->
        thing([c] ++ customer ++ [sender], [])
      {:addServer, sender} ->
        send(c, {:getFib, sender})
        thing(customer, [])
    end
  end
  def thing([], [s|server]) do
    receive do
      {:addCustomer, sender} ->
        send(sender, {:getFib, s})
        thing([], server)
      {:addServer, sender} ->
        thing([], [s] ++ server ++ [sender])
    end
  end
end

defmodule Customer do
  def start do
    wait = :random.uniform(1000)
    :timer.sleep(wait)
    customer = spawn(&__MODULE__.loop/0)
    send(customer, {:wakeUp})
  end
  def loop do
    receive do
      {:wakeUp} ->
        send(:manager, {:addCustomer, self()})
        loop
      {:heresYourFib, fibReturn} ->
        IO.puts("Customer #{inspect self()} received the number #{fibReturn}")
      {:getFib, sender} ->
        :random.seed(:os.timestamp)
        fib = (:random.uniform(5) + 35)
        send(sender, {:computeFib, self(), fib})
        loop
    end
  end
end

defmodule Server do
  def start do
    server = spawn(&__MODULE__.loop/0)
    send(:manager, {:addServer, server})
  end
  def loop do
    receive do
      {:computeFib, customer, fib} ->
        IO.puts("Server #{inspect self()} computing fib of #{fib} for #{inspect customer}")
        send(customer, {:heresYourFib, Fib.fib(fib)})
        send(:manager, {:addServer, self()})
        loop
    end
  end
end

pid = spawn(Manager, :thing, [[], []])
Process.register(pid, :manager)
Server.start()
Server.start()
Server.start()
Server.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()
Customer.start()

#The processes seem to not finish unless it waits for something here
#We think there is some kind of way to deal with this like there was in clojure
#We are not quite sure how to deal with it so this is what we came up with.
#Will ask questions in class
:timer.sleep(15000)
