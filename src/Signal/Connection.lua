--[[
    Implementation of Connection.
]]

----- Types -----
local types = script.Parent.Types
local Connection = require(types.Connection)

----- Module Tables -----
local ConnectionProperties: Connection.ConnectionProperties = {
    Connected = true,
}

local ConnectionMethods: Connection.ConnectionMethods = {
    Disconnect = function(self)
        self.Connected = false
    end,
}

local ConnectionMetatable: Connection.ConnectionMetatable = {
    __index = ConnectionMethods,
}

return {
    new = function()
        local connection = table.clone(ConnectionProperties)
        setmetatable(connection, ConnectionMetatable)
        return connection
    end,
}
