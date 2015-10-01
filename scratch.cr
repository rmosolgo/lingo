abstract class InputObject
  @name = :no_name
  def name
    @name
  end
end

class System
  macro input(input_name)
    class {{input_name.id}}Input < InputObject
      @name = {{input_name}}
    end
  end
end

class CallbackRegistry
  alias Callback = InputObject -> Nil
  alias CallbackList = Array(Callback)
  alias CallbackStorage = Hash(Symbol, CallbackList)

  macro inherited
    @@callbacks = CallbackStorage.new do |h, k|
      h[k] = CallbackList.new
    end
  end

  macro add_callback(name, &block)
    @@callbacks[{{name}}] << Callback.new { |input|
      {{block.body}}
      nil
    }
  end

  def run_callbacks(input_object)
    callbacks = @@callbacks[input_object.name]
    callbacks.each do |callback|
      callback.call(input_object)
    end
    nil
  end
end

class CustomSystem < System
  input(:Number)
end

class CustomCallbacks < CallbackRegistry
  add_callback(:Number) {
    puts "Hello, number"
  }
end

callbacks = CustomCallbacks.new
input = CustomSystem::NumberInput.new
callbacks.run_callbacks(input)
