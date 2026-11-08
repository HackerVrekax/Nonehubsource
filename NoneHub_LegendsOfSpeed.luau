-- Hook loadstring so ezzz
-- By FTAP Reverse
-- t.me/ReverseFTAP
local VERSION = "2.0.0"
local HUB_NAME = "None Hub"
local DISCORD_URL = "https://discord.gg/e5KN6DFy8A"
local LIBRARY_URL = "https://raw.githubusercontent.com/shhskshdjsjsjsh-source/RedzHubUI/refs/heads/main/README.md"
local CONFIG_FILE = "NoneHub_LegendsOfSpeed_Config.json"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
if not player then
    error("[None Hub] LocalPlayer is not available.")
end

local environment = _G
if type(getgenv) == "function" then
    local ok, result = pcall(getgenv)
    if ok and type(result) == "table" then
        environment = result
    end
end

-- Stop a previous V2 instance before opening another one.
if type(environment.NoneHubLegendsSession) == "table"
    and type(environment.NoneHubLegendsSession.Shutdown) == "function" then
    pcall(environment.NoneHubLegendsSession.Shutdown, true)
end

local SETTINGS_DEFAULTS = {
    location = "City",
    orb = "Red Orb",
    farmMode = "Medium",
    selectedCrystal = "",
    hatchMode = "Selected Crystal",
    targetPet = "Void Dragon",
    theme = "Darker",
    walkSpeed = 16,
    jumpPower = 50,
    protectRarePets = true,
    serverMaxPlayers = 5,
}

local settings = {}
for key, value in pairs(SETTINGS_DEFAULTS) do
    settings[key] = value
end

local function isChoice(value, choices)
    for _, choice in ipairs(choices) do
        if value == choice then
            return true
        end
    end
    return false
end

local FARM_LOCATIONS = {"City", "Snow City", "Magma City", "Legends Highway", "Space", "Desert"}
local ORB_TYPES = {"Red Orb", "Yellow Orb", "Gem"}
local FARM_MODES = {"Slow", "Medium", "Fast", "Super Fast"}
local THEMES = {"Darker", "Dark", "Purple"}
local HATCH_MODES = {"Selected Crystal", "Target Hunt"}
local TARGET_PETS = {"Void Dragon", "Ultra Birdie", "Ultimate Overdrive Bunny"}
local TARGET_CRYSTALS = {
    ["Void Dragon"] = "Desert Crystal",
    ["Ultra Birdie"] = "Electro Crystal",
    ["Ultimate Overdrive Bunny"] = "Electro Legends Crystal",
}
local FARM_DELAYS = {
    Slow = 0.8,
    Medium = 0.4,
    Fast = 0.2,
    ["Super Fast"] = 0.1,
}

local function loadSettings()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return
    end
    local ok, data = pcall(function()
        if not isfile(CONFIG_FILE) then
            return nil
        end
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not ok or type(data) ~= "table" then
        return
    end
    for key, default in pairs(SETTINGS_DEFAULTS) do
        if type(data[key]) == type(default) then
            settings[key] = data[key]
        end
    end
    if not isChoice(settings.location, FARM_LOCATIONS) then settings.location = "City" end
    if not isChoice(settings.orb, ORB_TYPES) then settings.orb = "Red Orb" end
    if not isChoice(settings.farmMode, FARM_MODES) then settings.farmMode = "Medium" end
    if not isChoice(settings.hatchMode, HATCH_MODES) then settings.hatchMode = "Selected Crystal" end
    if not isChoice(settings.targetPet, TARGET_PETS) then settings.targetPet = "Void Dragon" end
    if not isChoice(settings.theme, THEMES) then settings.theme = "Darker" end
    settings.walkSpeed = math.clamp(settings.walkSpeed, 16, 500)
    settings.jumpPower = math.clamp(settings.jumpPower, 50, 300)
    settings.serverMaxPlayers = math.clamp(math.floor(settings.serverMaxPlayers), 1, 12)
end
loadSettings()

local function saveSettings()
    if type(writefile) ~= "function" then
        return false, "writefile is not supported by this executor."
    end
    local ok, err = pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(settings))
    end)
    return ok, err
end

local runtime = {
    alive = true,
    flags = {},
    generations = {},
    connections = {},
    originalCollision = {},
    originalHoops = {},
    originalVisuals = {},
    originalPopups = {},
    originalMovement = {},
    attempts = {orbs = 0, rebirths = 0, crystals = 0, races = 0, petSales = 0},
    lastError = "None",
    lastAction = "Ready",
    lastWarningAt = {},
    startedAt = os.clock(),
    frameCount = 0,
    fps = 0,
    selectedPlayer = nil,
    noClip = false,
    infiniteJump = false,
    hidePopups = false,
    antiAfk = true,
    lowGraphics = false,
    customMovement = false,
    selectedPlayerDropdown = nil,
    crystalDropdown = nil,
    toggles = {},
    gui = nil,
}

environment.NoneHubLegendsSession = runtime

local function addConnection(connection)
    table.insert(runtime.connections, connection)
    return connection
end

local function notify(title, description, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or HUB_NAME,
            Text = tostring(description or ""),
            Duration = duration or 5,
        })
    end)
end

local function logError(source, err)
    local now = os.clock()
    local message = tostring(err)
    runtime.lastError = source .. ": " .. message:sub(1, 90)
    if now - (runtime.lastWarningAt[source] or -100) >= 10 then
        runtime.lastWarningAt[source] = now
        warn("[None Hub / " .. source .. "] " .. message)
    end
end

local function safely(source, fn)
    local ok, result = pcall(fn)
    if not ok then
        logError(source, result)
    end
    return ok, result
end

local function getCharacter()
    return player.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getRemote(remoteName, expectedClass)
    local events = ReplicatedStorage:FindFirstChild("rEvents")
    local remote = events and events:FindFirstChild(remoteName)
    if not remote or not remote:IsA(expectedClass) then
        error("Missing " .. expectedClass .. ": rEvents." .. remoteName)
    end
    return remote
end

local function fireRemote(remoteName, ...)
    local parameters = {...}
    return safely(remoteName, function()
        getRemote(remoteName, "RemoteEvent"):FireServer(table.unpack(parameters))
    end)
end

local function invokeRemote(remoteName, ...)
    local parameters = {...}
    return safely(remoteName, function()
        return getRemote(remoteName, "RemoteFunction"):InvokeServer(table.unpack(parameters))
    end)
end

local function setActivity(text)
    runtime.lastAction = text
end

-- Each feature owns exactly one worker. Fast on/off clicks cannot duplicate it.
local function stopWorker(name)
    runtime.flags[name] = false
    runtime.generations[name] = (runtime.generations[name] or 0) + 1
end

local function startWorker(name, delayFn, action)
    stopWorker(name)
    runtime.flags[name] = true
    local generation = runtime.generations[name]
    task.spawn(function()
        while runtime.alive and runtime.flags[name] and runtime.generations[name] == generation do
            safely(name, action)
            if not runtime.alive or not runtime.flags[name] or runtime.generations[name] ~= generation then
                break
            end
            local delayValue = type(delayFn) == "function" and delayFn() or delayFn
            task.wait(math.max(tonumber(delayValue) or 0.5, 0.05))
        end
    end)
end

local function setWorker(name, enabled, delayFn, action)
    if enabled then
        startWorker(name, delayFn, action)
    else
        stopWorker(name)
    end
end

local function restoreProperties(originals)
    for instance, properties in pairs(originals) do
        if instance and instance.Parent then
            pcall(function()
                for property, oldValue in pairs(properties) do
                    instance[property] = oldValue
                end
            end)
        end
        originals[instance] = nil
    end
end

local function rememberProperty(originals, instance, property)
    if not instance then return end
    if not originals[instance] then originals[instance] = {} end
    if originals[instance][property] == nil then
        local ok, value = pcall(function() return instance[property] end)
        if ok then
            originals[instance][property] = value
        end
    end
end

local function setNoclip(enabled)
    runtime.noClip = enabled
    if not enabled then
        restoreProperties(runtime.originalCollision)
    end
end

local function applyMovement()
    if not runtime.customMovement then return end
    local humanoid = getHumanoid()
    if not humanoid then return end
    if not runtime.originalMovement[humanoid] then
        runtime.originalMovement[humanoid] = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            UseJumpPower = humanoid.UseJumpPower,
        }
    end
    humanoid.WalkSpeed = settings.walkSpeed
    humanoid.UseJumpPower = true
    humanoid.JumpPower = settings.jumpPower
end

local function restoreMovement()
    restoreProperties(runtime.originalMovement)
end

local function setPopupVisibility(hidden)
    runtime.hidePopups = hidden
    if not hidden then
        restoreProperties(runtime.originalPopups)
        return
    end
    local gui = player:FindFirstChildOfClass("PlayerGui")
    if not gui then return end
    local orbGui = gui:FindFirstChild("orbGui")
    if orbGui and orbGui:IsA("ScreenGui") then
        rememberProperty(runtime.originalPopups, orbGui, "Enabled")
        orbGui.Enabled = false
    end
    local gameGui = gui:FindFirstChild("gameGui")
    local trailNotifications = gameGui and gameGui:FindFirstChild("trailsNotificationsFrame")
    if trailNotifications and trailNotifications:IsA("GuiObject") then
        rememberProperty(runtime.originalPopups, trailNotifications, "Visible")
        trailNotifications.Visible = false
    end
end

local function applyLowGraphics(instance)
    if not runtime.lowGraphics then return end
    if instance:IsA("ParticleEmitter") or instance:IsA("Beam") or instance:IsA("Trail") then
        rememberProperty(runtime.originalVisuals, instance, "Enabled")
        instance.Enabled = false
    end
end

local function setLowGraphics(enabled)
    runtime.lowGraphics = enabled
    if not enabled then
        restoreProperties(runtime.originalVisuals)
        return
    end
    rememberProperty(runtime.originalVisuals, Lighting, "GlobalShadows")
    Lighting.GlobalShadows = false
    for _, item in ipairs(workspace:GetDescendants()) do
        applyLowGraphics(item)
    end
end

function runtime.Shutdown(destroyInterface)
    if not runtime.alive then return end
    runtime.alive = false
    for feature in pairs(runtime.flags) do
        stopWorker(feature)
    end
    setNoclip(false)
    setPopupVisibility(false)
    setLowGraphics(false)
    restoreProperties(runtime.originalHoops)
    restoreMovement()
    for _, connection in ipairs(runtime.connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(runtime.connections)
    if environment.NoneHubLegendsSession == runtime then
        environment.NoneHubLegendsSession = nil
    end
    if destroyInterface and runtime.gui then
        pcall(function() runtime.gui:Destroy() end)
    end
end

-- Load the original Redz UI with descriptive startup errors.
local loadedLibrary, libraryResult = pcall(function()
    local source = game:HttpGet(LIBRARY_URL)
    local chunk, compileError = loadstring(source)
    if not chunk then error(compileError or "UI compilation failed") end
    return chunk()
end)
if not loadedLibrary or type(libraryResult) ~= "table" then
    runtime.Shutdown(false)
    error("[None Hub] Could not load the UI library: " .. tostring(libraryResult))
end
local library = libraryResult

local window = library:MakeWindow({
    Title = HUB_NAME .. " | Legends of Speed",
    SubTitle = "Remastered v" .. VERSION .. " | by nexustester",
    SaveFolder = "NoneHub_LegendsOfSpeed_UI.json",
})

pcall(function()
    library:SetTheme(settings.theme)
end)

window:AddMinimizeButton({
    Button = {Image = "rbxassetid://71014873973869", BackgroundTransparency = 0.06},
    Corner = {CornerRadius = UDim.new(0, 12)},
})

local mainTab = window:MakeTab({"Dashboard", "home"})
local farmTab = window:MakeTab({"Auto Farm", "zap"})
local crystalTab = window:MakeTab({"Crystals & Pets", "gem"})
local raceTab = window:MakeTab({"Races", "flag"})
local teleportTab = window:MakeTab({"Teleports", "map-pin"})
local playerTab = window:MakeTab({"Player", "user"})
local settingsTab = window:MakeTab({"Settings", "settings"})
local helpTab = window:MakeTab({"Help & Credits", "info"})

-- The library places its ScreenGui in CoreGui under this name.
safely("UI Lifecycle", function()
    runtime.gui = CoreGui:FindFirstChild("redz Library V5")
    if runtime.gui then
        addConnection(runtime.gui.Destroying:Connect(function()
            runtime.Shutdown(false)
        end))
    end
end)

local function updateParagraph(paragraph, title, description)
    if not runtime.alive then return end
    safely("Dashboard", function()
        paragraph:Set(title, tostring(description))
    end)
end

local function formatDuration(totalSeconds)
    local seconds = math.floor(totalSeconds)
    return string.format("%02d:%02d:%02d", math.floor(seconds / 3600),
        math.floor(seconds / 60) % 60, seconds % 60)
end

-- =============================================================
-- DASHBOARD
-- =============================================================
mainTab:AddSection({"Live Dashboard"})
local serverInfo = mainTab:AddParagraph({"Session", "Starting..."})
local performanceInfo = mainTab:AddParagraph({"Performance", "Starting..."})
local automationInfo = mainTab:AddParagraph({"Automation", "All features disabled"})
local countersInfo = mainTab:AddParagraph({"Requests", "Orbs: 0 | Crystals: 0"})
local statusInfo = mainTab:AddParagraph({"Last Action", "Ready"})
local errorsInfo = mainTab:AddParagraph({"Last Error", "None"})

addConnection(RunService.RenderStepped:Connect(function()
    runtime.frameCount = runtime.frameCount + 1
end))

task.spawn(function()
    while runtime.alive do
        task.wait(1)
        if not runtime.alive then break end
        runtime.fps = runtime.frameCount
        runtime.frameCount = 0
        local ping = "Unknown"
        local ok, value = pcall(function()
            return math.floor(player:GetNetworkPing() * 1000 + 0.5)
        end)
        if ok then ping = tostring(value) .. " ms" end

        local activeFeatures = {}
        for name, enabled in pairs(runtime.flags) do
            if enabled then table.insert(activeFeatures, name) end
        end
        table.sort(activeFeatures)

        updateParagraph(serverInfo, "Session",
            "Uptime: " .. formatDuration(os.clock() - runtime.startedAt)
                .. " | Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
                .. " | Place: " .. game.PlaceId)
        updateParagraph(performanceInfo, "Performance", "FPS: " .. runtime.fps .. " | Ping: " .. ping)
        updateParagraph(automationInfo, "Automation",
            #activeFeatures == 0 and "No automation running" or table.concat(activeFeatures, ", "))
        updateParagraph(countersInfo, "Remote Requests",
            "Orbs: " .. runtime.attempts.orbs
                .. " | Rebirths: " .. runtime.attempts.rebirths
                .. " | Crystals: " .. runtime.attempts.crystals
                .. " | Races: " .. runtime.attempts.races
                .. " | Sales: " .. runtime.attempts.petSales)
        updateParagraph(statusInfo, "Last Action", runtime.lastAction)
        updateParagraph(errorsInfo, "Last Error", runtime.lastError)
        if runtime.hidePopups then setPopupVisibility(true) end
    end
end)

mainTab:AddSection({"Quick Actions"})
local CHEST_NAMES = {"goldenChest", "enchantedChest", "magmaChest", "groupRewardsCircle"}
mainTab:AddButton({"Claim Nearby Chests", function()
    task.spawn(function()
        local root = getRootPart()
        if not root then notify(HUB_NAME, "Character is not ready.") return end
        local moved = 0
        for _, name in ipairs(CHEST_NAMES) do
            local chest = workspace:FindFirstChild(name)
            local circle = chest and chest:FindFirstChild("circleInner")
            if circle and circle:IsA("BasePart") then
                local original = circle.CFrame
                local ok, err = pcall(function()
                    circle.CFrame = root.CFrame
                    task.wait(0.15)
                    circle.CFrame = original
                end)
                pcall(function() circle.CFrame = original end)
                if ok then moved = moved + 1 else logError("Chests", err) end
            end
        end
        setActivity("Touched " .. moved .. " local chest triggers")
        notify(HUB_NAME, "Chest triggers attempted: " .. moved .. ". Server rewards are not guaranteed.")
    end)
end})

runtime.toggles.autoRebirth = mainTab:AddToggle({
    Name = "Auto Rebirth",
    Description = "Requests rebirth at a safe, fixed interval. The server checks eligibility.",
    Default = false,
    Callback = function(enabled)
        setWorker("Auto Rebirth", enabled, 1.25, function()
            if fireRemote("rebirthEvent", "rebirthRequest") then
                runtime.attempts.rebirths = runtime.attempts.rebirths + 1
            end
        end)
    end,
})

mainTab:AddButton({"Disable Trading", function()
    if fireRemote("tradingEvent", "disableTrading") then setActivity("Trading disabled") end
end})
mainTab:AddButton({"Enable Trading", function()
    if fireRemote("tradingEvent", "enableTrading") then setActivity("Trading enabled") end
end})

mainTab:AddButton({"Stop All Automations", function()
    for name in pairs(runtime.flags) do stopWorker(name) end
    for _, toggleControl in pairs(runtime.toggles) do
        safely("Stop All", function() toggleControl:Set(false) end)
    end
    restoreProperties(runtime.originalHoops)
    setActivity("All automation workers stopped")
    notify(HUB_NAME, "All automation workers stopped and switches reset.")
end})

mainTab:AddDiscordInvite({
    Name = HUB_NAME,
    Description = "News, announcements and updates",
    Logo = "rbxassetid://18751483361",
    Invite = DISCORD_URL,
})
mainTab:AddButton({"Copy Discord Link", function()
    if type(setclipboard) == "function" then
        safely("Clipboard", function() setclipboard(DISCORD_URL) end)
        notify(HUB_NAME, "Discord invite copied.")
    else
        notify(HUB_NAME, "Clipboard access is not available.")
    end
end})

-- =============================================================
-- AUTO FARM
-- =============================================================
farmTab:AddSection({"Orb Collection"})
farmTab:AddDropdown({
    Name = "Farm Location", Options = FARM_LOCATIONS, Default = settings.location,
    Callback = function(value)
        if isChoice(value, FARM_LOCATIONS) then settings.location = value end
    end,
})
farmTab:AddDropdown({
    Name = "Orb Type", Options = ORB_TYPES, Default = settings.orb,
    Callback = function(value)
        if isChoice(value, ORB_TYPES) then settings.orb = value end
    end,
})
farmTab:AddDropdown({
    Name = "Farm Speed", Options = FARM_MODES, Default = settings.farmMode,
    Callback = function(value)
        if isChoice(value, FARM_MODES) then settings.farmMode = value end
    end,
})
farmTab:AddParagraph({"Adaptive Request Pacing",
    "Slow: 1.25/s | Medium: 2.5/s | Fast: 5/s | Super Fast: 10/s\n"
        .. "These are request rates, not guaranteed rewards. Game limits may apply."})

runtime.toggles.autoOrbs = farmTab:AddToggle({
    Name = "Auto Collect Orbs",
    Description = "Uses the selected orb, location and request interval.",
    Default = false,
    Callback = function(enabled)
        setWorker("Auto Orbs", enabled, function()
            return FARM_DELAYS[settings.farmMode] or 0.4
        end, function()
            if fireRemote("orbEvent", "collectOrb", settings.orb, settings.location) then
                runtime.attempts.orbs = runtime.attempts.orbs + 1
            end
        end)
    end,
})

farmTab:AddSection({"Hoops"})
farmTab:AddParagraph({"Hoops Farm", "Local hoop movement may not be accepted by the server. Positions are restored on stop."})
runtime.toggles.autoHoops = farmTab:AddToggle({
    Name = "Auto Hoops",
    Description = "Temporarily moves nearby hoop parts to your character.",
    Default = false,
    Callback = function(enabled)
        setWorker("Auto Hoops", enabled, 0.4, function()
            local root = getRootPart()
            local folder = workspace:FindFirstChild("Hoops")
            if not root or not folder then return end
            for _, hoop in ipairs(folder:GetChildren()) do
                if hoop.Name == "Hoop" and hoop:IsA("BasePart") then
                    rememberProperty(runtime.originalHoops, hoop, "CFrame")
                    rememberProperty(runtime.originalHoops, hoop, "Transparency")
                    hoop.Transparency = 1
                    hoop.CFrame = root.CFrame
                end
            end
        end)
        if not enabled then restoreProperties(runtime.originalHoops) end
    end,
})

-- =============================================================
-- CRYSTALS AND PETS
-- =============================================================
crystalTab:AddSection({"Crystal Automation"})
local function listCrystals()
    local result, seen = {}, {}
    local folder = workspace:FindFirstChild("mapCrystalsFolder")
    if folder then
        for _, crystal in ipairs(folder:GetChildren()) do
            if not seen[crystal.Name] then
                seen[crystal.Name] = true
                table.insert(result, crystal.Name)
            end
        end
    end
    table.sort(result)
    return result
end

local function refreshCrystals()
    local names = listCrystals()
    if runtime.crystalDropdown then
        safely("Refresh Crystals", function()
            runtime.crystalDropdown:Set(names)
            if #names > 0 then
                local chosen = isChoice(settings.selectedCrystal, names) and settings.selectedCrystal or names[1]
                settings.selectedCrystal = chosen
                runtime.crystalDropdown:Select(chosen)
            else
                settings.selectedCrystal = ""
            end
        end)
    end
end

local startingCrystals = listCrystals()
if settings.selectedCrystal == "" and #startingCrystals > 0 then
    settings.selectedCrystal = startingCrystals[1]
end
runtime.crystalDropdown = crystalTab:AddDropdown({
    Name = "Crystal", Options = startingCrystals,
    Default = settings.selectedCrystal,
    Callback = function(value)
        if type(value) == "string" and value ~= "nil" then
            settings.selectedCrystal = value
        end
    end,
})
crystalTab:AddButton({"Refresh Crystal List", refreshCrystals})
crystalTab:AddDropdown({
    Name = "Hatch Strategy", Options = HATCH_MODES, Default = settings.hatchMode,
    Callback = function(value)
        if isChoice(value, HATCH_MODES) then settings.hatchMode = value end
    end,
})
crystalTab:AddDropdown({
    Name = "Target Pet", Options = TARGET_PETS, Default = settings.targetPet,
    Callback = function(value)
        if isChoice(value, TARGET_PETS) then settings.targetPet = value end
    end,
})
crystalTab:AddParagraph({"Target Hunt",
    "Void Dragon -> Desert Crystal\n"
        .. "Ultra Birdie -> Electro Crystal\n"
        .. "Ultimate Overdrive Bunny -> Electro Legends Crystal\n"
        .. "Crystal availability and pet chances are controlled by the game."})

runtime.toggles.autoCrystals = crystalTab:AddToggle({
    Name = "Auto Open Crystals",
    Description = "Automatically opens one crystal per cycle using your hatch strategy.",
    Default = false,
    Callback = function(enabled)
        setWorker("Auto Crystals", enabled, 1.2, function()
            local crystalName = settings.selectedCrystal
            if settings.hatchMode == "Target Hunt" then
                crystalName = TARGET_CRYSTALS[settings.targetPet]
            end
            if type(crystalName) ~= "string" or crystalName == "" then return end
            if invokeRemote("openCrystalRemote", "openCrystal", crystalName) then
                runtime.attempts.crystals = runtime.attempts.crystals + 1
            end
        end)
    end,
})

crystalTab:AddSection({"Pet Protection & Inventory"})
crystalTab:AddToggle({
    Name = "Protect Rare Pet Folders",
    Description = "Prevents auto-selling pets inside recognized rare folders.",
    Default = settings.protectRarePets,
    Callback = function(enabled) settings.protectRarePets = enabled end,
})

local RARE_FOLDER_NAMES = {
    unique = true, legendary = true, mythic = true, mythical = true, secret = true,
    exotic = true, celestial = true, divine = true, godly = true,
}

local function isPetProtected(pet, folder)
    -- All three original target pets are permanently protected, even if the target changes.
    if isChoice(pet.Name, TARGET_PETS) then return true end
    if pet.Name == settings.targetPet then return true end
    if settings.protectRarePets and folder then
        if RARE_FOLDER_NAMES[string.lower(folder.Name)] then return true end
    end
    return false
end

local function forEachPet(callback)
    local petsFolder = player:FindFirstChild("petsFolder")
    if not petsFolder then return end
    for _, folder in ipairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") or folder:IsA("Model") then
            for _, pet in ipairs(folder:GetChildren()) do
                callback(pet, folder)
            end
        end
    end
end

local function countSaleCandidates()
    local candidates, protected = 0, 0
    forEachPet(function(pet, folder)
        if isPetProtected(pet, folder) then
            protected = protected + 1
        else
            candidates = candidates + 1
        end
    end)
    return candidates, protected
end

crystalTab:AddButton({"Preview Pet Auto-Sell", function()
    local candidates, protected = countSaleCandidates()
    notify("Pet Sale Preview", "Candidates: " .. candidates .. " | Protected: " .. protected, 8)
    setActivity("Pet sale preview: " .. candidates .. " candidates, " .. protected .. " protected")
end})

local autoSellPetToggle
local petSaleConfirmationPending = false
local function executePetSale()
    if not isChoice(settings.targetPet, TARGET_PETS) then return end
    local soldThisCycle = 0
    forEachPet(function(pet, folder)
        if soldThisCycle >= 4 then return end
        if pet.Parent and not isPetProtected(pet, folder) then
            if fireRemote("sellPetEvent", "sellPet", pet) then
                runtime.attempts.petSales = runtime.attempts.petSales + 1
                soldThisCycle = soldThisCycle + 1
            end
        end
    end)
end

autoSellPetToggle = crystalTab:AddToggle({
    Name = "Auto Sell Unprotected Pets",
    Description = "Destructive action! Targets are protected; other pets may be sold.",
    Default = false,
    Callback = function(enabled)
        if not enabled then
            petSaleConfirmationPending = false
            stopWorker("Auto Pet Sales")
            return
        end
        petSaleConfirmationPending = true
        window:Dialog({
            Title = "Confirm Automatic Pet Sales",
            Text = "All unprotected pets may be permanently sold. Continue?",
            Options = {
                {"Enable", function()
                    if not petSaleConfirmationPending or not runtime.alive then return end
                    petSaleConfirmationPending = false
                    startWorker("Auto Pet Sales", 2, executePetSale)
                    setActivity("Automatic pet sales enabled")
                end},
                {"Cancel", function()
                    autoSellPetToggle:Set(false)
                end},
            },
        })
    end,
})

local autoSellTrailToggle
local trailSaleConfirmationPending = false
local function executeTrailSale()
    local trailFolder = player:FindFirstChild("trailsFolder")
    if not trailFolder then return end
    local sold = 0
    for _, folder in ipairs(trailFolder:GetChildren()) do
        for _, trail in ipairs(folder:GetChildren()) do
            if sold >= 4 then return end
            if fireRemote("sellTrailEvent", "sellTrail", trail) then sold = sold + 1 end
        end
    end
end

autoSellTrailToggle = crystalTab:AddToggle({
    Name = "Auto Sell All Trails",
    Description = "Destructive action! No trail protection is provided.",
    Default = false,
    Callback = function(enabled)
        if not enabled then
            trailSaleConfirmationPending = false
            stopWorker("Auto Trail Sales")
            return
        end
        trailSaleConfirmationPending = true
        window:Dialog({
            Title = "Confirm Trail Deletion",
            Text = "Every available trail may be sold. This cannot be undone. Continue?",
            Options = {
                {"Enable", function()
                    if not trailSaleConfirmationPending or not runtime.alive then return end
                    trailSaleConfirmationPending = false
                    startWorker("Auto Trail Sales", 2, executeTrailSale)
                end},
                {"Cancel", function()
                    autoSellTrailToggle:Set(false)
                end},
            },
        })
    end,
})

runtime.toggles.autoPetSales = autoSellPetToggle
runtime.toggles.autoTrailSales = autoSellTrailToggle

local evolveCooldown = {}
runtime.toggles.autoEvolve = crystalTab:AddToggle({
    Name = "Auto Evolve Pets",
    Description = "Attempts to evolve pets with per-name throttling.",
    Default = false,
    Callback = function(enabled)
        setWorker("Auto Evolve", enabled, 3, function()
            local now = os.clock()
            local chosenName = nil
            forEachPet(function(pet)
                if not chosenName and (now - (evolveCooldown[pet.Name] or -100)) > 25 then
                    chosenName = pet.Name
                end
            end)
            if chosenName then
                evolveCooldown[chosenName] = now
                fireRemote("petEvolveEvent", "evolvePet", chosenName)
            end
        end)
    end,
})

-- Keep the crystal list current when new crystals are streamed into workspace.
local crystalFolderConnection
local function connectCrystalFolder(folder)
    if crystalFolderConnection then crystalFolderConnection:Disconnect() end
    crystalFolderConnection = addConnection(folder.ChildAdded:Connect(function() task.defer(refreshCrystals) end))
    addConnection(folder.ChildRemoved:Connect(function() task.defer(refreshCrystals) end))
end
local existingCrystalFolder = workspace:FindFirstChild("mapCrystalsFolder")
if existingCrystalFolder then connectCrystalFolder(existingCrystalFolder) end
addConnection(workspace.ChildAdded:Connect(function(child)
    if child.Name == "mapCrystalsFolder" then
        connectCrystalFolder(child)
        task.defer(refreshCrystals)
    end
end))

-- =============================================================
-- RACES
-- =============================================================
raceTab:AddSection({"Race Automation"})
raceTab:AddParagraph({"Server Authority",
    "Race finishing uses the legacy local finish-part movement technique. "
        .. "It may not award anything if the game validates completion on the server."})

local autoJoinRace, autoFinishRace = false, false
local finishingRace = false

local function raceIsActive(valueName)
    local value = ReplicatedStorage:FindFirstChild(valueName)
    if not value then return false end
    local ok, result = pcall(function() return value.Value end)
    return ok and result == true
end

local function joinRace()
    if not autoJoinRace or not runtime.alive then return end
    if fireRemote("raceEvent", "joinRace") then
        runtime.attempts.races = runtime.attempts.races + 1
        setActivity("Race join request sent")
    end
    local gui = player:FindFirstChildOfClass("PlayerGui")
    local gameGui = gui and gui:FindFirstChild("gameGui")
    local label = gameGui and gameGui:FindFirstChild("raceJoinLabel")
    if label and label:IsA("GuiObject") then label.Visible = false end
end

local function finishRace()
    if not autoFinishRace or not runtime.alive or finishingRace then return end
    finishingRace = true
    safely("Finish Race", function()
        local root = getRootPart()
        local raceMaps = workspace:FindFirstChild("raceMaps")
        if not root or not raceMaps then return end
        for _, raceMap in ipairs(raceMaps:GetChildren()) do
            if not runtime.alive or not autoFinishRace then break end
            local finishPart = raceMap:FindFirstChild("finishPart")
            if finishPart and finishPart:IsA("BasePart") then
                local previous = finishPart.CFrame
                local ok, err = pcall(function()
                    finishPart.CFrame = root.CFrame
                    task.wait(0.12)
                end)
                pcall(function() finishPart.CFrame = previous end)
                if not ok then logError("Finish Race", err) end
            end
        end
        setActivity("Local race finish attempt completed")
    end)
    finishingRace = false
end

runtime.toggles.autoJoinRace = raceTab:AddToggle({
    Name = "Auto Join Race", Description = "Sends the join request when a race opens.",
    Default = false,
    Callback = function(enabled)
        autoJoinRace = enabled
        if enabled and raceIsActive("raceInProgress") then task.spawn(joinRace) end
    end,
})
runtime.toggles.autoFinishRace = raceTab:AddToggle({
    Name = "Auto Finish Race", Description = "Attempts legacy finish-part collection on race start.",
    Default = false,
    Callback = function(enabled)
        autoFinishRace = enabled
        if enabled and raceIsActive("raceStarted") then task.spawn(finishRace) end
    end,
})

local raceInProgress = ReplicatedStorage:FindFirstChild("raceInProgress")
if raceInProgress then
    addConnection(raceInProgress.Changed:Connect(function(value)
        if value == true then task.spawn(joinRace) end
    end))
end
local raceStarted = ReplicatedStorage:FindFirstChild("raceStarted")
if raceStarted then
    addConnection(raceStarted.Changed:Connect(function(value)
        if value == true then task.spawn(finishRace) end
    end))
end

-- =============================================================
-- TELEPORTS AND SERVER TOOLS
-- =============================================================
teleportTab:AddSection({"Map Teleports"})
local PLACES = {
    City = 3101667897,
    Space = 3232996272,
    Desert = 3276265788,
}

local CITY_COORDINATES = {
    {"City", Vector3.new(-9687, 59, 3096)},
    {"Snow City", Vector3.new(-9677, 59, 3783)},
    {"Magma City", Vector3.new(-11053, 217, 4896)},
    {"Legends Highway", Vector3.new(-13097, 217, 5904)},
}

local function teleportToPlace(placeId)
    safely("Teleport", function()
        TeleportService:Teleport(placeId, player)
    end)
end

if game.PlaceId == PLACES.City then
    for _, destination in ipairs(CITY_COORDINATES) do
        teleportTab:AddButton({destination[1], function()
            local character = getCharacter()
            if not character then return end
            safely("Local Teleport", function()
                character:PivotTo(CFrame.new(destination[2]))
                setActivity("Teleported to " .. destination[1])
            end)
        end})
    end
end
for _, location in ipairs({"City", "Space", "Desert"}) do
    local placeId = PLACES[location]
    if game.PlaceId ~= placeId then
        teleportTab:AddButton({"Travel to " .. location, function()
            teleportToPlace(placeId)
        end})
    end
end

teleportTab:AddSection({"Server Utilities"})
teleportTab:AddButton({"Rejoin Current Place", function()
    teleportToPlace(game.PlaceId)
end})

teleportTab:AddSlider({
    Name = "Maximum Server Players", Min = 1, Max = 12,
    Default = settings.serverMaxPlayers, Increase = 1,
    Callback = function(value)
        if type(value) == "number" then
            settings.serverMaxPlayers = math.clamp(math.floor(value), 1, 12)
        end
    end,
})

local findingServer = false
local function findSmallServer()
    if findingServer then return end
    findingServer = true
    local ok, err = pcall(function()
        local cursor = nil
        local bestServer = nil
        for _ = 1, 3 do
            if not runtime.alive then break end
            local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId)
                .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor then url = url .. "&cursor=" .. HttpService:UrlEncode(cursor) end
            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)
            if type(data) ~= "table" or type(data.data) ~= "table" then
                error("Invalid Roblox public server response")
            end
            for _, server in ipairs(data.data) do
                if type(server.playing) == "number" and type(server.maxPlayers) == "number"
                    and type(server.id) == "string" and server.id ~= game.JobId
                    and server.playing < server.maxPlayers then
                    if not bestServer or server.playing < bestServer.playing then
                        bestServer = server
                    end
                end
            end
            if bestServer and bestServer.playing <= settings.serverMaxPlayers then break end
            cursor = data.nextPageCursor
            if not cursor or cursor == "" then break end
        end
        if not bestServer then
            notify(HUB_NAME, "No available server found.")
            return
        end
        if bestServer.playing > settings.serverMaxPlayers then
            notify(HUB_NAME, "No server matched the player limit. Lower-population fallback not attempted.")
            return
        end
        setActivity("Traveling to server with " .. bestServer.playing .. " players")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id, player)
    end)
    if not ok then
        logError("Server Hop", err)
        notify(HUB_NAME, "Server search failed. Your executor may block HTTP requests.")
    end
    findingServer = false
end

teleportTab:AddButton({"Join Low Population Server", function()
    task.spawn(findSmallServer)
end})

-- =============================================================
-- PLAYER SETTINGS
-- =============================================================
playerTab:AddSection({"Movement"})
playerTab:AddSlider({
    Name = "WalkSpeed", Min = 16, Max = 500, Increase = 1,
    Default = settings.walkSpeed,
    Callback = function(value)
        if type(value) == "number" then
            settings.walkSpeed = value
            applyMovement()
        end
    end,
})
playerTab:AddSlider({
    Name = "JumpPower", Min = 50, Max = 300, Increase = 1,
    Default = settings.jumpPower,
    Callback = function(value)
        if type(value) == "number" then
            settings.jumpPower = value
            applyMovement()
        end
    end,
})
playerTab:AddToggle({
    Name = "Apply Custom Movement",
    Description = "Movement changes are opt-in and reapply after respawning.",
    Default = false,
    Callback = function(enabled)
        runtime.customMovement = enabled
        if enabled then applyMovement() else restoreMovement() end
    end,
})
playerTab:AddToggle({
    Name = "No Clip", Description = "Disables local character collisions while enabled.",
    Default = false, Callback = setNoclip,
})
playerTab:AddToggle({
    Name = "Infinite Jump", Description = "Jump repeatedly while airborne.",
    Default = false,
    Callback = function(enabled) runtime.infiniteJump = enabled end,
})

local nextNoclipScan = 0
addConnection(RunService.Stepped:Connect(function()
    if not runtime.alive or not runtime.noClip then return end
    if os.clock() < nextNoclipScan then return end
    nextNoclipScan = os.clock() + 0.12
    local character = getCharacter()
    if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            rememberProperty(runtime.originalCollision, descendant, "CanCollide")
            descendant.CanCollide = false
        end
    end
end))

addConnection(UserInputService.JumpRequest:Connect(function()
    if runtime.alive and runtime.infiniteJump then
        local humanoid = getHumanoid()
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

addConnection(player.CharacterAdded:Connect(function()
    task.delay(0.3, function()
        if not runtime.alive then return end
        if runtime.customMovement then safely("Movement", applyMovement) end
        if runtime.hidePopups then setPopupVisibility(true) end
    end)
end))

playerTab:AddSection({"Player Teleport"})
local function listPlayers()
    local names = {}
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then table.insert(names, otherPlayer.Name) end
    end
    table.sort(names)
    return names
end

runtime.selectedPlayerDropdown = playerTab:AddDropdown({
    Name = "Select Player", Options = listPlayers(), Default = "",
    Callback = function(value)
        if type(value) == "string" and value ~= "nil" then
            runtime.selectedPlayer = value
        end
    end,
})

local function refreshPlayerDropdown()
    local names = listPlayers()
    safely("Refresh Players", function()
        runtime.selectedPlayerDropdown:Set(names)
        if runtime.selectedPlayer and isChoice(runtime.selectedPlayer, names) then
            runtime.selectedPlayerDropdown:Select(runtime.selectedPlayer)
        else
            runtime.selectedPlayer = nil
        end
    end)
end

playerTab:AddButton({"Refresh Player List", refreshPlayerDropdown})
playerTab:AddButton({"Teleport to Selected Player", function()
    if not runtime.selectedPlayer then
        notify(HUB_NAME, "Select a player first.")
        return
    end
    local target = Players:FindFirstChild(runtime.selectedPlayer)
    local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local character = getCharacter()
    if targetRoot and character then
        safely("Player Teleport", function()
            character:PivotTo(targetRoot.CFrame * CFrame.new(0, 2, 3))
        end)
    else
        notify(HUB_NAME, "Target character is unavailable.")
    end
end})
addConnection(Players.PlayerAdded:Connect(function()
    task.defer(refreshPlayerDropdown)
end))
addConnection(Players.PlayerRemoving:Connect(function()
    task.defer(refreshPlayerDropdown)
end))

-- =============================================================
-- SETTINGS
-- =============================================================
settingsTab:AddSection({"Appearance & Performance"})
settingsTab:AddDropdown({
    Name = "UI Theme", Options = THEMES, Default = settings.theme,
    Callback = function(value)
        if isChoice(value, THEMES) then
            settings.theme = value
            safely("Theme", function() library:SetTheme(value) end)
        end
    end,
})
settingsTab:AddToggle({
    Name = "Hide Reward Popups",
    Description = "Suppresses known orb and trail notifications; restores on disable.",
    Default = false, Callback = setPopupVisibility,
})
settingsTab:AddToggle({
    Name = "Low Graphics",
    Description = "Temporarily disables particles, beams, trails and world shadows.",
    Default = false, Callback = setLowGraphics,
})
addConnection(workspace.DescendantAdded:Connect(function(descendant)
    if runtime.alive and runtime.lowGraphics then applyLowGraphics(descendant) end
end))
settingsTab:AddToggle({
    Name = "Anti AFK", Description = "Simulates a single input only when the Idled event fires.",
    Default = true,
    Callback = function(enabled) runtime.antiAfk = enabled end,
})
addConnection(player.Idled:Connect(function()
    if not runtime.alive or not runtime.antiAfk then return end
    safely("Anti AFK", function()
        local camera = workspace.CurrentCamera
        if not camera then return end
        VirtualUser:Button2Down(Vector2.zero, camera.CFrame)
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.zero, camera.CFrame)
    end)
end))

settingsTab:AddSection({"Settings & Controls"})
settingsTab:AddButton({"Save Configuration", function()
    local ok, err = saveSettings()
    notify(HUB_NAME, ok and "Configuration saved." or tostring(err))
end})
settingsTab:AddButton({"Copy Debug Status", function()
    local text = HUB_NAME .. " " .. VERSION .. "\nPlace: " .. game.PlaceId
        .. "\nFPS: " .. runtime.fps
        .. "\nLast action: " .. runtime.lastAction
        .. "\nLast error: " .. runtime.lastError
    if type(setclipboard) == "function" then
        safely("Clipboard", function() setclipboard(text) end)
        notify(HUB_NAME, "Debug status copied.")
    else
        notify(HUB_NAME, text, 8)
    end
end})
settingsTab:AddButton({"Minimize / Restore (Right Ctrl)", function()
    window:Minimize()
end})
addConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not runtime.alive then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        window:Minimize()
    end
end))
settingsTab:AddButton({"Unload None Hub", function()
    window:Dialog({
        Title = "Unload None Hub",
        Text = "Stop all workers, restore local changes and close the UI?",
        Options = {
            {"Unload", function()
                runtime.Shutdown(true)
            end},
            {"Cancel"},
        },
    })
end})

-- =============================================================
-- HELP AND CREDITS
-- =============================================================
helpTab:AddSection({"Project"})
helpTab:AddParagraph({"None Hub Remastered", "Version " .. VERSION .. " | Legends of Speed\nDeveloper: nexustester\nLegacy name: NovaHUB"})
helpTab:AddParagraph({"What Changed",
    "A structured worker system, protected inventory automation, safe session shutdown, "
        .. "live telemetry, dynamic dropdowns, custom configuration, and UI error handling."})
helpTab:AddSection({"Legacy Glitch Notes"})
helpTab:AddParagraph({"Original Guide",
    "1. Equip a level 1 pet with no XP.\n"
        .. "2. Select Yellow Orb in Auto Farm.\n"
        .. "3. Avoid collecting unwanted XP.\n"
        .. "4. Use only the required orb feature.\n"
        .. "5. The original guide suggested an odd-numbered rebirth count."})
helpTab:AddParagraph({"Important",
    "The legacy pet-power glitch is not verified to work.\n"
        .. "Server-side checks, anticheat and game updates can prevent individual features."})
helpTab:AddButton({"Copy Community Invite", function()
    if type(setclipboard) == "function" then
        safely("Clipboard", function() setclipboard(DISCORD_URL) end)
    else
        notify(HUB_NAME, DISCORD_URL)
    end
end})

notify(HUB_NAME .. " v" .. VERSION, "Loaded successfully. Review settings before enabling automatic selling.", 6)
setActivity("Hub loaded successfully")
