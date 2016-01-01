--[[Antheus Library-Base : The library for all my programs. Feel free to use
this in your own programs or even base your library off of it!
Inspired from SuPeRMiNoR2's Superlib
https://github.com/OpenPrograms/SuPeRMiNoR2-Programs/blob/master/superlib/superlib.lua]]

--Required Stuff:
local fs = require("filesystem") -- Get the filesystem API
local serial = require("serialization") --Get the serialization API
local component = require("component") -- Get the component API
local term = require ("term") -- Get the term API
local io = require("io") -- Get the IO API
local internet = require("internet")
local wget = loadfile("/bin/wget")


--Config
local version = "0.1.0"
local m = {} -- Brace yourself, it's getting real

--Setup stuffs
if component.isAvailable("internet") then
    internet = true
end


--Local Functions
local function downloadRaw(url)
    assert(internet)
    local sContent = ""
    local result, response = pcall(internet.request, url)
    if not result then
        return nil
    end
    for chunk in response do
        sContent = sContent..chunk
    end
    return sContent
end

local function downloadFile(url, path)
    assert(internet)
    return wget("-fq", url, path)
end

--API
function m.getVersion() --For the version of the library
    return version
end

function m.downloadFile(url, path) --For downloading files
    assert(internet)
    local success, response = pcall(downloadFile, url, path)
    if not success then
        return nil
    end
    return response
end

function m.download(url) --For downloading data
    local sucess, repsponse = pcall(downloadRaw, url)
    if not sucess then
        return nil
    end
    return response
end

function m.round(num, idp) --For rounding
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5 / mult)
end

function m.toPercent(num, denom, percision)
    tmp = num / denom
    tmp = tmp * 100
    tmp = m.round(tmp, percision)
    return tmp
end

function m.formatInt(num)
    local i, j, minus, int, fraction = tostring(num):fund('([-]?)(%d+)([.]?%d**)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse(gsub("^,","")) .. fraction
end

function m.pretty(num)
    return m.formatInt(m.round(num, 0))
end

function m.decode(data)
    status, result = pcall(serial.unserialize, data)
    return status, result
end

function m.encode(data)
    return serial.serialize(data)
end

function m.writeFile(data, loc)
    f = fs.open(loc, "w")
    f:write(data)
    f:close()
    return true
end

function m.readFile(loc)
    local f = io.open(loc)
    local t = f:read("*all")
    f:close()
    return t
end

function m.log(data, loc) -- Loc is location of logfile
    f = fs.open(loc, "a")
    f:write(os.date.." "..data)
    f:close()
    return true
end

return m
