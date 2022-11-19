-- HELLHOUND PROTOCOL CLI CLIENT --
-- Programmed by NullException --
-- Licensed under the BSD 3-clause license --

local term = require("term")
local shell = require("shell")
local component = require("component")
local hhprotocol = nil

local modem = nil;

local args, opts = shell.parse(...)

local conn = nil;

local rinteractive = false;

local function connect(server, port)
    print("Connecting... (" .. server .. ":" .. tostring(port) .. ")");
    conn = hhprotocol.client_connect(modem, server, port);
    if (conn["code"] == hhprotocol.respcode.NXCONNECT) then
        print("Connection failed! Host unreachable")
        conn = nil;
    elseif (conn["code"] == hhprotocol.respcode.INCOMPATIBLE) then
        print("Connection failed! Incomatible connection (neither server nor client have data card)");
    elseif (conn["code"] ~= hhprotocol.respcode.OK) then
        print("Connection failed! Error #" .. tostring(conn["code"]));
        conn = nil;
    else
        print("Connection success!");
    end
end

local function command(input)
    
end

local function initialconnect()
    local port = tonumber(666)
    if (#args >= 1) then
        if (#args >= 2) then
            port = tonumber(args[2])
        end
        connect(args[1], port);
    end
end

local function interactive()
    initialconnect()
    rinteractive = true;

    while true do
        term.write("> ");
        command(term.read())
    end
end

local function adduser()
    initialconnect()
    if not(rinteractive) and (conn == nil) then os.exit(); end

    
end

local function gmodem()
    modem = component.modem
end

if not(pcall(gmodem)) then
    print("No modem found, or modem error");
    os.exit();
end

local success, hhprotocol = pcall(require, "hhprotocol");
if not(success) then
    print("Failed to initialize libhellhound (broken install ?, run \"oppm install libhellhound\")");
    os.exit();
end

if (opts["i"] == true) then
   interactive()
elseif (opts["a"] == true) then
    adduser()
elseif (opts["acl-add"] == true) then

elseif (opts["acl-remove"] == true) then

elseif (opts["setadmin"] == true) then

else
    print("Usage: hellhound [-i [server [port]]] [-a server [port]]")
end

