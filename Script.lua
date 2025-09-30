local urls = {
    "https://raw.githubusercontent.com/zyklo01/Zyklo---optimizer/main/Steal%20a%20brainrot%20optimizar.lua",
    "https://raw.githubusercontent.com/zyklo01/Desync-zyklo/main/Desync.lua"
}

local function fetchUrl(url)
    local ok, res
    if syn and syn.request then
        ok, res = pcall(function() return syn.request({Url = url, Method = "GET"}) end)
        if ok and res and (res.StatusCode == 200 or res.Success) then return res.Body end
    end
    local req = http_request or http or (http and http.request)
    if req then
        ok, res = pcall(function() return req({Url = url, Method = "GET"}) end)
        if ok and res then
            if type(res) == "table" and (res.Body or res.body) then return res.Body or res.body end
            if type(res) == "string" then return res end
        end
    end
    local succ, httpService = pcall(function() return game:GetService("HttpService") end)
    if succ and httpService then
        ok, res = pcall(function() return (game.HttpGet and game:HttpGet(url)) or httpService:GetAsync(url) end)
        if ok and type(res) == "string" then return res end
    end
    return nil
end

local function safeCompile(code)
    if not code or #code == 0 then return nil end
    local ld = load or loadstring
    if not ld then return nil end
    local fn, err = ld(code, "remote")
    if not fn then return nil end
    return fn
end

local RunService = game:GetService("RunService")
local bodies = {}
local fetchThreads = {}

for i, u in ipairs(urls) do
    fetchThreads[i] = task.spawn(function()
        bodies[i] = fetchUrl(u)
    end)
    task.wait(0.04)
end

local timeout = 8
local t0 = tick()
while (not (bodies[1] and bodies[2])) and tick() - t0 < timeout do
    task.wait(0.05)
end

local function waitHeartbeats(n)
    n = n or 3
    for i = 1, n do
        local done = false
        local conn
        conn = RunService.Heartbeat:Connect(function()
            done = true
            conn:Disconnect()
        end)
        local tstart = tick()
        while not done and tick() - tstart < 1 do task.wait(0) end
    end
end

for i = 1, #urls do
    local code = bodies[i]
    if code then
        local fn = safeCompile(code)
        if fn then
            task.spawn(fn)
        end
    end
    if i < #urls then
        waitHeartbeats(6)
        task.wait(0.9)
    end
end
