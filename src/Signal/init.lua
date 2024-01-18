----- Types -----
local types = script.Types
local Signal = require(types.Signal)
type Args = { [number]: any, n: number }
export type Signal<Function, Returns...> = Signal.Signal<Function, Returns...>

----- Modules -----
local modules = script
local Connection = require(modules.Connection)

----- Private Methods -----
local function MergeArgs(args1: Args, args2: Args): Args
    for key, value in args2 do
        if type(key) == "string" and key == "n" then
            args1.n += value
        else
            table.insert(args1, value)
        end
    end
    return args1
end

----- Module Tables -----
local SignalProperties: Signal.SignalProperties = {
    _Connections = {},
    _OnceConnections = {},
    _WaitConnections = {},
}

local SignalMethods: Signal.SignalMethods<any, ...any> = {
    Connect = function(self, func, ...)
        local connection = Connection.new()
        table.insert(self._Connections, { Connection = connection, Func = func, Args = table.pack(...) })
        return connection
    end,

    Wait = function(self)
        local currentCoroutine = coroutine.running()
        local waitConnection = { Coroutine = currentCoroutine, ReturnData = {} }
        table.insert(self._WaitConnections, waitConnection)
        coroutine.yield()

        return table.unpack(waitConnection.ReturnData)
    end,

    Once = function(self, func, ...)
        local connection = Connection.new()
        table.insert(self._Connections, { Connection = connection, Func = func, Args = table.pack(...) })
        return connection
    end,

    Fire = function(self, ...)
        -- Handle normal connections.
        for index, internalConnection in self._Connections do
            if not internalConnection.Connection.Connected then
                table.remove(self._Connections, index)
                continue
            end
            local args = MergeArgs(table.pack(...), internalConnection.Args)
            task.spawn(internalConnection.Func, table.unpack(args))
        end

        -- Handle once (single invocation) connections.
        for index, internalConnection in self._OnceConnections do
            if not internalConnection.Connection.Connected then
                table.remove(self._OnceConnections, index)
                continue
            end
            local args = MergeArgs(table.pack(...), internalConnection.Args)
            task.spawn(internalConnection.Func, table.unpack(args))
            table.remove(self._OnceConnections, index)
        end

        -- Handle connections yielding thread.
        for index, waitConnection in self._WaitConnections do
            waitConnection.ReturnData = table.pack(...)
            coroutine.resume(waitConnection.Coroutine)
        end
    end,
}

local SignalMetatable = { __index = SignalMethods }

return {
    new = function<Function, Returns...>(): Signal<Function, Returns...>
        local signal = table.clone(SignalProperties)
        setmetatable(signal, SignalMetatable :: Signal.SignalMetatable<Function, Returns...>)
        return signal
    end,
}
