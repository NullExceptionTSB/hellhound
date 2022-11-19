-- HELLHOUND PROTOCOL LIBRARY --
-- Programmed by NullException --
-- Licensed under the BSD 3-clause license --

local hhnet = {}

function hhnet.getsvrcfg(path)
    local cfgpath = "/etc/hellhound.d/hellhound.conf"
    if not(path == nil) then
        cfgpath = path
    end

    return nil;
end

function hhnet.runsvr(modem, cfgpath)
    if (modem == nil) then
        return false, "modem api error"
    elseif (modem.open == nil) then
        return false, "modem open failure"
    end 
    local cfg = hhnet.getsvrcfg(cfgpath)
    local port = 666
   -- CFG TEMPROARILY IGNORED! --
   -- PARSER GOES HERE --

    if not(modem.open(port)) and not(modem.isOpen(port)) then
        return false, "failed to open modem port";
    end
    return true, "ok"
end

return hhnet;