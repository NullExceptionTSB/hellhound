local hhprotocol = {}
hhprotocol.rqid = { SVINFO = "0", ACCESSBYLOGIN = "1", ACCESSBYKEY = "2", ADDUSER = "3" }
hhprotocol.respcode = { OK = "0", INVALID = "1", INTERNAL_ERROR = "2", NXCONNECT = "3" }
hhprotocol.state = { }

function hhprotocol.validaterq(data) 
    if (data["rqid"] == nil) then
        return false;
    end
end

function hhprotocol.validateresp(data) 

end

function hhprotocol.resp_invalid() 
    local resp = {}
    resp["code"] = hhprotocol.respcode.INVALID
    return resp
end

hhprotocol.state["forcehash"] = false
hhprotocol.state["datacard"] = nil

return hhprotocol;