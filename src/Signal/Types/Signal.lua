--[[
    Type definition of Signal.
]]

----- Types -----
local types = script.Parent
local Connection = require(types.Connection)

type InternalConnection = {
    Connection: Connection.Connection,
    Args: { [number]: any, n: number },
    Func: (...any) -> any,
}

type WaitConnection = { Coroutine: thread, ReturnData: any }

export type SignalProperties = {
    --[[
        Stores all connection made by `Connect` method.
    ]]
    _Connections: { InternalConnection },

    --[[
        Stores all connection made by `Once` method.
    ]]
    _OnceConnections: { InternalConnection },

    --[[
        Stores threads that have yielded after calling the `Wait` method.
    ]]
    _WaitConnections: { WaitConnection },
}

export type SignalMethods<Function, Returns...> = {
    --[[
        Connects the given function to the event.
    ]]
    Connect: (self: Signal<Function, Returns...>, func: Function, ...any) -> Connection.Connection,

    --[[
        Yields the current thread until the signal fires and returns the arguments provided by the signal.
    ]]
    Wait: (self: Signal<Function, Returns...>) -> Returns...,

    --[[
        Connects the given function to the event (for a single invocation).
    ]]
    Once: (self: Signal<Function, Returns...>, func: Function, ...any) -> Connection.Connection,

    --[[
        Fires the signal, invoking connected functions and resuming any yielding threads.
    ]]
    Fire: (self: Signal<Function, Returns...>, Returns...) -> nil,
}

export type SignalMetatable<Function, Returns...> = {
    __index: SignalMethods<Function, Returns...>,
}

--[[
    Represent a event which can be connected.
]]
export type Signal<Function, Returns...> = typeof(setmetatable(
    {} :: SignalProperties,
    {} :: SignalMetatable<Function, Returns...>
))
return {}
