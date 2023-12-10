type ConnectionProperties = {
    Connected: boolean,
}

type ConnectionMethods = {
    Disconnect: (self: Connection) -> nil,
}

type ConnectionMetatable = {
    __index: ConnectionMethods,
}

export type Connection = typeof(setmetatable({} :: ConnectionProperties, {} :: ConnectionMetatable))

local ConnectionProperties: ConnectionProperties = {
    Connected = true,
}

local ConnectionMethods: ConnectionMethods = {
    Disconnect = function(self: Connection)
        self.Connected = false
    end,
}

local ConnectionMetatable: ConnectionMetatable = {
    __index = ConnectionMethods,
}

return {
    new = function(): Connection
        local connection = table.clone(ConnectionProperties)
        setmetatable(connection, ConnectionMetatable)
        return connection
    end,
}
