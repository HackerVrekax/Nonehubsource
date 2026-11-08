-- Hook loadstring so ezzz
-- By FTAP Reverse
-- t.me/ReverseFTAP
--[[
	None Hub (Revive Hubs)
	This script was inspired by GOAT Tiger X Hub
	UI: WindUI (https://github.com/Footagesus/WindUI)
]]

-- ===== Config =====
local HUB_NAME   = "None Hub"
local HUB_SUB    = "Universal"
local INSPIRED   = "By nexusdeev and inpired in tiger x hub"
local DISCORD    = "https://discord.gg/qz2QKyaA5P"
local WINDUI_URL = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer      = Players.LocalPlayer

-- ===== Intro: mensagem + convite do Discord =====
local function guiParent()
	local ok, ui = pcall(function() return gethui and gethui() end)
	if ok and ui then return ui end
	return game:GetService("CoreGui")
end

local function tween(obj, t, props)
	local tw = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function round(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = obj
end

local function showIntro(onDone)
	local gui = Instance.new("ScreenGui")
	gui.Name = "NoneHubIntro"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999
	gui.Parent = guiParent()

	-- Fundo
	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 1
	bg.Parent = gui
	tween(bg, 0.4, { BackgroundTransparency = 0.35 })

	-- Mensagem antes de carregar
	local msg = Instance.new("Frame")
	msg.AnchorPoint = Vector2.new(0.5, 0.5)
	msg.Position = UDim2.fromScale(0.5, 0.5)
	msg.Size = UDim2.fromOffset(360, 120)
	msg.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	msg.Parent = bg
	round(msg, 12)

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(0, 14)
	title.Size = UDim2.new(1, 0, 0, 28)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Text = HUB_NAME .. " (" .. HUB_SUB .. ")"
	title.Parent = msg

	local text = Instance.new("TextLabel")
	text.BackgroundTransparency = 1
	text.Position = UDim2.fromOffset(12, 48)
	text.Size = UDim2.new(1, -24, 0, 36)
	text.Font = Enum.Font.Gotham
	text.TextSize = 15
	text.TextWrapped = true
	text.TextColor3 = Color3.fromRGB(200, 200, 210)
	text.Text = INSPIRED
	text.Parent = msg

	local barBg = Instance.new("Frame")
	barBg.AnchorPoint = Vector2.new(0.5, 1)
	barBg.Position = UDim2.new(0.5, 0, 1, -14)
	barBg.Size = UDim2.new(1, -40, 0, 6)
	barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	barBg.Parent = msg
	round(barBg, 3)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromScale(0, 1)
	bar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	bar.Parent = barBg
	round(bar, 3)

	tween(bar, 3.5, { Size = UDim2.fromScale(1, 1) })
	task.wait(3.7)
	msg:Destroy()

	-- Convite do Discord (X para fechar + botão copiar)
	local card = Instance.new("Frame")
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.Size = UDim2.fromOffset(340, 170)
	card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	card.Parent = bg
	round(card, 12)

	local ctitle = Instance.new("TextLabel")
	ctitle.BackgroundTransparency = 1
	ctitle.Position = UDim2.fromOffset(16, 12)
	ctitle.Size = UDim2.new(1, -60, 0, 26)
	ctitle.Font = Enum.Font.GothamBold
	ctitle.TextSize = 18
	ctitle.TextXAlignment = Enum.TextXAlignment.Left
	ctitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	ctitle.Text = "Entre no nosso Discord!"
	ctitle.Parent = card

	local clink = Instance.new("TextLabel")
	clink.BackgroundTransparency = 1
	clink.Position = UDim2.fromOffset(16, 50)
	clink.Size = UDim2.new(1, -32, 0, 40)
	clink.Font = Enum.Font.Gotham
	clink.TextSize = 14
	clink.TextWrapped = true
	clink.TextXAlignment = Enum.TextXAlignment.Left
	clink.TextColor3 = Color3.fromRGB(140, 160, 255)
	clink.Text = "Copie o convite abaixo e entre no servidor:\n" .. DISCORD
	clink.Parent = card

	local copy = Instance.new("TextButton")
	copy.AnchorPoint = Vector2.new(0.5, 1)
	copy.Position = UDim2.new(0.5, 0, 1, -16)
	copy.Size = UDim2.new(1, -32, 0, 38)
	copy.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	copy.Font = Enum.Font.GothamBold
	copy.TextSize = 15
	copy.TextColor3 = Color3.fromRGB(255, 255, 255)
	copy.Text = "Copiar convite"
	copy.AutoButtonColor = true
	copy.Parent = card
	round(copy, 8)

	local close = Instance.new("TextButton")
	close.Position = UDim2.new(1, -40, 0, 10)
	close.Size = UDim2.fromOffset(28, 28)
	close.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 16
	close.TextColor3 = Color3.fromRGB(255, 255, 255)
	close.Text = "X"
	close.Parent = card
	round(close, 8)

	copy.MouseButton1Click:Connect(function()
		pcall(function() setclipboard(DISCORD) end)
		copy.Text = "Copiado!"
		task.delay(2, function()
			if copy and copy.Parent then copy.Text = "Copiar convite" end
		end)
	end)

	close.MouseButton1Click:Connect(function()
		tween(bg, 0.25, { BackgroundTransparency = 1 })
		card:Destroy()
		task.wait(0.3)
		gui:Destroy()
		onDone()
	end)
end

-- ===== Hub (WindUI) =====
local function startHub()
	local WindUI = loadstring(game:HttpGet(WINDUI_URL))()

	local function run(fn)
		return function()
			local ok, err = pcall(fn)
			if not ok then
				WindUI:Notify({ Title = HUB_NAME, Content = "Erro: " .. tostring(err), Duration = 6 })
			end
		end
	end

	local Window = WindUI:CreateWindow({
		Title = HUB_NAME,
		Author = HUB_SUB,
		Folder = "NoneHub",
		Icon = "bird",
		Size = UDim2.fromOffset(580, 460),
		Theme = "Dark",
		OpenButton = {
			Title = HUB_NAME,
			CornerRadius = UDim.new(1, 0),
			StrokeThickness = 3,
			Enabled = true,
			Draggable = true,
			Color = ColorSequence.new(Color3.fromHex("#5865F2"), Color3.fromHex("#9b59ff")),
		},
	})

	pcall(function()
		Window:Tag({ Title = "v1.0", Color = Color3.fromHex("#1c1c1c"), Border = true })
	end)

	WindUI:Notify({ Title = HUB_NAME, Content = INSPIRED, Duration = 5, Icon = "bird" })

	-- ===== Home =====
	do
		local Tab = Window:Tab({ Title = "Home", Icon = "house" })
		local Sec = Tab:Section({ Title = "Informações (clique para copiar)", Box = true, BoxBorder = true, Opened = true })
		local gameName = "Unknown"
		pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
		local executor = "Unknown"
		pcall(function() executor = identifyexecutor() end)

		local function info(title, value)
			Sec:Button({
				Title = title,
				Desc = tostring(value),
				Callback = run(function() setclipboard(tostring(value)) end),
			})
		end
		info("Username", LocalPlayer.Name)
		info("Display", LocalPlayer.DisplayName)
		info("Player Id", LocalPlayer.UserId)
		info("Account Age", LocalPlayer.AccountAge)
		info("Executor", executor)
		info("Game Name", gameName)
		info("Game Id", game.PlaceId)
		info("Players In Server", #Players:GetPlayers())
	end


-- ===== Scripts =====
do
	local Tab = Window:Tab({ Title = "Scripts", Icon = "scroll" })
	do
		local Sec = Tab:Section({ Title = "Scripts", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Keyboard", Callback = run(function()
			local v15 = loadstring(game:HttpGet("https://pastebin.com/raw/kC3dAMvt"))
			v15()
		end) })
		Sec:Button({ Title = "Keyboard V3", Callback = run(function()
			local v17 = loadstring(game:HttpGet("https://raw.githubusercontent.com/DHBCommunity/DHBOfficialScript/main/mobkeyboardv3"))
			v17()
		end) })
		Sec:Button({ Title = "LALOL Hub", Callback = run(function()
			local v19 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script"))
			v19()
		end) })
		Sec:Button({ Title = "Arosia", Callback = run(function()
			local v20 = game:GetObjects("rbxassetid://1255908305")
			local v21 = loadstring(v20[1].Source)
			v21()
		end) })
		Sec:Button({ Title = "fly gui v3 (UPDATED)", Callback = run(function()
			local v23 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-I-Fly-gui-V3-I-6627"))
			v23()
		end) })
		Sec:Button({ Title = "perm tp tool", Callback = run(function()
			local v25 = loadstring(game:HttpGet("https://pastefy.app/IpjIW7ZH/raw"))
			v25()
		end) })
		Sec:Button({ Title = "Admin Chat", Callback = run(function()
			local v27 = loadstring(game:HttpGet("https://raw.githubusercontent.com/game-hax/uca/main/release/uca.min.lua"))
			v27()
		end) })
		Sec:Button({ Title = "QuirkyCMD", Callback = run(function()
			local v29 = loadstring(game:HttpGet("https://gist.github.com/someunknowndude/38cecea5be9d75cb743eac8b1eaf6758/raw"))
			v29()
		end) })
		Sec:Button({ Title = "Time Stop", Callback = run(function()
			local v31 = loadstring(game:HttpGet("https://pastebin.com/raw/djAd7g2W"))
			v31()
		end) })
		Sec:Button({ Title = "Pshader V5.4", Callback = run(function()
			local v33 = loadstring(game:HttpGet("https://pastefy.app/xXkUxA0P/raw", true))
			v33()
		end) })
		Sec:Button({ Title = "Realistic Cam", Callback = run(function()
			local v35 = loadstring(game:HttpGet("https://pastebin.com/raw/kuK0XYAg", true))
			v35()
		end) })
		Sec:Button({ Title = "Spectate", Callback = run(function()
			local v37 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Spectate-Gui/main/Spectate"))
			v37()
		end) })
		Sec:Button({ Title = "FreeCam", Callback = run(function()
			local v39 = loadstring(game:HttpGet("https://raw.githubusercontent.com/zephyr10101/CameraSpy/main/Script", true))
			v39()
		end) })
		Sec:Button({ Title = "Touch Fling", Callback = run(function()
			local v41 = loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI"))
			v41()
		end) })
		Sec:Button({ Title = "Animation Pack Gui", Callback = run(function()
			local v43 = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui", true))
			v43()
		end) })
		Sec:Button({ Title = "F3X", Callback = run(function()
			local v44 = game:GetObjects("rbxassetid://6695644299")
			local v45 = loadstring(v44[1].Source)
			v45()
		end) })
		Sec:Button({ Title = "FE Climb Walls", Callback = run(function()
			local v47 = loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_E872F3ky4888TSVdj6Adgi1hSLtM038AyxVpTVw07QA3QUDcI3sxmuD869hYR4id.lua.txt"))
			v47()
		end) })
		Sec:Button({ Title = "Car Fly", Callback = run(function()
			local v49 = loadstring(game:HttpGet("https://pastebin.com/raw/MHE1cbWF"))
			v49()
		end) })
		Sec:Button({ Title = "Advaced User Info", Callback = run(function()
			local v51 = loadstring(game:HttpGet("https://raw.githubusercontent.com/vortexexecutor/vortexscripts/main/userinfo"))
			v51()
		end) })
		Sec:Button({ Title = "Noclip", Callback = run(function()
			local v53 = loadstring(game:HttpGet("https://pastebin.com/raw/6T4skKuj"))
			v53()
		end) })
		Sec:Button({ Title = "Permanent ShiftLock", Callback = run(function()
			local v55 = loadstring(game:HttpGet("https://scriptblox.com/raw/Baseplate-Universal-Script-Permanent-Shift-Lock-6924"))
			v55()
		end) })
		Sec:Button({ Title = "Bypass Chat", Callback = run(function()
			local v57 = loadstring(game:HttpGet("https://pastes.io/raw/lstrrfipqq"))
			v57()
		end) })
		Sec:Button({ Title = "FE Chat draw", Callback = run(function()
			local v59 = loadstring(game:HttpGet("https://raw.githubusercontent.com/BidoSkinsYT/BidoSkinsYT/main/Fe%20Chat%20Draw"))
			v59()
		end) })
		Sec:Button({ Title = "Mouse Cursor V2", Callback = run(function()
			local v61 = loadstring(game:HttpGet("https://pastefy.app/58d8d52G/raw"))
			v61()
		end) })
		Sec:Button({ Title = "Boombox", Callback = run(function()
			local v63 = loadstring(game:HttpGet("https://pastebin.com/raw/D184sp8a"))
			v63()
		end) })
		Sec:Button({ Title = "FE Sonic Speed", Callback = run(function()
			local v65 = loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_11l7Y131YqJjZ31QmV5L8pI23V02b3191sEg26E75472Wl78Vi8870jRv5txZyL1.lua.txt"))
			v65()
		end) })
		Sec:Button({ Title = "FE Car", Callback = run(function()
			local v67 = loadstring(game:HttpGet("https://raw.githubusercontent.com/MonkoTubeYT/carscript/master/!carscript.lua", true))
			v67()
		end) })
		Sec:Button({ Title = "R6", Callback = run(function()
			local v69 = loadstring(game:HttpGet("https://pastebin.com/raw/uddpLUvu"))
			v69()
		end) })
	end
end

-- ===== Hub =====
do
	local Tab = Window:Tab({ Title = "Hub", Icon = "layout-grid" })
	do
		local Sec = Tab:Section({ Title = "Hub", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Alysse Hub V0.3", Callback = run(function()
			local v73 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NathTheDev/AlysseAndroid/main/loader.lua"))
			v73()
		end) })
		Sec:Button({ Title = "Multi Scripter X", Callback = run(function()
			local v75 = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Multi-Scripter-X/main/loader"))
			v75()
		end) })
		Sec:Button({ Title = "Plenum V0.5.1", Callback = run(function()
			local v77 = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Plenum-Hub/main/loader"))
			v77()
		end) })
		Sec:Button({ Title = "GHUB V14", Callback = run(function()
			local v79 = loadstring(game:HttpGet("https://raw.githubusercontent.com/gclich/GHUBV14XZ/main/Ghub_Main_Loader.txt"))
			v79()
		end) })
		Sec:Button({ Title = "Blizzard Hub V1", Callback = run(function()
			local v81 = loadstring(game:HttpGet("https://raw.githubusercontent.com/uaahjajajqoqiqkqhwhwhw/Blizzard-Hub-Official/main/Blizzard%20Hub.lua"))
			v81()
		end) })
		Sec:Button({ Title = "Game Hub V5", Callback = run(function()
			local v83 = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Game-Hub/main/loader"))
			v83()
		end) })
		Sec:Button({ Title = "Haxker_66666666 Hub", Callback = run(function()
			local v85 = loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeRobloxScripts1/Haxker_6666666-Hub/main/loader"))
			v85()
		end) })
		Sec:Button({ Title = "Ghost Hub", Callback = run(function()
			local v87 = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub"))
			v87()
		end) })
		Sec:Button({ Title = "Karlix Hub V0.1", Callback = run(function()
			local v89 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jezxboi/KarlixV1/main/KarlixV1"))
			v89()
		end) })
		Sec:Button({ Title = "GigaChad V5.5", Callback = run(function()
			local v91 = loadstring(game:HttpGet("https://raw.githubusercontent.com/OWJBWKQLAISH/GigaChad-Hub/main/Protected_3038811338432694.lua.txt"))
			v91()
		end) })
		Sec:Button({ Title = "Pendulum Hub", Callback = run(function()
			local v93 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tescalus/Pendulum-Hubs-Source/main/Pendulum%20Hub%20V5.lua"))
			v93()
		end) })
		Sec:Button({ Title = "Sky Hub", Callback = run(function()
			local v95 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Sky-Hub-10706"))
			v95()
		end) })
		Sec:Button({ Title = "Equinox Hub", Callback = run(function()
			local v97 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Domadicoof/Domadicoof/main/NewHubX.txt"))
			v97()
		end) })
		Sec:Button({ Title = "Void Hub", Callback = run(function()
			local v99 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Void-Hub-11130"))
			v99()
		end) })
		Sec:Button({ Title = "Butif Hub", Callback = run(function()
			local v101 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NEWBUTIF/Universal-Script-Hub/main/Butif%20Hub"))
			v101()
		end) })
		Sec:Button({ Title = "Junko Hub V5", Callback = run(function()
			local v103 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Juanko-Scripts/Roblox-scripts/main/Juanko%20Universal%20Hub%20OfuscasteLinkServerFile73829273728288ejfjshsrytdoudt7do"))
			v103()
		end) })
		Sec:Button({ Title = "SnapDragon Hub", Desc = "Key:SnapDragon", Callback = run(function()
			local v105 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ruszelds/Snap/main/Dragon", true))
			v105()
		end) })
		Sec:Button({ Title = "OrangeX Hub V4", Callback = run(function()
			local v107 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImJosh66/OrangeX-Hub-V4/main/Protected%20V4%20OrangeX%20TOP.txt"))
			v107()
		end) })
		Sec:Button({ Title = "British Hub V17", Callback = run(function()
			local v109 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RedCoat7888/BH/main/Protected_6274400031599569.lua%20(1).txt"))
			v109()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "OLD Version of My Hub", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Tiger X Hub V2", Callback = run(function()
			local v112 = loadstring(game:HttpGet("https://raw.githubusercontent.com/balintTheDevX/TigerX-V2/main/Back"))
			v112()
		end) })
		Sec:Button({ Title = "Tiger X Hub V1", Callback = run(function()
			local v114 = loadstring(game:HttpGet("https://raw.githubusercontent.com/balintTheDevX/TigerXhubV1/main/TigerXHubV1"))
			v114()
		end) })
	end
end

-- ===== Games =====
do
	local Tab = Window:Tab({ Title = "Games", Icon = "gamepad-2" })
	do
		local Sec = Tab:Section({ Title = "Prison Life", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Fe Bypass", Callback = run(function()
			local v117 = loadstring('loadstring(game:HttpGet("https://raw.githubusercontent.com/g00lXploiter/g00lXploiter/main/Fe%20bypass", true))()\n')
			v117()
		end) })
		Sec:Button({ Title = "Tiger Admin", Callback = run(function()
			local v119 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dalloc2/Roblox/main/TigerAdmin.lua"))
			v119()
		end) })
		Sec:Button({ Title = "PrisionWare", Callback = run(function()
			local v121 = loadstring(game:HttpGet("https://raw.githubusercontent.com/WinterDinder/56-Clubs-Prison-Life-REMASTERED-SCRIPT/main/Main", true))
			v121()
		end) })
		Sec:Button({ Title = "PrisonBreaker V1.5", Callback = run(function()
			local v123 = loadstring(game:HttpGet("https://pastebin.com/raw/ryt9hGz6"))
			v123()
		end) })
		Sec:Button({ Title = "Tbao Hub", Callback = run(function()
			local v125 = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaohubPrisonLife"))
			v125()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Brookhaven", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "JulHub", Callback = run(function()
			local v128 = loadstring(game:HttpGet("https://raw.githubusercontent.com/JulHubz/JulHub/main/JulHub"))
			v128()
		end) })
		Sec:Button({ Title = "Redz Hub", Callback = run(function()
			local v130 = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/REDzHUB/main/REDzHUB"))
			v130()
		end) })
		Sec:Button({ Title = "Random Brookhaven Script", Callback = run(function()
			local v132 = loadstring(game:HttpGet("https://freenote.biz/raw/uWOAu0F62v", true))
			v132()
		end) })
		Sec:Button({ Title = "R4D", Callback = run(function()
			local v134 = loadstring(game:HttpGet("https://raw.githubusercontent.com/M1ZZ001/BrookhavenR4D/main/Brookhaven%20R4D%20Script"))
			v134()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Blade Ball", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Bedol Hub", Callback = run(function()
			local v137 = loadstring(game:HttpGet("https://raw.githubusercontent.com/nqxlOfc/Loaders/main/Blade_Ball.lua"))
			v137()
		end) })
		Sec:Button({ Title = "EminX Hub", Callback = run(function()
			local v139 = loadstring(game:HttpGet("https://raw.githubusercontent.com/EminenceXLua/Blade-your-Balls/main/BladeBallLoader.lua", true))
			v139()
		end) })
		Sec:Button({ Title = "Freya Hub", Callback = run(function()
			local v141 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Athenamikaela/Freya/main/Freya%20by%20lenny"))
			v141()
		end) })
		Sec:Button({ Title = "Gblade Hub V5", Callback = run(function()
			local v143 = loadstring(game:HttpGet("https://raw.githubusercontent.com/GearV4/GBlade-V5/main/GBlade%20V5"))
			v143()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "MM2", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Highlight MM2", Callback = run(function()
			local v146 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatSick/HighlightMM2/main/Main"))
			v146()
		end) })
		Sec:Button({ Title = "Vynixu", Callback = run(function()
			local v148 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Neon-Fox/roblox-scripts/main/VynixuMM2"))
			v148()
		end) })
		Sec:Button({ Title = "Esp Charm", Callback = run(function()
			local v150 = loadstring(game:HttpGet("https://github.com/TheXploiterYT/scripts/raw/main/mm2chams"))
			v150()
		end) })
		Sec:Button({ Title = "Eclipse Hub", Callback = run(function()
			getgenv().mainKey = "nil"
			local req = request or http_request or (syn and syn.request) or (http and http.request)
			assert(req, "Executor not supported")
			local res = req({ Url = "https://api.eclipsehub.xyz/auth?key=" .. tostring(getgenv().mainKey) })
			loadstring(res.Body)()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Jailbreak", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Universal Farm (Free)", Callback = run(function()
			local v158 = loadstring(game:HttpGet("https://raw.githubusercontent.com/BlitzIsKing/UniversalFarm/main/Loader/Regular"))
			v158()
		end) })
		Sec:Button({ Title = "Project Auto V3", Callback = run(function()
			local v160 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pxsta72/ProjectAuto/main/paid2"))
			v160()
		end) })
		Sec:Button({ Title = "Project Auto V2", Callback = run(function()
			local v162 = loadstring(game:HttpGet("https://scriptblox.com/raw/Jailbreak-project-auto-autorob-and-autoarrest-6846"))
			v162()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Bedwars", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Vape V4", Callback = run(function()
			local v165 = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))
			v165()
		end) })
		Sec:Button({ Title = "AISploit", Callback = run(function()
			local v167 = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlSploit/AlSploit/main/Bedwars"))
			v167()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Pet Sim 99", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "RedzHub", Callback = run(function()
			local v170 = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/PetSimulator99/main/redz9999.lua"))
			v170()
		end) })
		Sec:Button({ Title = "LDS Hub", Callback = run(function()
			local v172 = loadstring(game:HttpGet("https://raw.githubusercontent.com/limaspeedy/limaspeedy/main/HubLDS"))
			v172()
		end) })
		Sec:Button({ Title = "River Hub", Callback = run(function()
			local v174 = loadstring(game:HttpGet("https://raw.githubusercontent.com/SKOIXLL/RIVERHUB-SKYHUB/main/WL.lua"))
			v174()
		end) })
		Sec:Button({ Title = "Syrex Hub", Callback = run(function()
			local v176 = loadstring(game:HttpGet("https://syrexhub.netlify.app/raw/petsimulator99/syrexhub"))
			v176()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Piggy", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "T hub", Callback = run(function()
			_G.Key = "E3R-O399-NIL"
			local v179 = loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBABA/T-HUB/main/Main", true))
			v179()
		end) })
		Sec:Button({ Title = "Liver ZMods", Callback = run(function()
			local v181 = loadstring(game:HttpGet("https://encurtador.com.br/fiyFJ"))
			v181()
		end) })
		Sec:Button({ Title = "Peppa Script", Callback = run(function()
			local v183 = loadstring(game:HttpGet("https://pastebin.com/raw/ZNDQBwFy"))
			v183()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "BloxFruit", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "HOHO Hub", Callback = run(function()
			local v186 = loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))
			v186()
		end) })
		Sec:Button({ Title = "Makori Hub", Callback = run(function()
			local v188 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Domadicoof/Domadicoof/main/NewHubX.txt"))
			v188()
		end) })
		Sec:Button({ Title = "Modz Hub", Callback = run(function()
			local v190 = loadstring(game:HttpGet("https://raw.githubusercontent.com/1f0yt/community/master/modz"))
			v190()
		end) })
		Sec:Button({ Title = "Adel Hub", Callback = run(function()
			local v192 = loadstring(game:HttpGet("https://raw.githubusercontent.com/AdelOnTheTop/Adel-Hub/main/Main.lua"))
			v192()
		end) })
		Sec:Button({ Title = "Achemy Hub V2", Callback = run(function()
			v = 1
			local v194 = loadstring(game:HttpGet("https://alchemyhub.xyz/v2"))
			v194()
		end) })
		Sec:Button({ Title = "RedzHub", Callback = run(function()
			local v196 = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))
			v196()
		end) })
		Sec:Button({ Title = "WI-AZUR", Callback = run(function()
			local v198 = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))
			v198()
		end) })
		Sec:Button({ Title = "Min Gaming Hub", Callback = run(function()
			local v200 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Basicallyy/Basicallyy/main/MinGamingV4.lua"))
			v200()
		end) })
		Sec:Button({ Title = "Speed Hub X", Callback = run(function()
			local v202 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ahmadsgamer2/Speed-Hub-X/main/SpeedHubX", true))
			v202()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Adopt Me", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "JulHub", Callback = run(function()
			local v205 = loadstring(game:HttpGet("https://raw.githubusercontent.com/JulHubz/JulHub/main/JulHub"))
			v205()
		end) })
		Sec:Button({ Title = "Eclipse Hub", Callback = run(function()
			getgenv().mainKey = "nil"
			local req = request or http_request or (syn and syn.request) or (http and http.request)
			assert(req, "Executor not supported")
			local res = req({ Url = "https://api.eclipsehub.xyz/auth?key=" .. tostring(getgenv().mainKey) })
			loadstring(res.Body)()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "The Strongest BattleGround", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "OP Random Script 1", Callback = run(function()
			local v213 = loadstring(game:HttpGet("https://pastefy.app/REPoaFWC/raw", true))
			v213()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Car Dealership", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Tora is Me", Callback = run(function()
			local v216 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/car%20dealer", true))
			v216()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Doors", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "DarkCheatClient", Callback = run(function()
			local v219 = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaniaPerets/FolderGui-FolderHub/main/loader.lua", true))
			v219()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Infectious Smile", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Op Script 1", Callback = run(function()
			local v222 = loadstring(game:HttpGet("https://pastebin.com/raw/TqgbdDjF"))
			v222()
		end) })
		Sec:Button({ Title = "Nicuse", Callback = run(function()
			local v224 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nicuse/RobloxScripts/main/InfectiousSmile.lua", true))
			v224()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Bloxburg", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Vysor (Free)", Callback = run(function()
			local v227 = loadstring(game:HttpGet("https://vysorbloxburg.vercel.app/free.lua", true))
			v227()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Bakugan Brawl Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Inf Coins", Callback = run(function()
			local v230 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/Bakugan%20Brawl%20Simulator"))
			v230()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Tower of hell", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Vulture Hub", Callback = run(function()
			local v233 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoahCodeMaster/NoahsHub/main/Games/Toh.lua"))
			v233()
		end) })
		Sec:Button({ Title = "TheMystery_O_O", Callback = run(function()
			local v235 = loadstring(game:HttpGet("https://pastebin.com/raw/BbVHjH56"))
			v235()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Money Grab Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Inf Strenght Inf Money", Callback = run(function()
			local v238 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Hah/main/Me%20and%20my%20monkeh"))
			v238()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Ultimate Factory Tycoon", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Inf Money", Callback = run(function()
			local v241 = loadstring(game:HttpGet("https://raw.githubusercontent.com/AdminEvilDRagon/Ultimate-Factory-Tycoon/main/UFT.Lua"))
			v241()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Running Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "56 Clubs", Callback = run(function()
			local v244 = loadstring(game:HttpGet("https://raw.githubusercontent.com/WinterDinder/Running-Simulator/main/Main"))
			v244()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Break in 2", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Jn hh and Playvora_ Hub", Callback = run(function()
			local v247 = loadstring(game:HttpGet("https://freenote.biz/raw/80jXm2Q0a7"))
			v247()
		end) })
		Sec:Button({ Title = "Breaking Blitz", Callback = run(function()
			local v249 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RScriptz/RobloxScripts/main/BreakIn2.lua"))
			v249()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Natural Disaster Survival", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Six Hub", Callback = run(function()
			local v252 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ySixxNz/Natural-Desastre/SIX-MENU/SIX-HUB-NATURAL-DESASTRE"))
			v252()
		end) })
		Sec:Button({ Title = "Rochips V0.1", Callback = run(function()
			local v254 = loadstring(game:HttpGet("https://pastebin.com/raw/Vnqmafp0"))
			v254()
		end) })
		Sec:Button({ Title = "Natural Disaster Hub", Callback = run(function()
			local v256 = loadstring(game:HttpGet("https://raw.githubusercontent.com/SmartModBoy/VortexAblity/main/SV"))
			v256()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Taxi Boss", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Random Script", Callback = run(function()
			local v259 = loadstring(game:HttpGet("https://pastebin.com/raw/5ScA4pR9"))
			v259()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Doomsprite Brickbattle", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "No Coldown", Callback = run(function()
			local v262 = loadstring(game:HttpGet("https://raw.githubusercontent.com/hanzakun/Roblox-Scripts/main/Doomspire%20Brickbattle.lua"))
			v262()
		end) })
		Sec:Button({ Title = "Brick Hub", Callback = run(function()
			local v264 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yousuck780/brickhub/main/V1"))
			v264()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Murder Vs Sheriff", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Ruby Hub", Callback = run(function()
			local v267 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Deni210/murdersvssherrifsduels/main/rubyhub"))
			v267()
		end) })
		Sec:Button({ Title = "Murder Vs Sheriff Duel", Callback = run(function()
			local v269 = loadstring(game:HttpGet("https://pastebin.com/raw/vjTWQ8wW"))
			v269()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Ninja Legend", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Horizon.cc V5", Callback = run(function()
			local v272 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Shadetamic/horizon/main/loadstring.lua"))
			v272()
		end) })
		Sec:Button({ Title = "Proxima Hub", Callback = run(function()
			local v274 = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrixAde/Proxima-Hub/main/Main.lua"))
			v274()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Pet Catchers", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "GatoHub", Callback = run(function()
			local v277 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Catto-YFCN/GatoHub/main/PetCatchers"))
			v277()
		end) })
		Sec:Button({ Title = "Idiot Hub", Callback = run(function()
			local v279 = loadstring(game:HttpGet("https://raw.githubusercontent.com/IdiotHub/Scripts/main/Pet%20Catcher/Pet%20Catchers%20Main"))
			v279()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Slap Battles", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "R20", Callback = run(function()
			local v282 = loadstring(game:HttpGet("https://raw.githubusercontent.com/cheesynob39/R2O/main/LOADSTRING.lua"))
			v282()
		end) })
		Sec:Button({ Title = "Dizzy Hub", Callback = run(function()
			local v284 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dizyhvh/slap_battles_gui/main/0.lua"))
			v284()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "KAT", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Hitbox Gui", Callback = run(function()
			local v287 = loadstring(game:HttpGet("https://pastebin.com/raw/peFsakEW"))
			v287()
		end) })
		Sec:Button({ Title = "Owl Hub", Callback = run(function()
			local v289 = loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))
			v289()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Strongman Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "KhSaeedHub", Callback = run(function()
			local v292 = loadstring(game:HttpGet("https://github.com/KhSaeed90/Roblox/raw/workspace/6766156863"))
			v292()
		end) })
		Sec:Button({ Title = "Destiny SS", Callback = run(function()
			local v294 = loadstring(game:HttpGet("https://raw.githubusercontent.com/itsnoctural/Destiny/main/loader.lua"))
			v294()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "My Restaurant", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "My Restaurant script 1", Callback = run(function()
			local v297 = loadstring(game:HttpGet("https://pastebin.com/raw/uBpUr2vU"))
			v297()
		end) })
		Sec:Button({ Title = "Uranium", Callback = run(function()
			local v299 = loadstring(game:HttpGet("https://gist.githubusercontent.com/SpencerDevv/4127570215e413bf8ab4e074791bcf45/raw/78b977974b36e2d5cde7a28dab7f9a464dd1a2c1/betaV5"))
			v299()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "a Dusty Trip", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Legend Handles YT", Callback = run(function()
			local v302 = loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/trip/main/dusty"))
			v302()
		end) })
		Sec:Button({ Title = "Demonic Hub V2", Callback = run(function()
			local v304 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Alan0947383/Demonic-HUB-V2/main/S-C-R-I-P-T.lua"))
			v304()
		end) })
		Sec:Button({ Title = "Suslik Hub", Callback = run(function()
			local v306 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KrutoySuslik/-SuslikHub-/main/%7CSuslik%20Hub%7C%20%7CAll%20Scripts%7C"))
			v306()
		end) })
		Sec:Button({ Title = "Script 4", Callback = run(function()
			local v308 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripterbacon/Test-Script/main/a%20dusty%20trip.Lua"))
			v308()
		end) })
		Sec:Button({ Title = "Grenryhna", Callback = run(function()
			local v310 = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b24be4c2985c6ae58525a99ff6a47151.lua"))
			v310()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Build a Boat for Treasure", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Zolars X Hub", Callback = run(function()
			local v313 = loadstring(game:HttpGet("https://raw.githubusercontent.com/VIPFirstTime/UploadFile/main/Protected_8627265294288055.lua"))
			v313()
		end) })
		Sec:Button({ Title = "Wayne.lua", Callback = run(function()
			local v315 = loadstring(game:HttpGet("https://raw.githubusercontent.com/epicdude99/waynee/main/loaderrr"))
			v315()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Bid Battles", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Bid Battles 1.0", Callback = run(function()
			local v318 = loadstring(game:HttpGet("https://raw.githubusercontent.com/hawtdawgz/ScriptRepository/main/Protected.lua"))
			v318()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Barry's Prison Run V2 Obby", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Infinite Scripts", Callback = run(function()
			local v321 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZhenX201/FE-Infinite-Money/main/source"))
			v321()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Starving Artist", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Starving Arts", Callback = run(function()
			local v324 = loadstring(game:HttpGet("https://raw.githubusercontent.com/itsnoctural/Utilities/main/Closed/StarvingArtist.lua"))
			v324()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Work at a Pizza Place", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Pizza Factory", Callback = run(function()
			local v327 = loadstring(game:HttpGet("https://pastefy.app/yPtLMm8w/raw"))
			v327()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Greenville", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Lightux", Callback = run(function()
			local v330 = loadstring(game:HttpGet("https://raw.githubusercontent.com/cool83birdcarfly02six/Lightux/main/README.md"))
			v330()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Eat The World", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Reaper Hub", Callback = run(function()
			local v333 = loadstring(game:HttpGet("https://raw.githubusercontent.com/AyoReaper/Reaper-Hub/main/loader.lua"))
			v333()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Da Hood", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Detazy Hub", Callback = run(function()
			local v336 = loadstring(game:HttpGet("https://raw.githubusercontent.com/I4MMO/Detazy/main/Main"))
			v336()
		end) })
		Sec:Button({ Title = "Balli Gui V6", Callback = run(function()
			local v338 = loadstring(game:HttpGet("https://raw.githubusercontent.com/DHBCommunity/DHBOfficialScript/main/DHHScript"))
			v338()
		end) })
		Sec:Button({ Title = "Faded", Callback = run(function()
			_G.Toggles = "V"
			local v340 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NighterEpic/Faded/main/YesEpic", true))
			v340()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Raise A Floppa 2", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Leo Hub", Callback = run(function()
			local v343 = loadstring(game:HttpGet("https://raw.githubusercontent.com/tip52/Leo-hub/main/loader.lua"))
			v343()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "King Legacy", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "BT Project", Callback = run(function()
			local v346 = loadstring(game:HttpGetAsync("https://lua-library.btteam.net/script-auth.txt"))
			v346()
		end) })
		Sec:Button({ Title = "Legend HandlesYT", Callback = run(function()
			local v348 = loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/Upd6/main/King"))
			v348()
		end) })
		Sec:Button({ Title = "Zen Hub", Callback = run(function()
			local v350 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zenhubtop/zen_hub_pr/main/zennewwwwui.lua", true))
			v350()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Punch Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Demonic Hub V2", Callback = run(function()
			local v353 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Alan0947383/Boom/main/Protected_1198219713372149.lua.txt", true))
			v353()
		end) })
		Sec:Button({ Title = "BaconBossScript", Callback = run(function()
			local v355 = loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/PunchSim/main/PunchSim", true))
			v355()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Race Clicker", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Script 1", Callback = run(function()
			local v358 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Saaakai/Random-Roblox-Script/main/Race%20Clicker"))
			v358()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Pull a Sword", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "ToraScripts", Callback = run(function()
			local v361 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ToraScript/Script/main/PullaSword"))
			v361()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Goal Kick Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Script 1", Callback = run(function()
			local v364 = loadstring(game:HttpGet("https://github.com/KhSaeed90/Roblox/raw/workspace/9281034297"))
			v364()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Funky Friday", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Plutonium Hub", Callback = run(function()
			local v367 = loadstring(game:HttpGet("https://raw.githubusercontent.com/PawsThePaw/Plutonium.AA/main/Plutonium.Loader.lua", true))
			v367()
		end) })
		Sec:Button({ Title = "Script 2", Callback = run(function()
			local v369 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nadir3709/RandomScript/main/FunkyFridayMobile"))
			v369()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Answer or die", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Project PopCat", Desc = "Key:$8FUS5UjpGhaXzNCepDQUEhtb8Vsu2Cyd!", Callback = run(function()
			local v372 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Agent1Anonymous/gravitygun-main/main/0000ProjectpopCat.lua"))
			v372()
		end) })
		Sec:Button({ Title = "S Ware", Callback = run(function()
			local v374 = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaeelin/S-Ware/main/S-WAR"))
			v374()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Youtube Simulator Z", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Devil Hub", Callback = run(function()
			local v377 = loadstring(game:HttpGet("https://raw.githubusercontent.com/DEVIL-Script/DEVIL-Hub/main/DEVIL-Hub-Main", true))
			v377()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Demon Piece", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "OMG Hub", Callback = run(function()
			local v380 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))
			v380()
		end) })
		Sec:Button({ Title = "Mewing Hub", Callback = run(function()
			local v382 = loadstring(game:HttpGet("https://raw.githubusercontent.com/TranVanBao1411/MewingHub/main/Loader.lua"))
			v382()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Mega Mansion Tycoon", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Nicuse", Callback = run(function()
			local v385 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nicuse/RobloxScripts/main/MegaMansionTycoon.lua"))
			v385()
		end) })
		Sec:Button({ Title = "Statue Hub", Callback = run(function()
			local v387 = loadstring(game:HttpGet("https://raw.githubusercontent.com/idontknowwhattonamemyself/Statue-Hub/Lua/Main"))
			v387()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Flee The Facility", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Infinity Hub", Callback = run(function()
			local v390 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Aboahaogsigsigaivva/__Scripts/__Main/__Code/__FleeTheFacility.lua"))
			v390()
		end) })
		Sec:Button({ Title = "Lunar", Callback = run(function()
			local v392 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexIsHot/Lunar/main/FTF.lua", true))
			v392()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "3008", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "CheatX", Callback = run(function()
			local v395 = loadstring(game:HttpGet("https://pastebin.com/raw/4WtjGYge"))
			v395()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Driving Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Jens Hub", Callback = run(function()
			local v398 = loadstring(game:HttpGet("https://pastebin.com/raw/3a9x76Qq"))
			v398()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Military Tycoon", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Script 1", Callback = run(function()
			local v401 = loadstring(game:HttpGet("https://thedragonslayer2.github.io"))
			v401()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Piano Games", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Panda Hub", Callback = run(function()
			local v404 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Madness676/3.2Lol/main/AutoPiano3-2.lua", true))
			v404()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Pillow Fighting Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "NS Hub", Callback = run(function()
			local v407 = loadstring(game:HttpGet("https://raw.githubusercontent.com/HenSeu87PofghYT/PILLOW-FIGHTING-SIM/main/Nameless%20Scripts"))
			v407()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Project Mugetsu", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Script 1", Callback = run(function()
			local v410 = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheyCallMeVox/scripts/main/PM"))
			v410()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Merge Simulator", Box = true, BoxBorder = true, Opened = false })
		Sec:Button({ Title = "Inferno X", Callback = run(function()
			local v413 = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Script%20Hub%20-%20Inferno%20X.lua"))
			v413()
		end) })
	end
end

-- ===== Admin =====
do
	local Tab = Window:Tab({ Title = "Admin", Icon = "shield" })
	do
		local Sec = Tab:Section({ Title = "Admin", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Delta infinite yield", Callback = run(function()
			local v417 = loadstring(game:HttpGet("https://gist.githubusercontent.com/lxnnydev/c533c374ca4c1dcef4e1e10e33fa4a0c/raw/03e74f184f801dad77d3ebe1e2f18c6ac87ca612/delta___IY.gistfile1.txt.lua", true))
			v417()
		end) })
		Sec:Button({ Title = "infinite yield", Callback = run(function()
			local v419 = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))
			v419()
		end) })
		Sec:Button({ Title = "nameless admin", Callback = run(function()
			local v421 = loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))
			v421()
		end) })
		Sec:Button({ Title = "orca admin", Callback = run(function()
			local v423 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Orca-7620"))
			v423()
		end) })
		Sec:Button({ Title = "Reviz Admin", Callback = run(function()
			local v425 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Reviz-3841"))
			v425()
		end) })
		Sec:Button({ Title = "Cmd-x", Callback = run(function()
			local v427 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-CMD-X-Admin-Commands-Script-3837"))
			v427()
		end) })
		Sec:Button({ Title = "Dark Dex V3", Callback = run(function()
			local v429 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))
			v429()
		end) })
		Sec:Button({ Title = "nameless admin v2", Callback = run(function()
			local v431 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Nameless-Admin-V2-UNFINISHED-source-code-9359"))
			v431()
		end) })
		Sec:Button({ Title = "Dex Explorer", Callback = run(function()
			local v433 = loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))
			v433()
		end) })
		Sec:Button({ Title = "Simple Spy", Callback = run(function()
			local v435 = loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))
			v435()
		end) })
	end
end

-- ===== Exploits =====
do
	local Tab = Window:Tab({ Title = "Exploits", Icon = "terminal" })
	do
		local Sec = Tab:Section({ Title = "Mobile", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Arceus X", Callback = run(function()
			local v439 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Arceus-X-Script-Credit-to-AnyaDev-WORKS-WITH-ALL-SCRIPTS-8561"))
			v439()
		end) })
		Sec:Button({ Title = "Fluxus Coral", Callback = run(function()
			local v441 = loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Fluxus-Coral-ReMake-Beta-by-AnyaDev-8562"))
			v441()
		end) })
		Sec:Button({ Title = "Evon V2", Callback = run(function()
			local v443 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Gjdiddkslwodi/main/Vjvidie7fi3oe"))
			v443()
		end) })
		Sec:Button({ Title = "Krypton", Callback = run(function()
			local v445 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Ajdkfoepdpfpf0/main/FNUGGEYSJWIWOROD"))
			v445()
		end) })
		Sec:Button({ Title = "Codex", Callback = run(function()
			local v447 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Nuggey/main/Davabataxq"))
			v447()
		end) })
		Sec:Button({ Title = "Trigon", Callback = run(function()
			local v449 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Omg/main/Triaglan"))
			v449()
		end) })
		Sec:Button({ Title = "Vega X", Callback = run(function()
			local v451 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/OMGSUSIDSKEKWKAI3O/main/Cjdkwowiwi"))
			v451()
		end) })
		Sec:Button({ Title = "Delta X", Callback = run(function()
			local v453 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Deltozoz/main/Rick%20rolled"))
			v453()
		end) })
		Sec:Button({ Title = "Hydrogen", Callback = run(function()
			local v455 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Gjcjsjsidicuskdkfofofidkckfkwpw9er8fudidpapq0/main/Zhcifodoelsjaisdoocc9x9x0"))
			v455()
		end) })
		Sec:Button({ Title = "Kato", Callback = run(function()
			local v457 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Gdcucisuduvifnslzivv8dmebshd/main/Fjcjzicuveuwjd9dksjdf6r8ejej"))
			v457()
		end) })
		Sec:Button({ Title = "Flooded V", Callback = run(function()
			local v459 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Dudidwkoff7wueoeiddj/main/Ahdufidwid8fudkdkgoel"))
			v459()
		end) })
		Sec:Button({ Title = "Punk Team", Callback = run(function()
			local v461 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Hufuddixidke8vogd/main/Vdurigofeod8f"))
			v461()
		end) })
		Sec:Button({ Title = "Cubix", Callback = run(function()
			local v463 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/BarkOffCubix/main/Laughs"))
			v463()
		end) })
		Sec:Button({ Title = "Appleware", Callback = run(function()
			local v465 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Ohio/main/Xhdjskdkdiduvudke"))
			v465()
		end) })
		Sec:Button({ Title = "Techno", Callback = run(function()
			local v467 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Ucdjlsidufudekdififoek/main/Djdkgirueidiciswheh"))
			v467()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "Custom", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Nathans Executor", Callback = run(function()
			local v470 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Makeruwu/Scfipg/main/Executor2%2C3"))
			v470()
		end) })
		Sec:Button({ Title = "Neptune", Callback = run(function()
			local v472 = loadstring(game:HttpGet("https://pastebin.com/raw/y3jhxS5r"))
			v472()
		end) })
		Sec:Button({ Title = "Saturn", Callback = run(function()
			local v474 = loadstring(game:HttpGet("https://github.com/AnAvaragelilmemer/saturn/blob/main/main.lua?raw=true"))
			v474()
		end) })
		Sec:Button({ Title = "Syctro Executor", Callback = run(function()
			local v476 = loadstring(game:HttpGet("https://raw.githubusercontent.com/anyahubs/executer/main/S_UI.lua"))
			v476()
		end) })
		Sec:Button({ Title = "Chat Executor", Callback = run(function()
			local v478 = loadstring(game:HttpGet("https://raw.githubusercontent.com/zephyr10101/chat-executor/main/chat-executor", true))
			v478()
		end) })
	end
	do
		local Sec = Tab:Section({ Title = "PC", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Synapse X", Callback = run(function()
			local v481 = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Chillz-s-scripts/main/Synapse-X-Remake.lua"))
			v481()
		end) })
		Sec:Button({ Title = "Netflix CE 2.0", Callback = run(function()
			local v483 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Dhdusgdjyxuskxiv7didj/main/Ejdifydjakwidd7cisjsjsks8suwjdkdod"))
			v483()
		end) })
		Sec:Button({ Title = "Arceus X PC", Callback = run(function()
			local v485 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/AMONJDJDJDJGUSSYDUDJXJDISKSJ/main/ADJXDIOSDIFUEKEPDODP"))
			v485()
		end) })
		Sec:Button({ Title = "Codex PC", Callback = run(function()
			local v487 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/maxJJEDJDJSKwellDJDIFKDKEKK/main/Dhdjifudiekeksixi"))
			v487()
		end) })
		Sec:Button({ Title = "Krnl", Callback = run(function()
			local v489 = loadstring(game:HttpGet("https://raw.githubusercontent.com/wtfplayer/redemption/main/krnlnoui.lua"))
			v489()
		end) })
		Sec:Button({ Title = "Fluxus PC", Callback = run(function()
			local v491 = loadstring(game:HttpGet("https://raw.githubusercontent.com/anyahubs/executer/main/flux.lua"))
			v491()
		end) })
		Sec:Button({ Title = "Electron", Callback = run(function()
			local v493 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Elec/main/PC"))
			v493()
		end) })
		Sec:Button({ Title = "JJsploit", Callback = run(function()
			local v495 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/Fjcjdugifisshnrjdjdigrjejdiga3irifhsh/main/XSDEHUDDUSJWKEKRO"))
			v495()
		end) })
		Sec:Button({ Title = "Krampus", Callback = run(function()
			local v497 = loadstring(game:HttpGet("https://raw.githubusercontent.com/KevinScripts2024/HmmGuestoDeNoche/main/Ufosjsfieoeif"))
			v497()
		end) })
	end
end

	-- ===== Settings =====
	do
		local Tab = Window:Tab({ Title = "Settings", Icon = "settings" })
		local Sec = Tab:Section({ Title = "Speed Changer", Box = true, BoxBorder = true, Opened = true })

		local function hum()
			local char = LocalPlayer.Character
			return char and char:FindFirstChildOfClass("Humanoid")
		end

		Sec:Input({
			Title = "Set WalkSpeed",
			Placeholder = "16",
			Callback = run(function(v)
				local h, n = hum(), tonumber(v)
				if h and n then h.WalkSpeed = n end
			end),
		})
		Sec:Input({
			Title = "Set JumpPower",
			Placeholder = "50",
			Callback = run(function(v)
				local h, n = hum(), tonumber(v)
				if h and n then h.UseJumpPower = true; h.JumpPower = n end
			end),
		})
		Sec:Button({ Title = "Reset Walkspeed", Callback = run(function()
			local h = hum(); if h then h.WalkSpeed = 16 end
		end) })
		Sec:Button({ Title = "Reset Jumppower", Callback = run(function()
			local h = hum(); if h then h.JumpPower = 50 end
		end) })
	end

	-- ===== Credits =====
	do
		local Tab = Window:Tab({ Title = "Credits", Icon = "heart" })
		local Sec = Tab:Section({ Title = "Discord", Box = true, BoxBorder = true, Opened = true })
		Sec:Button({ Title = "Entrar no Discord", Desc = DISCORD, Callback = run(function()
			setclipboard(DISCORD)
			WindUI:Notify({ Title = HUB_NAME, Content = "Convite copiado!", Duration = 3, Icon = "check" })
		end) })
		local Sec2 = Tab:Section({ Title = "Créditos", Box = true, BoxBorder = true, Opened = true })
		Sec2:Button({ Title = HUB_NAME .. " (" .. HUB_SUB .. ")", Desc = INSPIRED })
		Sec2:Button({ Title = "Hub original: Tiger X Hub", Desc = "Criado por BananaBalintYT" })
		Sec2:Button({ Title = "UI: WindUI", Desc = "Footagesus", Callback = run(function()
			setclipboard("https://github.com/Footagesus/WindUI")
		end) })
	end

	pcall(function() Window:SelectTab(1) end)
end

showIntro(startHub)