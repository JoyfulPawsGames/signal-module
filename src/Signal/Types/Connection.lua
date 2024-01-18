--[[
    Type definition of Connection.
]]

do
    -- to fix linter type docstring bug.
end

export type ConnectionProperties = {
    --[[
        Represent the state of the Connection.
    ]]
    Connected: boolean,
}

export type ConnectionMethods = {
    --[[
        Disconnect the Connection from the event.
    ]]
    Disconnect: (self: Connection) -> nil,
}

export type ConnectionMetatable = {
    __index: ConnectionMethods,
}

--[[
    Special object returned after making connectiong with an event.
]]
export type Connection = typeof(setmetatable({} :: ConnectionProperties, {} :: ConnectionMetatable))
return {}
