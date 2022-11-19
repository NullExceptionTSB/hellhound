-- HELLHOUND PROTOCOL SERVER --
-- Programmed by NullException --
-- Licensed under the BSD 3-clause license --

local component = require("component")
local event = require("event")
local serialization = require("serialization");

local modem = component.modem
local datac = component.data;
local hhnet = nil
local hhprotocol = nil
local hhdb = nil

local db = nil

local function fatal(msg) 
  print("F: " .. msg)
  os.exit()
end

local function init_net()
  hhnet = require("hhnet")
end

local function init_protocol()
  hhprotocol = require("hhprotocol")
end

local function init_db()
  hhdb = require("hhdb")
end

local function init()
  if (modem == nil) then
    return false, "no modem";
  end
-- top 10 stupidest error handling moments --
  if not(pcall(init_net)) then
    return false, "failed to load library hhnet";
  end

  if not(pcall(init_protocol)) then
    return false, "failed to initialize library hhprotocol"
  end

  if not(pcall(init_db)) then
    return false, "failed to initialize library hhdb"
  end
----------------------------------------------
  local success, msg = hhnet.runsvr(modem, nil);

  if not(success) then
    return false, "runsvr failure " .. msg;
  end

  --DEBUG ONLY--
  db = hhdb.inmemdb();
  hhdb.adduser(db, "admin", "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918", "0", "#+0");

  hhprotocol.state["datacard"] = datac ~= nil;

  if (datac == nil) then
    print("WARNING: Server does not contain data card! Connections require SHA256 hashing, so clients without a data card will not be able to be serviced! In addition, the account database will not be able to be encrypted!");
  elseif (datac.encrypt == nil) then
    print("WARNING: L1 data card detected. Database encryption not available!");
  end

  return true
end

local function newpkt(recvAddr, sendAddr, port, dist, data)
  if (data == nil) or not(hhprotocol.validaterq(data)) then
    modem.send(sendAddr, 666, serialization.serialize(hhprotocol.resp_invalid()))
  else
    local rqid = data["rqid"]
    local resp = {}
    if (rqid == hhprotocol.rqid.SVINFO) then
      for k,v in pairs(hhprotocol.state) do
        resp[k] = v
      end
      resp["code"] = hhprotocol.respcode.OK;
      modem.send(666, serialization.serialize(resp));
    end
  end
end


print("Initializing Hellhound Server...");
local success, msg = init()
if not(success) then
  fatal("Initialization failure: " .. msg);
else
  print("Initialization finished successfuly, listening for requests...");
end

while true do 
  local _, recv, send, port, dist, data = event.pull("modem_message")
  print("message recv: " .. tostring(data))
  newpkt(recv, send, port, dist, serialization.unserialize(data))
  -- os.sleep(1)
end