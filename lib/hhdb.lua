local hhdb = {}
SER = require("serialization");


hhdb.fields = { "username", "hashpw", "id", "accesslist" }

function hhdb.parse(data)
    return SER.deserialize(data);
end

function hhdb.adduser(db, name, password, id, acl)
    table.insert(db, {name, password, id, acl})
end

function hhdb.readdb(path)
    local dbpath = path
    if (path == nil) then
        dbpath = "/etc/hellhound.d/users.hhdb"
    end

    local h, err = io.open(dbpath, "r");
    if (h == nil) then
        dbpath = "/etc/hellhound.d/users.hhdb"
        h, err = io.open(dbpath, "r");
        if (h == nil) then
            return nil, "file access error: " .. err;
        end
    end

    local data = h:read("*all");
    h:close();

    local msg = nil
    if (data == nil) then
        msg = "read error"
    end

    return data, msg;
end

function hhdb.inmemdb() 
    return {};
end

function hhdb.save(data, path)
    local h, err = io.open(path, "w");
    if (h == nil) then
        h, err = io.open("/etc/hellhound.d/users.hhdb", "w");
        if (h == nil) then
            return false, "file access error: " .. err;
        end
    end

    h:write(SER.serialize(data));
    h:close();

    return true;
end

return hhdb