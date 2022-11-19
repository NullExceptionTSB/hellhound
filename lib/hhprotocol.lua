-- HELLHOUND PROTOCOL LIBRARY --
-- Programmed by NullException --
-- Licensed under the BSD 3-clause license --

local serialization = require("serialization");
local event = require("event");
local component = require("component");

local hhprotocol = {}
hhprotocol.rqid = { SVINFO = "0", ACCESSBYLOGIN = "1", 
    ACCESSBYKEY = "2", ADDUSER = "3" }
hhprotocol.respcode = { OK = "0", INVALID = "1", INCOMPATIBLE = "2",
    NXCONNECT = "3", ACCESSDENIED = "4" }

function hhprotocol.validaterq(data) 
    if (data["rqid"] == nil) then
        return false;
    end
end

local function testdata()
    local a = component.data

end

function hhprotocol.validateresp(data)

end

function hhprotocol.resp_invalid()
    local resp = {}
    resp["code"] = hhprotocol.respcode.INVALID
    return resp
end

function hhprotocol.rq_getinfo()
    local rq = {}
    rq["rqid"] = hhprotocol.rqid.SVINFO;
    return rq;
end

function hhprotocol.client_connect(modem, address, port)
    local conport = 666;
    if (port ~= nil) then
        conport = port
    end

    modem.send(address, conport, serialization.serialize(hhprotocol.rq_getinfo()))
    local recvd = false
    local data = nil
    while not(recvd) do
        local e, _, rsender, rport, d = event.pull(30, "modem_message");
        if (e == nil) then
            recvd = true
            data = {}
            data["code"] = hhprotocol.respcode.NXCONNECT
            return data
        elseif (port == rport) and (address == rsender) then
            recvd = true
            data = d
        end
    end

    local ret = serialization.unserialize(data);
    ret["server"] = address
    ret["port"] = port
    if (ret["datacard"] == false and not(pcall(testdata))) then
        ret["code"] = hhprotocol.respcode.INCOMPATIBLE;
    end
    return ret;
end

function hhprotocol.client_accessbylogin(connection, username, password, object) 

end

hhprotocol.state["forcehash"] = false
hhprotocol.state["datacard"] = nil

return hhprotocol