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

local function safeRun(code)
    if not code or #code == 0 then return false end
    local ld = load or loadstring
    if not ld then return false end
    local fn, err = ld(code, "remote")
    if not fn then return false end
    local ok = pcall(fn)
    return ok
end

local RunService = game:GetService("RunService")

local function loadRemote(url, attempts)
    attempts = attempts or 2
    for i = 1, attempts do
        local body = fetchUrl(url)
        if body then
            local done = false
            local conn
            conn = RunService.Heartbeat:Connect(function()
                done = true
                conn:Disconnect()
            end)
            local t0 = tick()
            while not done and tick() - t0 < 1 do task.wait(0) end
            task.spawn(function() safeRun(body) end)
            return true
        else
            task.wait(0.12)
        end
    end
    return false
end

for i, u in ipairs(urls) do
    task.spawn(function()
        loadRemote(u, 3)
    end)
    task.wait(0.06)
end
```0
