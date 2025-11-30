local Rayfied = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Nino hub",
   Icon = nil, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Blox fruit",
   LoadingSubtitle = "by @Minhbeol",
   Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "FunscriptsGuiFF1"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key System",
      Subtitle = "To Verify your not a bot, Please type: Key1109888",
      Note = "Key is required to continue!", -- Use this to tell the user how to get a key
      FileName = "Keyforent1r11", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Key1109888"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local o1Tab = Window:CreateTab("Thông tin", "atom") -- Title, Image
local o2Tab = Window:CreateTab("Chính", "house") -- Title, Image
local o3Tab = Window:CreateTab("Vật phẩm", "swords") -- Title, Image
local o4Tab = Window:CreateTab("Nhiêm vụ", "badge-question-mark") -- Title, Image
local o5Tab = Window:CreateTab("Biển", "waves") -- Title, Image
local o6Tab = Window:CreateTab("Người chơi", "user") -- Title, Image
local o7Tab = Window:CreateTab("Chỉ số", "circle-plus") -- Title, Image
local o8Tab = Window:CreateTab("Tập kích", "zap") -- Title, Image
local o9Tab = Window:CreateTab("Trái", "cherry") -- Title, Image
local o10Tab = Window:CreateTab("Cửa hàng", "shopping-cart") -- Title, Image
local o11Tab = Window:CreateTab("Máy chủ", "server") -- Title, Image
local o12Tab = Window:CreateTab("Cài đặt", "cog") -- Title, Image

----------------------- FULL SHIELD v3 (MERGED) -----------------------
--------------------------- by real_minh ------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

------------------------------------------------------------------------
-- 1) ANTI KICK (KHÔNG SỬA METATABLE → AN TOÀN NHẤT)
------------------------------------------------------------------------
pcall(function()
    hookfunction(lp.Kick, function(self, msg)
        warn("[FULL-SHIELD] Kick Blocked:", msg)
        return nil
    end)
end)

------------------------------------------------------------------------
-- 2) SAFE TELEPORT + ANTI TELEPORT CHECK + CHỐNG BỊ KÉO NGƯỢC
------------------------------------------------------------------------
_G.SafeTP = function(pos)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local distance = (hrp.Position - pos).Magnitude
    local steps = math.clamp(math.floor(distance / 6), 12, 35)
    local start = hrp.Position
    local diff = (pos - start) / steps

    for i = 1, steps do
        hrp.CFrame = CFrame.new(start + diff * i)
        task.wait(0.015)
    end

    -- chống server kéo ngược lại
    task.delay(0.4, function()
        if (hrp.Position - pos).Magnitude > 5 then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

------------------------------------------------------------------------
-- 3) ANTI SPEED CHECK (bypass >55 stud/s)
------------------------------------------------------------------------
local lastPos = nil
local maxSpeed = 55

RunService.Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if lastPos then
        local d = (hrp.Position - lastPos).Magnitude
        if d > maxSpeed then
            hrp.CFrame = hrp.CFrame - hrp.CFrame.LookVector * (d - maxSpeed)
        end
    end

    lastPos = hrp.Position
end)

------------------------------------------------------------------------
-- 4) ANTI AUTOCLICK DETECT (giới hạn 13 CPS)
------------------------------------------------------------------------
local cps = 0
local maxCPS = 13

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        cps += 1
        if cps > maxCPS then cps = maxCPS - 2 end
    end
end)

task.spawn(function()
    while task.wait(1) do cps = 0 end
end)

------------------------------------------------------------------------
-- 5) ANTI FLY CHECK
------------------------------------------------------------------------
RunService.Stepped:Connect(function()
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")

    if hum and hum:GetState() == Enum.HumanoidStateType.Flying then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end)

------------------------------------------------------------------------
-- 6) ANTI NOCLIP DETECT
------------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.CanCollide == false then
        hrp.CanCollide = true
    end
end)

------------------------------------------------------------------------
-- 7) ANTI DAMAGE CHECK (chống đánh quá nhanh)
------------------------------------------------------------------------
local lastHit = 0
local minDelay = 0.12

_G.SafeHit = function()
    if tick() - lastHit < minDelay then
        return false 
    end
    lastHit = tick()
    return true
end

------------------------------------------------------------------------
-- 8) ANTI SKILL SPAM (Z/X/C/V)
------------------------------------------------------------------------
local lastSkill = {Z=0,X=0,C=0,V=0,F=0}
local skillDelay = 0.20

_G.SafeSkill = function(key)
    if tick() - lastSkill[key] < skillDelay then
        return false
    end
    lastSkill[key] = tick()
    return true
end

------------------------------------------------------------------------
-- 9) ANTI HITBOX DETECT
------------------------------------------------------------------------
local maxHitbox = 12

RunService.Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hrp and hrp.Size.X > maxHitbox then
        hrp.Size = Vector3.new(maxHitbox, maxHitbox, maxHitbox)
    end
end)

------------------------------------------------------------------------
-- 10) ANTI AIMBOT DETECT (camera snap quá nhanh)
------------------------------------------------------------------------
local lastLook = workspace.CurrentCamera.CFrame.LookVector
local maxCamSpeed = 13

RunService.Heartbeat:Connect(function()
    local cam = workspace.CurrentCamera
    local diff = (cam.CFrame.LookVector - lastLook).Magnitude

    if diff > maxCamSpeed then
        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + lastLook)
    end

    lastLook = cam.CFrame.LookVector
end)

------------------------------------------------------------------------
-- 11) ANTI SERVER POSITION CORRECTION
------------------------------------------------------------------------
local safePos = nil

RunService.Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if safePos and (hrp.Position - safePos).Magnitude > 55 then
        hrp.CFrame = CFrame.new(safePos)
    end

    safePos = hrp.Position
end)

------------------------------------------------------------------------
-- 12) SAFE TP TO MOB
------------------------------------------------------------------------
_G.SafeTPMob = function(mob)
    if mob and mob:FindFirstChild("HumanoidRootPart") then
        _G.SafeTP(mob.HumanoidRootPart.Position + Vector3.new(0,3,0))
    end
end

------------------------------------------------------------------------
-- 13) ANTI RESET / DESTROY CHARACTER
------------------------------------------------------------------------
pcall(function()
    lp.CharacterAdded:Connect(function(char)
        char.DescendantRemoving:Connect(function(d)
            if d:IsDescendantOf(char) then
                task.defer(function()
                    if d.Parent == nil then
                        d.Parent = char
                    end
                end)
            end
        end)
    end)
end)

------------------------------------------------------------------------
-- 14) AUTO REJOIN KHI PROMPT HIỆN
------------------------------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        local ui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
        if ui then
            task.wait(1)
            pcall(function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
            end)
        end
    end
end)

print("[FULL SHIELD v3 MERGED] All Systems Online (SAFE 97%)")
------------------------------------------------------------------------

local v17 = v14.Options;
local v18 = game.PlaceId;
if (v18 == 2753915549) then
    Sea1 = true;
elseif (v18 == 4442272183) then
    Sea2 = true;
elseif (v18 == 7449423635) then
    Sea3 = true;
else
    game:Shutdown();
end
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
    wait();
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
end);
Sea1 = false;
Sea2 = false;
Sea3 = false;
local v19 = game.PlaceId;
if (v19 == 2753915549) then
    Sea1 = true;
elseif (v19 == 4442272183) then
    Sea2 = true;
elseif (v19 == 7449423635) then
    Sea3 = true;
end
function CheckLevel()
    local v197 = game:GetService("Players").LocalPlayer.Data.Level.Value;
    if Sea1 then
        if ((v197 == 1) or (v197 <= 9) or (SelectMonster == "Bandit")) then
            Ms = "Bandit";
            NameQuest = "BanditQuest1";
            QuestLv = 1;
            NameMon = "Bandit";
            CFrameQ = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875);
            CFrameMon = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953);
        elseif ((v197 == 10) or (v197 <= 14) or (SelectMonster == "Monkey")) then
            Ms = "Monkey";
            NameQuest = "JungleQuest";
            QuestLv = 1;
            NameMon = "Monkey";
            CFrameQ = CFrame.new(- 1601.6553955078, 36.85213470459, 153.38809204102);
            CFrameMon = CFrame.new(- 1448.1446533203, 50.851993560791, 63.60718536377);
        elseif ((v197 == 15) or (v197 <= 29) or (SelectMonster == "Gorilla")) then
            Ms = "Gorilla";
            NameQuest = "JungleQuest";
            QuestLv = 2;
            NameMon = "Gorilla";
            CFrameQ = CFrame.new(- 1601.6553955078, 36.85213470459, 153.38809204102);
            CFrameMon = CFrame.new(- 1142.6488037109, 40.462348937988, - 515.39227294922);
        elseif ((v197 == 30) or (v197 <= 39) or (SelectMonster == "Pirate")) then
            Ms = "Pirate";
            NameQuest = "BuggyQuest1";
            QuestLv = 1;
            NameMon = "Pirate";
            CFrameQ = CFrame.new(- 1140.1761474609, 4.752049446106, 3827.4057617188);
            CFrameMon = CFrame.new(- 1201.0881347656, 40.628940582275, 3857.5966796875);
        elseif ((v197 == 40) or (v197 <= 59) or (SelectMonster == "Brute")) then
            Ms = "Brute";
            NameQuest = "BuggyQuest1";
            QuestLv = 2;
            NameMon = "Brute";
            CFrameQ = CFrame.new(- 1140.1761474609, 4.752049446106, 3827.4057617188);
            CFrameMon = CFrame.new(- 1387.5324707031, 24.592035293579, 4100.9575195313);
        elseif ((v197 == 60) or (v197 <= 74) or (SelectMonster == "Desert Bandit")) then
            Ms = "Desert Bandit";
            NameQuest = "DesertQuest";
            QuestLv = 1;
            NameMon = "Desert Bandit";
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625);
            CFrameMon = CFrame.new(984.99896240234, 16.109552383423, 4417.91015625);
        elseif ((v197 == 75) or (v197 <= 89) or (SelectMonster == "Desert Officer")) then
            Ms = "Desert Officer";
            NameQuest = "DesertQuest";
            QuestLv = 2;
            NameMon = "Desert Officer";
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625);
            CFrameMon = CFrame.new(1547.1510009766, 14.452038764954, 4381.8002929688);
        elseif ((v197 == 90) or (v197 <= 99) or (SelectMonster == "Snow Bandit")) then
            Ms = "Snow Bandit";
            NameQuest = "SnowQuest";
            QuestLv = 1;
            NameMon = "Snow Bandit";
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, - 1298.3576660156);
            CFrameMon = CFrame.new(1356.3028564453, 105.76865386963, - 1328.2418212891);
        elseif ((v197 == 100) or (v197 <= 119) or (SelectMonster == "Snowman")) then
            Ms = "Snowman";
            NameQuest = "SnowQuest";
            QuestLv = 2;
            NameMon = "Snowman";
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, - 1298.3576660156);
            CFrameMon = CFrame.new(1218.7956542969, 138.01184082031, - 1488.0262451172);
        elseif ((v197 == 120) or (v197 <= 149) or (SelectMonster == "Chief Petty Officer")) then
            Ms = "Chief Petty Officer";
            NameQuest = "MarineQuest2";
            QuestLv = 1;
            NameMon = "Chief Petty Officer";
            CFrameQ = CFrame.new(- 5035.49609375, 28.677835464478, 4324.1840820313);
            CFrameMon = CFrame.new(- 4931.1552734375, 65.793113708496, 4121.8393554688);
        elseif ((v197 == 150) or (v197 <= 174) or (SelectMonster == "Sky Bandit")) then
            Ms = "Sky Bandit";
            NameQuest = "SkyQuest";
            QuestLv = 1;
            NameMon = "Sky Bandit";
            CFrameQ = CFrame.new(- 4842.1372070313, 717.69543457031, - 2623.0483398438);
            CFrameMon = CFrame.new(- 4955.6411132813, 365.46365356445, - 2908.1865234375);
        elseif ((v197 == 175) or (v197 <= 189) or (SelectMonster == "Dark Master")) then
            Ms = "Dark Master";
            NameQuest = "SkyQuest";
            QuestLv = 2;
            NameMon = "Dark Master";
            CFrameQ = CFrame.new(- 4842.1372070313, 717.69543457031, - 2623.0483398438);
            CFrameMon = CFrame.new(- 5148.1650390625, 439.04571533203, - 2332.9611816406);
        elseif ((v197 == 190) or (v197 <= 209) or (SelectMonster == "Prisoner")) then
            Ms = "Prisoner";
            NameQuest = "PrisonerQuest";
            QuestLv = 1;
            NameMon = "Prisoner";
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, - 0.999846935, 0, 0.0175017118);
            CFrameMon = CFrame.new(4937.31885, 0.332031399, 649.574524, 0.694649816, 0, - 0.719348073, 0, 1, 0, 0.719348073, 0, 0.694649816);
        elseif ((v197 == 210) or (v197 <= 249) or (SelectMonster == "Dangerous Prisoner")) then
            Ms = "Dangerous Prisoner";
            NameQuest = "PrisonerQuest";
            QuestLv = 2;
            NameMon = "Dangerous Prisoner";
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, - 0.999846935, 0, 0.0175017118);
            CFrameMon = CFrame.new(5099.6626, 0.351562679, 1055.7583, 0.898906827, 0, - 0.438139856, 0, 1, 0, 0.438139856, 0, 0.898906827);
        elseif ((v197 == 250) or (v197 <= 274) or (SelectMonster == "Toga Warrior")) then
            Ms = "Toga Warrior";
            NameQuest = "ColosseumQuest";
            QuestLv = 1;
            NameMon = "Toga Warrior";
            CFrameQ = CFrame.new(- 1577.7890625, 7.4151420593262, - 2984.4838867188);
            CFrameMon = CFrame.new(- 1872.5166015625, 49.080215454102, - 2913.810546875);
        elseif ((v197 == 275) or (v197 <= 299) or (SelectMonster == "Gladiator")) then
            Ms = "Gladiator";
            NameQuest = "ColosseumQuest";
            QuestLv = 2;
            NameMon = "Gladiator";
            CFrameQ = CFrame.new(- 1577.7890625, 7.4151420593262, - 2984.4838867188);
            CFrameMon = CFrame.new(- 1521.3740234375, 81.203170776367, - 3066.3139648438);
        elseif ((v197 == 300) or (v197 <= 324) or (SelectMonster == "Military Soldier")) then
            Ms = "Military Soldier";
            NameQuest = "MagmaQuest";
            QuestLv = 1;
            NameMon = "Military Soldier";
            CFrameQ = CFrame.new(- 5316.1157226563, 12.262831687927, 8517.00390625);
            CFrameMon = CFrame.new(- 5369.0004882813, 61.24352645874, 8556.4921875);
        elseif ((v197 == 325) or (v197 <= 374) or (SelectMonster == "Military Spy")) then
            Ms = "Military Spy";
            NameQuest = "MagmaQuest";
            QuestLv = 2;
            NameMon = "Military Spy";
            CFrameQ = CFrame.new(- 5316.1157226563, 12.262831687927, 8517.00390625);
            CFrameMon = CFrame.new(- 5787.00293, 75.8262634, 8651.69922, 0.838590562, 0, - 0.544762194, 0, 1, 0, 0.544762194, 0, 0.838590562);
        elseif ((v197 == 375) or (v197 <= 399) or (SelectMonster == "Fishman Warrior")) then
            Ms = "Fishman Warrior";
            NameQuest = "FishmanQuest";
            QuestLv = 1;
            NameMon = "Fishman Warrior";
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
            CFrameMon = CFrame.new(60844.10546875, 98.462875366211, 1298.3985595703);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875));
            end
        elseif ((v197 == 400) or (v197 <= 449) or (SelectMonster == "Fishman Commando")) then
            Ms = "Fishman Commando";
            NameQuest = "FishmanQuest";
            QuestLv = 2;
            NameMon = "Fishman Commando";
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
            CFrameMon = CFrame.new(61738.3984375, 64.207321166992, 1433.8375244141);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875));
            end
        elseif ((v197 == 10) or (v197 <= 474) or (SelectMonster == "God's Guard")) then
            Ms = "God's Guard";
            NameQuest = "SkyExp1Quest";
            QuestLv = 1;
            NameMon = "God's Guard";
            CFrameQ = CFrame.new(- 4721.8603515625, 845.30297851563, - 1953.8489990234);
            CFrameMon = CFrame.new(- 4628.0498046875, 866.92877197266, - 1931.2352294922);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.82275, 872.54248, - 1667.55688));
            end
        elseif ((v197 == 475) or (v197 <= 524) or (SelectMonster == "Shanda")) then
            Ms = "Shanda";
            NameQuest = "SkyExp1Quest";
            QuestLv = 2;
            NameMon = "Shanda";
            CFrameQ = CFrame.new(- 7863.1596679688, 5545.5190429688, - 378.42266845703);
            CFrameMon = CFrame.new(- 7685.1474609375, 5601.0751953125, - 441.38876342773);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.6176757813, 5547.1416015625, - 380.29119873047));
            end
        elseif ((v197 == 525) or (v197 <= 549) or (SelectMonster == "Royal Squad")) then
            Ms = "Royal Squad";
            NameQuest = "SkyExp2Quest";
            QuestLv = 1;
            NameMon = "Royal Squad";
            CFrameQ = CFrame.new(- 7903.3828125, 5635.9897460938, - 1410.923828125);
            CFrameMon = CFrame.new(- 7654.2514648438, 5637.1079101563, - 1407.7550048828);
        elseif ((v197 == 550) or (v197 <= 624) or (SelectMonster == "Royal Soldier")) then
            Ms = "Royal Soldier";
            NameQuest = "SkyExp2Quest";
            QuestLv = 2;
            NameMon = "Royal Soldier";
            CFrameQ = CFrame.new(- 7903.3828125, 5635.9897460938, - 1410.923828125);
            CFrameMon = CFrame.new(- 7760.4106445313, 5679.9077148438, - 1884.8112792969);
        elseif ((v197 == 625) or (v197 <= 649) or (SelectMonster == "Galley Pirate")) then
            Ms = "Galley Pirate";
            NameQuest = "FountainQuest";
            QuestLv = 1;
            NameMon = "Galley Pirate";
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875);
            CFrameMon = CFrame.new(5557.1684570313, 152.32717895508, 3998.7758789063);
        elseif ((v197 >= 650) or (SelectMonster == "Galley Captain")) then
            Ms = "Galley Captain";
            NameQuest = "FountainQuest";
            QuestLv = 2;
            NameMon = "Galley Captain";
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875);
            CFrameMon = CFrame.new(5677.6772460938, 92.786109924316, 4966.6323242188);
        end
    end
    if Sea2 then
        if ((v197 == 700) or (v197 <= 724) or (SelectMonster == "Raider")) then
            Ms = "Raider";
            NameQuest = "Area1Quest";
            QuestLv = 1;
            NameMon = "Raider";
            CFrameQ = CFrame.new(- 427.72567749023, 72.99634552002, 1835.9426269531);
            CFrameMon = CFrame.new(68.874565124512, 93.635643005371, 2429.6752929688);
        elseif ((v197 == 725) or (v197 <= 774) or (SelectMonster == "Mercenary")) then
            Ms = "Mercenary";
            NameQuest = "Area1Quest";
            QuestLv = 2;
            NameMon = "Mercenary";
            CFrameQ = CFrame.new(- 427.72567749023, 72.99634552002, 1835.9426269531);
            CFrameMon = CFrame.new(- 864.85009765625, 122.47104644775, 1453.1505126953);
        elseif ((v197 == 775) or (v197 <= 799) or (SelectMonster == "Swan Pirate")) then
            Ms = "Swan Pirate";
            NameQuest = "Area2Quest";
            QuestLv = 1;
            NameMon = "Swan Pirate";
            CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125);
            CFrameMon = CFrame.new(1065.3669433594, 137.64012145996, 1324.3798828125);
        elseif ((v197 == 800) or (v197 <= 874) or (SelectMonster == "Factory Staff")) then
            Ms = "Factory Staff";
            NameQuest = "Area2Quest";
            QuestLv = 2;
            NameMon = "Factory Staff";
            CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125);
            CFrameMon = CFrame.new(533.22045898438, 128.46876525879, 355.62615966797);
        elseif ((v197 == 875) or (v197 <= 899) or (SelectMonster == "Marine Lieutenan")) then
            Ms = "Marine Lieutenant";
            NameQuest = "MarineQuest3";
            QuestLv = 1;
            NameMon = "Marine Lieutenant";
            CFrameQ = CFrame.new(- 2440.9934082031, 73.04190826416, - 3217.7082519531);
            CFrameMon = CFrame.new(- 2489.2622070313, 84.613594055176, - 3151.8830566406);
        elseif ((v197 == 900) or (v197 <= 949) or (SelectMonster == "Marine Captain")) then
            Ms = "Marine Captain";
            NameQuest = "MarineQuest3";
            QuestLv = 2;
            NameMon = "Marine Captain";
            CFrameQ = CFrame.new(- 2440.9934082031, 73.04190826416, - 3217.7082519531);
            CFrameMon = CFrame.new(- 2335.2026367188, 79.786659240723, - 3245.8674316406);
        elseif ((v197 == 950) or (v197 <= 974) or (SelectMonster == "Zombie")) then
            Ms = "Zombie";
            NameQuest = "ZombieQuest";
            QuestLv = 1;
            NameMon = "Zombie";
            CFrameQ = CFrame.new(- 5494.3413085938, 48.505931854248, - 794.59094238281);
            CFrameMon = CFrame.new(- 5536.4970703125, 101.08577728271, - 835.59075927734);
        elseif ((v197 == 975) or (v197 <= 999) or (SelectMonster == "Vampire")) then
            Ms = "Vampire";
            NameQuest = "ZombieQuest";
            QuestLv = 2;
            NameMon = "Vampire";
            CFrameQ = CFrame.new(- 5494.3413085938, 48.505931854248, - 794.59094238281);
            CFrameMon = CFrame.new(- 5806.1098632813, 16.722528457642, - 1164.4384765625);
        elseif ((v197 == 1000) or (v197 <= 1049) or (SelectMonster == "Snow Trooper")) then
            Ms = "Snow Trooper";
            NameQuest = "SnowMountainQuest";
            QuestLv = 1;
            NameMon = "Snow Trooper";
            CFrameQ = CFrame.new(607.05963134766, 401.44781494141, - 5370.5546875);
            CFrameMon = CFrame.new(535.21051025391, 432.74209594727, - 5484.9165039063);
        elseif ((v197 == 1050) or (v197 <= 1099) or (SelectMonster == "Winter Warrior")) then
            Ms = "Winter Warrior";
            NameQuest = "SnowMountainQuest";
            QuestLv = 2;
            NameMon = "Winter Warrior";
            CFrameQ = CFrame.new(607.05963134766, 401.44781494141, - 5370.5546875);
            CFrameMon = CFrame.new(1234.4449462891, 456.95419311523, - 5174.130859375);
        elseif ((v197 == 1100) or (v197 <= 1124) or (SelectMonster == "Lab Subordinate")) then
            Ms = "Lab Subordinate";
            NameQuest = "IceSideQuest";
            QuestLv = 1;
            NameMon = "Lab Subordinate";
            CFrameQ = CFrame.new(- 6061.841796875, 15.926671981812, - 4902.0385742188);
            CFrameMon = CFrame.new(- 5720.5576171875, 63.309471130371, - 4784.6103515625);
        elseif ((v197 == 1125) or (v197 <= 1174) or (SelectMonster == "Horned Warrior")) then
            Ms = "Horned Warrior";
            NameQuest = "IceSideQuest";
            QuestLv = 2;
            NameMon = "Horned Warrior";
            CFrameQ = CFrame.new(- 6061.841796875, 15.926671981812, - 4902.0385742188);
            CFrameMon = CFrame.new(- 6292.751953125, 91.181983947754, - 5502.6499023438);
        elseif ((v197 == 1175) or (v197 <= 1199) or (SelectMonster == "Magma Ninja")) then
            Ms = "Magma Ninja";
            NameQuest = "FireSideQuest";
            QuestLv = 1;
            NameMon = "Magma Ninja";
            CFrameQ = CFrame.new(- 5429.0473632813, 15.977565765381, - 5297.9614257813);
            CFrameMon = CFrame.new(- 5461.8388671875, 130.36347961426, - 5836.4702148438);
        elseif ((v197 == 1200) or (v197 <= 1249) or (SelectMonster == "Lava Pirate")) then
            Ms = "Lava Pirate";
            NameQuest = "FireSideQuest";
            QuestLv = 2;
            NameMon = "Lava Pirate";
            CFrameQ = CFrame.new(- 5429.0473632813, 15.977565765381, - 5297.9614257813);
            CFrameMon = CFrame.new(- 5251.1889648438, 55.164535522461, - 4774.4096679688);
        elseif ((v197 == 1250) or (v197 <= 1274) or (SelectMonster == "Ship Deckhand")) then
            Ms = "Ship Deckhand";
            NameQuest = "ShipQuest1";
            QuestLv = 1;
            NameMon = "Ship Deckhand";
            CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625);
            CFrameMon = CFrame.new(921.12365722656, 125.9839553833, 33088.328125);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
            end
        elseif ((v197 == 1275) or (v197 <= 1299) or (SelectMonster == "Ship Engineer")) then
            Ms = "Ship Engineer";
            NameQuest = "ShipQuest1";
            QuestLv = 2;
            NameMon = "Ship Engineer";
            CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625);
            CFrameMon = CFrame.new(886.28179931641, 40.47790145874, 32800.83203125);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
            end
        elseif ((v197 == 1300) or (v197 <= 1324) or (SelectMonster == "Ship Steward")) then
            Ms = "Ship Steward";
            NameQuest = "ShipQuest2";
            QuestLv = 1;
            NameMon = "Ship Steward";
            CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875);
            CFrameMon = CFrame.new(943.85504150391, 129.58183288574, 33444.3671875);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
            end
        elseif ((v197 == 1325) or (v197 <= 1349) or (SelectMonster == "Ship Officer")) then
            Ms = "Ship Officer";
            NameQuest = "ShipQuest2";
            QuestLv = 2;
            NameMon = "Ship Officer";
            CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875);
            CFrameMon = CFrame.new(955.38458251953, 181.08335876465, 33331.890625);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
            end
        elseif ((v197 == 1350) or (v197 <= 1374) or (SelectMonster == "Arctic Warrior")) then
            Ms = "Arctic Warrior";
            NameQuest = "FrostQuest";
            QuestLv = 1;
            NameMon = "Arctic Warrior";
            CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, - 6484.6005859375);
            CFrameMon = CFrame.new(5935.4541015625, 77.26016998291, - 6472.7568359375);
            if (_G.AutoLevel and ((CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000)) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 6508.5581054688, 89.034996032715, - 132.83953857422));
            end
        elseif ((v197 == 1375) or (v197 <= 1424) or (SelectMonster == "Snow Lurker")) then
            Ms = "Snow Lurker";
            NameQuest = "FrostQuest";
            QuestLv = 2;
            NameMon = "Snow Lurker";
            CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, - 6484.6005859375);
            CFrameMon = CFrame.new(5628.482421875, 57.574996948242, - 6618.3481445313);
        elseif ((v197 == 1425) or (v197 <= 1449) or (SelectMonster == "Sea Soldier")) then
            Ms = "Sea Soldier";
            NameQuest = "ForgottenQuest";
            QuestLv = 1;
            NameMon = "Sea Soldier";
            CFrameQ = CFrame.new(- 3054.5827636719, 236.87213134766, - 10147.790039063);
            CFrameMon = CFrame.new(- 3185.0153808594, 58.789089202881, - 9663.6064453125);
        elseif ((v197 >= 1450) or (SelectMonster == "Water Fighter")) then
            Ms = "Water Fighter";
            NameQuest = "ForgottenQuest";
            QuestLv = 2;
            NameMon = "Water Fighter";
            CFrameQ = CFrame.new(- 3054.5827636719, 236.87213134766, - 10147.790039063);
            CFrameMon = CFrame.new(- 3262.9301757813, 298.69036865234, - 10552.529296875);
        end
    end
    if Sea3 then
        if ((v197 == 1500) or (v197 <= 1524) or (SelectMonster == "Pirate Millionaire")) then
            Ms = "Pirate Millionaire";
            NameQuest = "PiratePortQuest";
            QuestLv = 1;
            NameMon = "Pirate Millionaire";
            CFrameQ = CFrame.new(- 450.1046447753906, 107.68145751953125, 5950.72607421875);
            CFrameMon = CFrame.new(- 193.99227905273438, 56.12502670288086, 5755.7880859375);
        elseif ((v197 == 1525) or (v197 <= 1574) or (SelectMonster == "Pistol Billionaire")) then
            Ms = "Pistol Billionaire";
            NameQuest = "PiratePortQuest";
            QuestLv = 2;
            NameMon = "Pistol Billionaire";
            CFrameQ = CFrame.new(- 450.1046447753906, 107.68145751953125, 5950.72607421875);
            CFrameMon = CFrame.new(- 188.14462280273438, 84.49613189697266, 6337.0419921875);
        elseif ((v197 == 1575) or (v197 <= 1599) or (SelectMonster == "Dragon Crew Warrior")) then
            Ms = "Dragon Crew Warrior";
            NameQuest = "DragonCrewQuest";
            QuestLv = 1;
            NameMon = "Dragon Crew Warrior";
            CFrameQ = CFrame.new(6735.11083984375, 126.99046325683594, - 711.0979614257812);
            CFrameMon = CFrame.new(6615.2333984375, 50.847679138183594, - 978.93408203125);
        elseif ((v197 == 1600) or (v197 <= 1624) or (SelectMonster == "Dragon Crew Archer")) then
            Ms = "Dragon Crew Archer";
            NameQuest = "DragonCrewQuest";
            QuestLv = 2;
            NameMon = "Dragon Crew Archer";
            CFrameQ = CFrame.new(6735.11083984375, 126.99046325683594, - 711.0979614257812);
            CFrameMon = CFrame.new(6818.58935546875, 483.718994140625, 512.726806640625);
        elseif ((v197 == 1625) or (v197 <= 1649) or (SelectMonster == "Hydra Enforcer")) then
            Ms = "Hydra Enforcer";
            NameQuest = "VenomCrewQuest";
            QuestLv = 1;
            NameMon = "Hydra Enforcer";
            CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422);
            CFrameMon = CFrame.new(4547.115234375, 1001.60205078125, 334.1954650878906);
        elseif ((v197 == 1650) or (v197 <= 1699) or (SelectMonster == "Venomous Assailant")) then
            Ms = "Venomous Assailant";
            NameQuest = "VenomCrewQuest";
            QuestLv = 2;
            NameMon = "Venomous Assailant";
            CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422);
            CFrameMon = CFrame.new(4637.88525390625, 1077.85595703125, 882.4183959960938);
        elseif ((v197 == 1700) or (v197 <= 1724) or (SelectMonster == "Marine Commodore")) then
            Ms = "Marine Commodore";
            NameQuest = "MarineTreeIsland";
            QuestLv = 1;
            NameMon = "Marine Commodore";
            CFrameQ = CFrame.new(2179.98828125, 28.731239318848, - 6740.0551757813);
            CFrameMon = CFrame.new(2198.0063476563, 128.71075439453, - 7109.5043945313);
        elseif ((v197 == 1725) or (v197 <= 1774) or (SelectMonster == "Marine Rear Admiral")) then
            Ms = "Marine Rear Admiral";
            NameQuest = "MarineTreeIsland";
            QuestLv = 2;
            NameMon = "Marine Rear Admiral";
            CFrameQ = CFrame.new(2179.98828125, 28.731239318848, - 6740.0551757813);
            CFrameMon = CFrame.new(3294.3142089844, 385.41125488281, - 7048.6342773438);
        elseif ((v197 == 1775) or (v197 <= 1799) or (SelectMonster == "Fishman Raider")) then
            Ms = "Fishman Raider";
            NameQuest = "DeepForestIsland3";
            QuestLv = 1;
            NameMon = "Fishman Raider";
            CFrameQ = CFrame.new(- 10582.759765625, 331.78845214844, - 8757.666015625);
            CFrameMon = CFrame.new(- 10553.268554688, 521.38439941406, - 8176.9458007813);
        elseif ((v197 == 1800) or (v197 <= 1824) or (SelectMonster == "Fishman Captain")) then
            Ms = "Fishman Captain";
            NameQuest = "DeepForestIsland3";
            QuestLv = 2;
            NameMon = "Fishman Captain";
            CFrameQ = CFrame.new(- 10583.099609375, 331.78845214844, - 8759.4638671875);
            CFrameMon = CFrame.new(- 10789.401367188, 427.18637084961, - 9131.4423828125);
        elseif ((v197 == 1825) or (v197 <= 1849) or (SelectMonster == "Forest Pirate")) then
            Ms = "Forest Pirate";
            NameQuest = "DeepForestIsland";
            QuestLv = 1;
            NameMon = "Forest Pirate";
            CFrameQ = CFrame.new(- 13232.662109375, 332.40396118164, - 7626.4819335938);
            CFrameMon = CFrame.new(- 13489.397460938, 400.30349731445, - 7770.251953125);
        elseif ((v197 == 1850) or (v197 <= 1899) or (SelectMonster == "Mythological Pirate")) then
            Ms = "Mythological Pirate";
            NameQuest = "DeepForestIsland";
            QuestLv = 2;
            NameMon = "Mythological Pirate";
            CFrameQ = CFrame.new(- 13232.662109375, 332.40396118164, - 7626.4819335938);
            CFrameMon = CFrame.new(- 13508.616210938, 582.46228027344, - 6985.3037109375);
        elseif ((v197 == 1900) or (v197 <= 1924) or (SelectMonster == "Jungle Pirate")) then
            Ms = "Jungle Pirate";
            NameQuest = "DeepForestIsland2";
            QuestLv = 1;
            NameMon = "Jungle Pirate";
            CFrameQ = CFrame.new(- 12682.096679688, 390.88653564453, - 9902.1240234375);
            CFrameMon = CFrame.new(- 12267.103515625, 459.75262451172, - 10277.200195313);
        elseif ((v197 == 1925) or (v197 <= 1974) or (SelectMonster == "Musketeer Pirate")) then
            Ms = "Musketeer Pirate";
            NameQuest = "DeepForestIsland2";
            QuestLv = 2;
            NameMon = "Musketeer Pirate";
            CFrameQ = CFrame.new(- 12682.096679688, 390.88653564453, - 9902.1240234375);
            CFrameMon = CFrame.new(- 13291.5078125, 520.47338867188, - 9904.638671875);
        elseif ((v197 == 1975) or (v197 <= 1999) or (SelectMonster == "Reborn Skeleton")) then
            Ms = "Reborn Skeleton";
            NameQuest = "HauntedQuest1";
            QuestLv = 1;
            NameMon = "Reborn Skeleton";
            CFrameQ = CFrame.new(- 9480.80762, 142.130661, 5566.37305, - 0.00655503059, 4.5295423e-8, - 0.999978542, 2.0492047e-8, 1, 4.5162068e-8, 0.999978542, - 2.0195568e-8, - 0.00655503059);
            CFrameMon = CFrame.new(- 8761.77148, 183.431747, 6168.33301, 0.978073597, - 0.000013950732, - 0.208259016, - 0.0000010807393, 1, - 0.00007206303, 0.208259016, 0.00007070804, 0.978073597);
        elseif ((v197 == 2000) or (v197 <= 2024) or (SelectMonster == "Living Zombie")) then
            Ms = "Living Zombie";
            NameQuest = "HauntedQuest1";
            QuestLv = 2;
            NameMon = "Living Zombie";
            CFrameQ = CFrame.new(- 9480.80762, 142.130661, 5566.37305, - 0.00655503059, 4.5295423e-8, - 0.999978542, 2.0492047e-8, 1, 4.5162068e-8, 0.999978542, - 2.0195568e-8, - 0.00655503059);
            CFrameMon = CFrame.new(- 10103.7529, 238.565979, 6179.75977, 0.999474227, 2.7754714e-8, 0.0324240364, - 2.5800633e-8, 1, - 6.068485e-8, - 0.0324240364, 5.981639e-8, 0.999474227);
        elseif ((v197 == 2025) or (v197 <= 2049) or (SelectMonster == "Demonic Soul")) then
            Ms = "Demonic Soul";
            NameQuest = "HauntedQuest2";
            QuestLv = 1;
            NameMon = "Demonic Soul";
            CFrameQ = CFrame.new(- 9516.9931640625, 178.00651550293, 6078.4653320313);
            CFrameMon = CFrame.new(- 9712.03125, 204.69589233398, 6193.322265625);
        elseif ((v197 == 2050) or (v197 <= 2074) or (SelectMonster == "Posessed Mummy")) then
            Ms = "Posessed Mummy";
            NameQuest = "HauntedQuest2";
            QuestLv = 2;
            NameMon = "Posessed Mummy";
            CFrameQ = CFrame.new(- 9516.9931640625, 178.00651550293, 6078.4653320313);
            CFrameMon = CFrame.new(- 9545.7763671875, 69.619895935059, 6339.5615234375);
        elseif ((v197 == 2075) or (v197 <= 2099) or (SelectMonster == "Peanut Scout")) then
            Ms = "Peanut Scout";
            NameQuest = "NutsIslandQuest";
            QuestLv = 1;
            NameMon = "Peanut Scout";
            CFrameQ = CFrame.new(- 2105.53198, 37.2495995, - 10195.5088, - 0.766061664, 0, - 0.642767608, 0, 1, 0, 0.642767608, 0, - 0.766061664);
            CFrameMon = CFrame.new(- 2150.587890625, 122.49767303467, - 10358.994140625);
        elseif ((v197 == 2100) or (v197 <= 2124) or (SelectMonster == "Peanut President")) then
            Ms = "Peanut President";
            NameQuest = "NutsIslandQuest";
            QuestLv = 2;
            NameMon = "Peanut President";
            CFrameQ = CFrame.new(- 2105.53198, 37.2495995, - 10195.5088, - 0.766061664, 0, - 0.642767608, 0, 1, 0, 0.642767608, 0, - 0.766061664);
            CFrameMon = CFrame.new(- 2150.587890625, 122.49767303467, - 10358.994140625);
        elseif ((v197 == 2125) or (v197 <= 2149) or (SelectMonster == "Ice Cream Chef")) then
            Ms = "Ice Cream Chef";
            NameQuest = "IceCreamIslandQuest";
            QuestLv = 1;
            NameMon = "Ice Cream Chef";
            CFrameQ = CFrame.new(- 819.376709, 64.9259796, - 10967.2832, - 0.766061664, 0, 0.642767608, 0, 1, 0, - 0.642767608, 0, - 0.766061664);
            CFrameMon = CFrame.new(- 789.941528, 209.382889, - 11009.9805, - 0.0703101531, "-0", - 0.997525156, "-0", 1.00000012, "-0", 0.997525275, 0, - 0.0703101456);
        elseif ((v197 == 2150) or (v197 <= 2199) or (SelectMonster == "Ice Cream Commander")) then
            Ms = "Ice Cream Commander";
            NameQuest = "IceCreamIslandQuest";
            QuestLv = 2;
            NameMon = "Ice Cream Commander";
            CFrameQ = CFrame.new(- 819.376709, 64.9259796, - 10967.2832, - 0.766061664, 0, 0.642767608, 0, 1, 0, - 0.642767608, 0, - 0.766061664);
            CFrameMon = CFrame.new(- 789.941528, 209.382889, - 11009.9805, - 0.0703101531, "-0", - 0.997525156, "-0", 1.00000012, "-0", 0.997525275, 0, - 0.0703101456);
        elseif ((v197 == 2200) or (v197 <= 2224) or (SelectMonster == "Cookie Crafter")) then
            Ms = "Cookie Crafter";
            NameQuest = "CakeQuest1";
            QuestLv = 1;
            NameMon = "Cookie Crafter";
            CFrameQ = CFrame.new(- 2022.29858, 36.9275894, - 12030.9766, - 0.961273909, 0, - 0.275594592, 0, 1, 0, 0.275594592, 0, - 0.961273909);
            CFrameMon = CFrame.new(- 2321.71216, 36.699482, - 12216.7871, - 0.780074954, 0, 0.625686109, 0, 1, 0, - 0.625686109, 0, - 0.780074954);
        elseif ((v197 == 2225) or (v197 <= 2249) or (SelectMonster == "Cake Guard")) then
            Ms = "Cake Guard";
            NameQuest = "CakeQuest1";
            QuestLv = 2;
            NameMon = "Cake Guard";
            CFrameQ = CFrame.new(- 2022.29858, 36.9275894, - 12030.9766, - 0.961273909, 0, - 0.275594592, 0, 1, 0, 0.275594592, 0, - 0.961273909);
            CFrameMon = CFrame.new(- 1418.11011, 36.6718941, - 12255.7324, 0.0677844882, 0, 0.997700036, 0, 1, 0, - 0.997700036, 0, 0.0677844882);
        elseif ((v197 == 2250) or (v197 <= 2274) or (SelectMonster == "Baking Staff")) then
            Ms = "Baking Staff";
            NameQuest = "CakeQuest2";
            QuestLv = 1;
            NameMon = "Baking Staff";
            CFrameQ = CFrame.new(- 1928.31763, 37.7296638, - 12840.626, 0.951068401, "-0", - 0.308980465, 0, 1, "-0", 0.308980465, 0, 0.951068401);
            CFrameMon = CFrame.new(- 1980.43848, 36.6716766, - 12983.8418, - 0.254443765, 0, - 0.967087567, 0, 1, 0, 0.967087567, 0, - 0.254443765);
        elseif ((v197 == 2275) or (v197 <= 2299) or (SelectMonster == "Head Baker")) then
            Ms = "Head Baker";
            NameQuest = "CakeQuest2";
            QuestLv = 2;
            NameMon = "Head Baker";
            CFrameQ = CFrame.new(- 1928.31763, 37.7296638, - 12840.626, 0.951068401, "-0", - 0.308980465, 0, 1, "-0", 0.308980465, 0, 0.951068401);
            CFrameMon = CFrame.new(- 2251.5791, 52.2714615, - 13033.3965, - 0.991971016, 0, - 0.126466095, 0, 1, 0, 0.126466095, 0, - 0.991971016);
        elseif ((v197 == 2300) or (v197 <= 2324) or (SelectMonster == "Cocoa Warrior")) then
            Ms = "Cocoa Warrior";
            NameQuest = "ChocQuest1";
            QuestLv = 1;
            NameMon = "Cocoa Warrior";
            CFrameQ = CFrame.new(231.75, 23.9003029, - 12200.292, - 1, 0, 0, 0, 1, 0, 0, 0, - 1);
            CFrameMon = CFrame.new(167.978516, 26.2254658, - 12238.874, - 0.939700961, 0, 0.341998369, 0, 1, 0, - 0.341998369, 0, - 0.939700961);
        elseif ((v197 == 2325) or (v197 <= 2349) or (SelectMonster == "Chocolate Bar Battler")) then
            Ms = "Chocolate Bar Battler";
            NameQuest = "ChocQuest1";
            QuestLv = 2;
            NameMon = "Chocolate Bar Battler";
            CFrameQ = CFrame.new(231.75, 23.9003029, - 12200.292, - 1, 0, 0, 0, 1, 0, 0, 0, - 1);
            CFrameMon = CFrame.new(701.312073, 25.5824986, - 12708.2148, - 0.342042685, 0, - 0.939684391, 0, 1, 0, 0.939684391, 0, - 0.342042685);
        elseif ((v197 == 2350) or (v197 <= 2374) or (SelectMonster == "Sweet Thief")) then
            Ms = "Sweet Thief";
            NameQuest = "ChocQuest2";
            QuestLv = 1;
            NameMon = "Sweet Thief";
            CFrameQ = CFrame.new(151.198242, 23.8907146, - 12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, - 0.906319618, 0, 0.422592998);
            CFrameMon = CFrame.new(- 140.258301, 25.5824986, - 12652.3115, 0.173624337, "-0", - 0.984811902, 0, 1, "-0", 0.984811902, 0, 0.173624337);
        elseif ((v197 == 2375) or (v197 <= 2400) or (SelectMonster == "Candy Rebel")) then
            Ms = "Candy Rebel";
            NameQuest = "ChocQuest2";
            QuestLv = 2;
            NameMon = "Candy Rebel";
            CFrameQ = CFrame.new(151.198242, 23.8907146, - 12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, - 0.906319618, 0, 0.422592998);
            CFrameMon = CFrame.new(47.9231453, 25.5824986, - 13029.2402, - 0.819156051, 0, - 0.573571265, 0, 1, 0, 0.573571265, 0, - 0.819156051);
        elseif ((v197 == 2400) or (v197 <= 2424) or (SelectMonster == "Candy Pirate")) then
            Ms = "Candy Pirate";
            NameQuest = "CandyQuest1";
            QuestLv = 1;
            NameMon = "Candy Pirate";
            CFrameQ = CFrame.new(- 1149.328, 13.5759039, - 14445.6143, - 0.156446099, 0, - 0.987686574, 0, 1, 0, 0.987686574, 0, - 0.156446099);
            CFrameMon = CFrame.new(- 1437.56348, 17.1481285, - 14385.6934, 0.173624337, "-0", - 0.984811902, 0, 1, "-0", 0.984811902, 0, 0.173624337);
        elseif ((v197 == 2425) or (v197 <= 2449) or (SelectMonster == "Snow Demon")) then
            Ms = "Snow Demon";
            NameQuest = "CandyQuest1";
            QuestLv = 2;
            NameMon = "Snow Demon";
            CFrameQ = CFrame.new(- 1149.328, 13.5759039, - 14445.6143, - 0.156446099, 0, - 0.987686574, 0, 1, 0, 0.987686574, 0, - 0.156446099);
            CFrameMon = CFrame.new(- 916.222656, 17.1481285, - 14638.8125, 0.866007268, 0, 0.500031412, 0, 1, 0, - 0.500031412, 0, 0.866007268);
        elseif ((v197 == 2450) or (v197 <= 2474) or (SelectMonster == "Isle Outlaw")) then
            Ms = "Isle Outlaw";
            NameQuest = "TikiQuest1";
            QuestLv = 1;
            NameMon = "Isle Outlaw";
            CFrameQ = CFrame.new(- 16549.890625, 55.68635559082031, - 179.91360473632812);
            CFrameMon = CFrame.new(- 16162.8193359375, 11.6863374710083, - 96.45481872558594);
        elseif ((v197 == 2475) or (v197 <= 2499) or (SelectMonster == "Island Boy")) then
            Ms = "Island Boy";
            NameQuest = "TikiQuest1";
            QuestLv = 2;
            NameMon = "Island Boy";
            CFrameQ = CFrame.new(- 16549.890625, 55.68635559082031, - 179.91360473632812);
            CFrameMon = CFrame.new(- 16357.3125, 20.632822036743164, 1005.64892578125);
        elseif ((v197 == 2500) or (v197 <= 2524) or (SelectMonster == "Sun-kissed Warrior")) then
            Ms = "Sun-kissed Warrior";
            NameQuest = "TikiQuest2";
            QuestLv = 1;
            NameMon = "Sun-kissed Warrior";
            CFrameQ = CFrame.new(- 16541.021484375, 54.77081298828125, 1051.461181640625);
            CFrameMon = CFrame.new(- 16357.3125, 20.632822036743164, 1005.64892578125);
        elseif ((v197 == 2525) or (v197 <= 2549) or (SelectMonster == "Isle Champion")) then
            Ms = "Isle Champion";
            NameQuest = "TikiQuest2";
            QuestLv = 2;
            NameMon = "Isle Champion";
            CFrameQ = CFrame.new(- 16541.021484375, 54.77081298828125, 1051.461181640625);
            CFrameMon = CFrame.new(- 16848.94140625, 21.68633460998535, 1041.4490966796875);
        elseif ((v197 == 2550) or (v197 <= 2574) or (SelectMonster == "Serpent Hunter")) then
            Ms = "Serpent Hunter";
            NameQuest = "TikiQuest3";
            QuestLv = 1;
            NameMon = "Serpent Hunter";
            CFrameQ = CFrame.new(- 16665.19140625, 104.59640502929688, 1579.6943359375);
            CFrameMon = CFrame.new(- 16621.4140625, 121.40631103515625, 1290.6881103515625);
        elseif ((v197 == 2575) or (v197 <= 2599) or (SelectMonster == "Skull Slayer") or (v197 == 2600)) then
            Ms = "Skull Slayer";
            NameQuest = "TikiQuest3";
            QuestLv = 2;
            NameMon = "Skull Slayer";
            CFrameQ = CFrame.new(- 16665.19140625, 104.59640502929688, 1579.6943359375);
            CFrameMon = CFrame.new(- 16811.5703125, 84.625244140625, 1542.235107421875);
        end
    end
end
if Sea1 then
    tableMon = {
        "Bandit",
        "Monkey",
        "Gorilla",
        "Pirate",
        "Brute",
        "Desert Bandit",
        "Desert Officer",
        "Snow Bandit",
        "Snowman",
        "Chief Petty Officer",
        "Sky Bandit",
        "Dark Master",
        "Prisoner",
        "Dangerous Prisoner",
        "Toga Warrior",
        "Gladiator",
        "Military Soldier",
        "Military Spy",
        "Fishman Warrior",
        "Fishman Commando",
        "God's Guard",
        "Shanda",
        "Royal Squad",
        "Royal Soldier",
        "Galley Pirate",
        "Galley Captain"
    };
elseif Sea2 then
    tableMon = {
        "Raider",
        "Mercenary",
        "Swan Pirate",
        "Factory Staff",
        "Marine Lieutenant",
        "Marine Captain",
        "Zombie",
        "Vampire",
        "Snow Trooper",
        "Winter Warrior",
        "Lab Subordinate",
        "Horned Warrior",
        "Magma Ninja",
        "Lava Pirate",
        "Ship Deckhand",
        "Ship Engineer",
        "Ship Steward",
        "Ship Officer",
        "Arctic Warrior",
        "Snow Lurker",
        "Sea Soldier",
        "Water Fighter"
    };
elseif Sea3 then
    tableMon = {
        "Pirate Millionaire",
        "Dragon Crew Warrior",
        "Dragon Crew Archer",
        "Hydra Enforcer",
        "Venomous Assailant",
        "Marine Commodore",
        "Marine Rear Admiral",
        "Fishman Raider",
        "Fishman Captain",
        "Forest Pirate",
        "Mythological Pirate",
        "Jungle Pirate",
        "Musketeer Pirate",
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Posessed Mummy",
        "Peanut Scout",
        "Peanut President",
        "Ice Cream Chef",
        "Ice Cream Commander",
        "Cookie Crafter",
        "Cake Guard",
        "Baking Staff",
        "Head Baker",
        "Cocoa Warrior",
        "Chocolate Bar Battler",
        "Sweet Thief",
        "Candy Rebel",
        "Candy Pirate",
        "Snow Demon",
        "Isle Outlaw",
        "Island Boy",
        "Sun-kissed Warrior",
        "Isle Champion",
        "Serpent Hunter",
        "Skull Slayer"
    };
end
if Sea1 then
    AreaList = {
        "Jungle",
        "Buggy",
        "Desert",
        "Snow",
        "Marine",
        "Sky",
        "Prison",
        "Colosseum",
        "Magma",
        "Fishman",
        "Sky Island",
        "Fountain"
    };
elseif Sea2 then
    AreaList = {
        "Area 1",
        "Area 2",
        "Zombie",
        "Marine",
        "Snow Mountain",
        "Ice fire",
        "Ship",
        "Frost",
        "Forgotten"
    };
elseif Sea3 then
    AreaList = {
        "Pirate Port",
        "Amazon",
        "Marine Tree",
        "Deep Forest",
        "Haunted Castle",
        "Nut Island",
        "Ice Cream Island",
        "Cake Island",
        "Choco Island",
        "Candy Island",
        "Tiki Outpost"
    };
end
function CheckBossQuest()
    if Sea1 then
        if (SelectBoss == "The Gorilla King") then
            BossMon = "The Gorilla King";
            NameBoss = "The Gorrila King";
            NameQuestBoss = "JungleQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$2,000\n7,000 Exp.";
            CFrameQBoss = CFrame.new(- 1601.6553955078, 36.85213470459, 153.38809204102);
            CFrameBoss = CFrame.new(- 1088.75977, 8.13463783, - 488.559906, - 0.707134247, 0, 0.707079291, 0, 1, 0, - 0.707079291, 0, - 0.707134247);
        elseif (SelectBoss == "Bobby") then
            BossMon = "Bobby";
            NameBoss = "Bobby";
            NameQuestBoss = "BuggyQuest1";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$8,000\n35,000 Exp.";
            CFrameQBoss = CFrame.new(- 1140.1761474609, 4.752049446106, 3827.4057617188);
            CFrameBoss = CFrame.new(- 1087.3760986328, 46.949409484863, 4040.1462402344);
        elseif (SelectBoss == "The Saw") then
            BossMon = "The Saw";
            NameBoss = "The Saw";
            CFrameBoss = CFrame.new(- 784.89715576172, 72.427383422852, 1603.5822753906);
        elseif (SelectBoss == "Yeti") then
            BossMon = "Yeti";
            NameBoss = "Yeti";
            NameQuestBoss = "SnowQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$10,000\n180,000 Exp.";
            CFrameQBoss = CFrame.new(1386.8073730469, 87.272789001465, - 1298.3576660156);
            CFrameBoss = CFrame.new(1218.7956542969, 138.01184082031, - 1488.0262451172);
        elseif (SelectBoss == "Mob Leader") then
            BossMon = "Mob Leader";
            NameBoss = "Mob Leader";
            CFrameBoss = CFrame.new(- 2844.7307128906, 7.4180502891541, 5356.6723632813);
        elseif (SelectBoss == "Vice Admiral") then
            BossMon = "Vice Admiral";
            NameBoss = "Vice Admiral";
            NameQuestBoss = "MarineQuest2";
            QuestLvBoss = 2;
            RewardBoss = "Reward:\n$10,000\n180,000 Exp.";
            CFrameQBoss = CFrame.new(- 5036.2465820313, 28.677835464478, 4324.56640625);
            CFrameBoss = CFrame.new(- 5006.5454101563, 88.032081604004, 4353.162109375);
        elseif (SelectBoss == "Saber Expert") then
            NameBoss = "Saber Expert";
            BossMon = "Saber Expert";
            CFrameBoss = CFrame.new(- 1458.89502, 29.8870335, - 50.633564);
        elseif (SelectBoss == "Warden") then
            BossMon = "Warden";
            NameBoss = "Warden";
            NameQuestBoss = "ImpelQuest";
            QuestLvBoss = 1;
            RewardBoss = "Reward:\n$6,000\n850,000 Exp.";
            CFrameBoss = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, - 0.000004499464, 0.975376427, - 0.000019541258, 1, 0.000009031621, - 0.975376427, - 0.000021051976, 0.220546961);
            CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, - 0.731384635, 0, 0.681965172, 0, 1, 0, - 0.681965172, 0, - 0.731384635);
        elseif (SelectBoss == "Chief Warden") then
            BossMon = "Chief Warden";
            NameBoss = "Chief Warden";
            NameQuestBoss = "ImpelQuest";
            QuestLvBoss = 2;
            RewardBoss = "Reward:\n$10,000\n1,000,000 Exp.";
            CFrameBoss = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, - 0.00062915677, 0.939684749, 0.00191645394, 0.999998152, - 0.000028042234, - 0.939682961, 0.00181045406, 0.342041939);
            CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, - 0.731384635, 0, 0.681965172, 0, 1, 0, - 0.681965172, 0, - 0.731384635);
        elseif (SelectBoss == "Swan") then
            BossMon = "Swan";
            NameBoss = "Swan";
            NameQuestBoss = "ImpelQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$15,000\n1,600,000 Exp.";
            CFrameBoss = CFrame.new(5325.09619, 7.03906584, 719.570679, - 0.309060812, 0, 0.951042235, 0, 1, 0, - 0.951042235, 0, - 0.309060812);
            CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, - 0.731384635, 0, 0.681965172, 0, 1, 0, - 0.681965172, 0, - 0.731384635);
        elseif (SelectBoss == "Magma Admiral") then
            BossMon = "Magma Admiral";
            NameBoss = "Magma Admiral";
            NameQuestBoss = "MagmaQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$15,000\n2,800,000 Exp.";
            CFrameQBoss = CFrame.new(- 5314.6220703125, 12.262420654297, 8517.279296875);
            CFrameBoss = CFrame.new(- 5765.8969726563, 82.92064666748, 8718.3046875);
        elseif (SelectBoss == "Fishman Lord") then
            BossMon = "Fishman Lord";
            NameBoss = "Fishman Lord";
            NameQuestBoss = "FishmanQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$15,000\n4,000,000 Exp.";
            CFrameQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
            CFrameBoss = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984);
        elseif (SelectBoss == "Wysper") then
            BossMon = "Wysper";
            NameBoss = "Wysper";
            NameQuestBoss = "SkyExp1Quest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$15,000\n4,800,000 Exp.";
            CFrameQBoss = CFrame.new(- 7861.947265625, 5545.517578125, - 379.85974121094);
            CFrameBoss = CFrame.new(- 7866.1333007813, 5576.4311523438, - 546.74816894531);
        elseif (SelectBoss == "Thunder God") then
            BossMon = "Thunder God";
            NameBoss = "Thunder God";
            NameQuestBoss = "SkyExp2Quest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$20,000\n5,800,000 Exp.";
            CFrameQBoss = CFrame.new(- 7903.3828125, 5635.9897460938, - 1410.923828125);
            CFrameBoss = CFrame.new(- 7994.984375, 5761.025390625, - 2088.6479492188);
        elseif (SelectBoss == "Cyborg") then
            BossMon = "Cyborg";
            NameBoss = "Cyborg";
            NameQuestBoss = "FountainQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$20,000\n7,500,000 Exp.";
            CFrameQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875);
            CFrameBoss = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813);
        elseif (SelectBoss == "Ice Admiral") then
            BossMon = "Ice Admiral";
            NameBoss = "Ice Admiral";
            CFrameBoss = CFrame.new(1266.08948, 26.1757946, - 1399.57678, - 0.573599219, 0, - 0.81913656, 0, 1, 0, 0.81913656, 0, - 0.573599219);
        elseif (SelectBoss == "Greybeard") then
            BossMon = "Greybeard";
            NameBoss = "Greybeard";
            CFrameBoss = CFrame.new(- 5081.3452148438, 85.221641540527, 4257.3588867188);
        end
    end
    if Sea2 then
        if (SelectBoss == "Diamond") then
            BossMon = "Diamond";
            NameBoss = "Diamond";
            NameQuestBoss = "Area1Quest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$25,000\n9,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 427.5666809082, 73.313781738281, 1835.4208984375);
            CFrameBoss = CFrame.new(- 1576.7166748047, 198.59265136719, 13.724286079407);
        elseif (SelectBoss == "Jeremy") then
            BossMon = "Jeremy";
            NameBoss = "Jeremy";
            NameQuestBoss = "Area2Quest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$25,000\n11,500,000 Exp.";
            CFrameQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063);
            CFrameBoss = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109);
        elseif (SelectBoss == "Fajita") then
            BossMon = "Fajita";
            NameBoss = "Fajita";
            NameQuestBoss = "MarineQuest3";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$25,000\n15,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 2441.986328125, 73.359344482422, - 3217.5324707031);
            CFrameBoss = CFrame.new(- 2172.7399902344, 103.32216644287, - 4015.025390625);
        elseif (SelectBoss == "Don Swan") then
            BossMon = "Don Swan";
            NameBoss = "Don Swan";
            CFrameBoss = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875);
        elseif (SelectBoss == "Smoke Admiral") then
            BossMon = "Smoke Admiral";
            NameBoss = "Smoke Admiral";
            NameQuestBoss = "IceSideQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$20,000\n25,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 5429.0473632813, 15.977565765381, - 5297.9614257813);
            CFrameBoss = CFrame.new(- 5275.1987304688, 20.757257461548, - 5260.6669921875);
        elseif (SelectBoss == "Awakened Ice Admiral") then
            BossMon = "Awakened Ice Admiral";
            NameBoss = "Awakened Ice Admiral";
            NameQuestBoss = "FrostQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$20,000\n36,000,000 Exp.";
            CFrameQBoss = CFrame.new(5668.9780273438, 28.519989013672, - 6483.3520507813);
            CFrameBoss = CFrame.new(6403.5439453125, 340.29766845703, - 6894.5595703125);
        elseif (SelectBoss == "Tide Keeper") then
            BossMon = "Tide Keeper";
            NameBoss = "Tide Keeper";
            NameQuestBoss = "ForgottenQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$12,500\n38,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 3053.9814453125, 237.18954467773, - 10145.0390625);
            CFrameBoss = CFrame.new(- 3795.6423339844, 105.88877105713, - 11421.307617188);
        elseif (SelectBoss == "Darkbeard") then
            BossMon = "Darkbeard";
            NameBoss = "Darkbeard";
            CFrameMon = CFrame.new(3677.08203125, 62.751937866211, - 3144.8332519531);
        elseif (SelectBoss == "Cursed Captain") then
            BossMon = "Cursed Captain";
            NameBoss = "Cursed Captain";
            CFrameBoss = CFrame.new(916.928589, 181.092773, 33422);
        elseif (SelectBoss == "Order") then
            BossMon = "Order";
            NameBoss = "Order";
            CFrameBoss = CFrame.new(- 6217.2021484375, 28.047645568848, - 5053.1357421875);
        end
    end
    if Sea3 then
        if (SelectBoss == "Stone") then
            BossMon = "Stone";
            NameBoss = "Stone";
            NameQuestBoss = "PiratePortQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$25,000\n40,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 289.76705932617, 43.819011688232, 5579.9384765625);
            CFrameBoss = CFrame.new(- 1027.6512451172, 92.404174804688, 6578.8530273438);
        elseif (SelectBoss == "Hydra Leader") then
            BossMon = "Hydra Leader";
            NameBoss = "Hydra Leader";
            NameQuestBoss = "VenomCrewQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$30,000\n52,000,000 Exp.";
            CFrameQBoss = CFrame.new(5445.9541015625, 601.62945556641, 751.43792724609);
            CFrameBoss = CFrame.new(5543.86328125, 668.97399902344, 199.0341796875);
        elseif (SelectBoss == "Kilo Admiral") then
            BossMon = "Kilo Admiral";
            NameBoss = "Kilo Admiral";
            NameQuestBoss = "MarineTreeIsland";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$35,000\n56,000,000 Exp.";
            CFrameQBoss = CFrame.new(2179.3010253906, 28.731239318848, - 6739.9741210938);
            CFrameBoss = CFrame.new(2764.2233886719, 432.46154785156, - 7144.4580078125);
        elseif (SelectBoss == "Captain Elephant") then
            BossMon = "Captain Elephant";
            NameBoss = "Captain Elephant";
            NameQuestBoss = "DeepForestIsland";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$40,000\n67,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 13232.682617188, 332.40396118164, - 7626.01171875);
            CFrameBoss = CFrame.new(- 13376.7578125, 433.28689575195, - 8071.392578125);
        elseif (SelectBoss == "Beautiful Pirate") then
            BossMon = "Beautiful Pirate";
            NameBoss = "Beautiful Pirate";
            NameQuestBoss = "DeepForestIsland2";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$50,000\n70,000,000 Exp.";
            CFrameQBoss = CFrame.new(- 12682.096679688, 390.88653564453, - 9902.1240234375);
            CFrameBoss = CFrame.new(5283.609375, 22.56223487854, - 110.78285217285);
        elseif (SelectBoss == "Cake Queen") then
            BossMon = "Cake Queen";
            NameBoss = "Cake Queen";
            NameQuestBoss = "IceCreamIslandQuest";
            QuestLvBoss = 3;
            RewardBoss = "Reward:\n$30,000\n112,500,000 Exp.";
            CFrameQBoss = CFrame.new(- 819.376709, 64.9259796, - 10967.2832, - 0.766061664, 0, 0.642767608, 0, 1, 0, - 0.642767608, 0, - 0.766061664);
            CFrameBoss = CFrame.new(- 678.648804, 381.353943, - 11114.2012, - 0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, - 0.417492568, 0.0167988986, - 0.90852499);
        elseif (SelectBoss == "Longma") then
            BossMon = "Longma";
            NameBoss = "Longma";
            CFrameBoss = CFrame.new(- 10238.875976563, 389.7912902832, - 9549.7939453125);
        elseif (SelectBoss == "Soul Reaper") then
            BossMon = "Soul Reaper";
            NameBoss = "Soul Reaper";
            CFrameBoss = CFrame.new(- 9524.7890625, 315.80429077148, 6655.7192382813);
        elseif (SelectBoss == "rip_indra True Form") then
            BossMon = "rip_indra True Form";
            NameBoss = "rip_indra True Form";
            CFrameBoss = CFrame.new(- 5415.3920898438, 505.74133300781, - 2814.0166015625);
        end
    end
end
function MaterialMon()
    if (SelectMaterial == "Radioactive Material") then
        MMon = "Factory Staff";
        MPos = CFrame.new(295, 73, - 56);
        SP = "Default";
    elseif (SelectMaterial == "Mystic Droplet") then
        MMon = "Water Fighter";
        MPos = CFrame.new(- 3385, 239, - 10542);
        SP = "Default";
    elseif (SelectMaterial == "Magma Ore") then
        if Sea1 then
            MMon = "Military Spy";
            MPos = CFrame.new(- 5815, 84, 8820);
            SP = "Default";
        elseif Sea2 then
            MMon = "Magma Ninja";
            MPos = CFrame.new(- 5428, 78, - 5959);
            SP = "Default";
        end
    elseif (SelectMaterial == "Angel Wings") then
        MMon = "God's Guard";
        MPos = CFrame.new(- 4698, 845, - 1912);
        SP = "Default";
        if ((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 7859.09814, 5544.19043, - 381.476196)).Magnitude >= 5000) then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7859.09814, 5544.19043, - 381.476196));
        end
    elseif (SelectMaterial == "Leather") then
        if Sea1 then
            MMon = "Brute";
            MPos = CFrame.new(- 1145, 15, 4350);
            SP = "Default";
        elseif Sea2 then
            MMon = "Marine Captain";
            MPos = CFrame.new(- 2010.5059814453125, 73.00115966796875, - 3326.620849609375);
            SP = "Default";
        elseif Sea3 then
            MMon = "Jungle Pirate";
            MPos = CFrame.new(- 11975.78515625, 331.7734069824219, - 10620.0302734375);
            SP = "Default";
        end
    elseif (SelectMaterial == "Scrap Metal") then
        if Sea1 then
            MMon = "Brute";
            MPos = CFrame.new(- 1145, 15, 4350);
            SP = "Default";
        elseif Sea2 then
            MMon = "Swan Pirate";
            MPos = CFrame.new(878, 122, 1235);
            SP = "Default";
        elseif Sea3 then
            MMon = "Jungle Pirate";
            MPos = CFrame.new(- 12107, 332, - 10549);
            SP = "Default";
        end
    elseif (SelectMaterial == "Fish Tail") then
        if Sea3 then
            MMon = "Fishman Raider";
            MPos = CFrame.new(- 10993, 332, - 8940);
            SP = "Default";
        elseif Sea1 then
            MMon = "Fishman Warrior";
            MPos = CFrame.new(61123, 19, 1569);
            SP = "Default";
            if ((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875)).Magnitude >= 17000) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875));
            end
        end
    elseif (SelectMaterial == "Demonic Wisp") then
        MMon = "Demonic Soul";
        MPos = CFrame.new(- 9507, 172, 6158);
        SP = "Default";
    elseif (SelectMaterial == "Vampire Fang") then
        MMon = "Vampire";
        MPos = CFrame.new(- 6033, 7, - 1317);
        SP = "Default";
    elseif (SelectMaterial == "Conjured Cocoa") then
        MMon = "Chocolate Bar Battler";
        MPos = CFrame.new(620.6344604492188, 78.93644714355469, - 12581.369140625);
        SP = "Default";
    elseif (SelectMaterial == "Dragon Scale") then
        MMon = "Dragon Crew Archer";
        MPos = CFrame.new(6827.91455078125, 609.4127197265625, 252.3538055419922);
        SP = "Default";
    elseif (SelectMaterial == "Gunpowder") then
        MMon = "Pistol Billionaire";
        MPos = CFrame.new(- 469, 74, 5904);
        SP = "Default";
    elseif (SelectMaterial == "Hydra Enforcer") then
        MMon = "Hydra Enforcer";
        MPos = CFrame.new(4581.517578125, 1001.55908203125, 704.9378662109375);
        SP = "Default";
    elseif (SelectMaterial == "Venomous Assailant") then
        MMon = "Venomous Assailant";
        MPos = CFrame.new(4879.92041015625, 1089.46142578125, 1104.00830078125);
        SP = "Default";
    elseif (SelectMaterial == "Mini Tusk") then
        MMon = "Mythological Pirate";
        MPos = CFrame.new();
        SP = "Default";
    end
end
function UpdateIslandESP()
    for v425, v426 in pairs(game:GetService("Workspace")['_WorldOrigin'].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then
                if (v426.Name ~= "Sea") then
                    if not v426:FindFirstChild("NameEsp") then
                        local v1130 = Instance.new("BillboardGui", v426);
                        v1130.Name = "NameEsp";
                        v1130.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1130.Size = UDim2.new(1, 200, 1, 30);
                        v1130.Adornee = v426;
                        v1130.AlwaysOnTop = true;
                        local v1136 = Instance.new("TextLabel", v1130);
                        v1136.Font = "GothamBold";
                        v1136.FontSize = "Size14";
                        v1136.TextWrapped = true;
                        v1136.Size = UDim2.new(1, 0, 1, 0);
                        v1136.TextYAlignment = "Top";
                        v1136.BackgroundTransparency = 1;
                        v1136.TextStrokeTransparency = 0.5;
                        v1136.TextColor3 = Color3.fromRGB(8, 0, 0);
                    else
                        v426['NameEsp'].TextLabel.Text = v426.Name .. "   \n" .. round((game:GetService("Players").LocalPlayer.Character.Head.Position - v426.Position).Magnitude / 3) .. " Distance" ;
                    end
                end
            elseif v426:FindFirstChild("NameEsp") then
                v426:FindFirstChild("NameEsp"):Destroy();
            end
        end);
    end
end
function isnil(v198)
    return v198 == nil ;
end
local function v20(v199)
    return math.floor(tonumber(v199) + 0.5);
end
Number = math.random(1, 1000000);
function UpdatePlayerChams()
    for v427, v428 in pairs(game:GetService("Players"):GetChildren()) do
        pcall(function()
            if not isnil(v428.Character) then
                if ESPPlayer then
                    if (not isnil(v428.Character.Head) and not v428.Character.Head:FindFirstChild("NameEsp" .. Number)) then
                        local v1146 = Instance.new("BillboardGui", v428.Character.Head);
                        v1146.Name = "NameEsp" .. Number ;
                        v1146.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1146.Size = UDim2.new(1, 200, 1, 30);
                        v1146.Adornee = v428.Character.Head;
                        v1146.AlwaysOnTop = true;
                        local v1153 = Instance.new("TextLabel", v1146);
                        v1153.Font = Enum.Font.GothamSemibold;
                        v1153.FontSize = "Size10";
                        v1153.TextWrapped = true;
                        v1153.Text = v428.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v428.Character.Head.Position).Magnitude / 3) .. " Distance" ;
                        v1153.Size = UDim2.new(1, 0, 1, 0);
                        v1153.TextYAlignment = "Top";
                        v1153.BackgroundTransparency = 1;
                        v1153.TextStrokeTransparency = 0.5;
                        if (v428.Team == game.Players.LocalPlayer.Team) then
                            v1153.TextColor3 = Color3.new(0, 0, 254);
                        else
                            v1153.TextColor3 = Color3.new(255, 0, 0);
                        end
                    else
                        v428.Character.Head["NameEsp" .. Number ].TextLabel.Text = v428.Name .. " | " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v428.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v20((v428.Character.Humanoid.Health * 100) / v428.Character.Humanoid.MaxHealth) .. "%" ;
                    end
                elseif v428.Character.Head:FindFirstChild("NameEsp" .. Number) then
                    v428.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy();
                end
            end
        end);
    end
end
function UpdateChestChams()
    for v429, v430 in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if string.find(v430.Name, "Chest") then
                if ChestESP then
                    if string.find(v430.Name, "Chest") then
                        if not v430:FindFirstChild("NameEsp" .. Number) then
                            local v1475 = Instance.new("BillboardGui", v430);
                            v1475.Name = "NameEsp" .. Number ;
                            v1475.ExtentsOffset = Vector3.new(0, 1, 0);
                            v1475.Size = UDim2.new(1, 200, 1, 30);
                            v1475.Adornee = v430;
                            v1475.AlwaysOnTop = true;
                            local v1481 = Instance.new("TextLabel", v1475);
                            v1481.Font = Enum.Font.GothamSemibold;
                            v1481.FontSize = "Size14";
                            v1481.TextWrapped = true;
                            v1481.Size = UDim2.new(1, 0, 1, 0);
                            v1481.TextYAlignment = "Top";
                            v1481.BackgroundTransparency = 1;
                            v1481.TextStrokeTransparency = 0.5;
                            if (v430.Name == "Chest1") then
                                v1481.TextColor3 = Color3.fromRGB(109, 109, 109);
                                v1481.Text = "Chest 1" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v430.Position).Magnitude / 3) .. " Distance" ;
                            end
                            if (v430.Name == "Chest2") then
                                v1481.TextColor3 = Color3.fromRGB(173, 158, 21);
                                v1481.Text = "Chest 2" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v430.Position).Magnitude / 3) .. " Distance" ;
                            end
                            if (v430.Name == "Chest3") then
                                v1481.TextColor3 = Color3.fromRGB(85, 255, 255);
                                v1481.Text = "Chest 3" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v430.Position).Magnitude / 3) .. " Distance" ;
                            end
                        else
                            v430["NameEsp" .. Number ].TextLabel.Text = v430.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v430.Position).Magnitude / 3) .. " Distance" ;
                        end
                    end
                elseif v430:FindFirstChild("NameEsp" .. Number) then
                    v430:FindFirstChild("NameEsp" .. Number):Destroy();
                end
            end
        end);
    end
end
function UpdateDevilChams()
    for v431, v432 in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if DevilFruitESP then
                if string.find(v432.Name, "Fruit") then
                    if not v432.Handle:FindFirstChild("NameEsp" .. Number) then
                        local v1164 = Instance.new("BillboardGui", v432.Handle);
                        v1164.Name = "NameEsp" .. Number ;
                        v1164.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1164.Size = UDim2.new(1, 200, 1, 30);
                        v1164.Adornee = v432.Handle;
                        v1164.AlwaysOnTop = true;
                        local v1171 = Instance.new("TextLabel", v1164);
                        v1171.Font = Enum.Font.GothamSemibold;
                        v1171.FontSize = "Size14";
                        v1171.TextWrapped = true;
                        v1171.Size = UDim2.new(1, 0, 1, 0);
                        v1171.TextYAlignment = "Top";
                        v1171.BackgroundTransparency = 1;
                        v1171.TextStrokeTransparency = 0.5;
                        v1171.TextColor3 = Color3.fromRGB(255, 255, 255);
                        v1171.Text = v432.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v432.Handle.Position).Magnitude / 3) .. " Distance" ;
                    else
                        v432.Handle["NameEsp" .. Number ].TextLabel.Text = v432.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v432.Handle.Position).Magnitude / 3) .. " Distance" ;
                    end
                end
            elseif v432.Handle:FindFirstChild("NameEsp" .. Number) then
                v432.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end);
    end
end
function UpdateFlowerChams()
    for v433, v434 in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if ((v434.Name == "Flower2") or (v434.Name == "Flower1")) then
                if FlowerESP then
                    if not v434:FindFirstChild("NameEsp" .. Number) then
                        local v1183 = Instance.new("BillboardGui", v434);
                        v1183.Name = "NameEsp" .. Number ;
                        v1183.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1183.Size = UDim2.new(1, 200, 1, 30);
                        v1183.Adornee = v434;
                        v1183.AlwaysOnTop = true;
                        local v1189 = Instance.new("TextLabel", v1183);
                        v1189.Font = Enum.Font.GothamSemibold;
                        v1189.FontSize = "Size14";
                        v1189.TextWrapped = true;
                        v1189.Size = UDim2.new(1, 0, 1, 0);
                        v1189.TextYAlignment = "Top";
                        v1189.BackgroundTransparency = 1;
                        v1189.TextStrokeTransparency = 0.5;
                        v1189.TextColor3 = Color3.fromRGB(255, 0, 0);
                        if (v434.Name == "Flower1") then
                            v1189.Text = "Blue Flower" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v434.Position).Magnitude / 3) .. " Distance" ;
                            v1189.TextColor3 = Color3.fromRGB(0, 0, 255);
                        end
                        if (v434.Name == "Flower2") then
                            v1189.Text = "Red Flower" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v434.Position).Magnitude / 3) .. " Distance" ;
                            v1189.TextColor3 = Color3.fromRGB(255, 0, 0);
                        end
                    else
                        v434["NameEsp" .. Number ].TextLabel.Text = v434.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v434.Position).Magnitude / 3) .. " Distance" ;
                    end
                elseif v434:FindFirstChild("NameEsp" .. Number) then
                    v434:FindFirstChild("NameEsp" .. Number):Destroy();
                end
            end
        end);
    end
end
function UpdateRealFruitChams()
    for v435, v436 in pairs(game.Workspace.AppleSpawner:GetChildren()) do
        if v436:IsA("Tool") then
            if RealFruitESP then
                if not v436.Handle:FindFirstChild("NameEsp" .. Number) then
                    local v907 = Instance.new("BillboardGui", v436.Handle);
                    v907.Name = "NameEsp" .. Number ;
                    v907.ExtentsOffset = Vector3.new(0, 1, 0);
                    v907.Size = UDim2.new(1, 200, 1, 30);
                    v907.Adornee = v436.Handle;
                    v907.AlwaysOnTop = true;
                    local v914 = Instance.new("TextLabel", v907);
                    v914.Font = Enum.Font.GothamSemibold;
                    v914.FontSize = "Size14";
                    v914.TextWrapped = true;
                    v914.Size = UDim2.new(1, 0, 1, 0);
                    v914.TextYAlignment = "Top";
                    v914.BackgroundTransparency = 1;
                    v914.TextStrokeTransparency = 0.5;
                    v914.TextColor3 = Color3.fromRGB(255, 0, 0);
                    v914.Text = v436.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v436.Handle.Position).Magnitude / 3) .. " Distance" ;
                else
                    v436.Handle["NameEsp" .. Number ].TextLabel.Text = v436.Name .. " " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v436.Handle.Position).Magnitude / 3) .. " Distance" ;
                end
            elseif v436.Handle:FindFirstChild("NameEsp" .. Number) then
                v436.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end
    end
    for v437, v438 in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
        if v438:IsA("Tool") then
            if RealFruitESP then
                if not v438.Handle:FindFirstChild("NameEsp" .. Number) then
                    local v926 = Instance.new("BillboardGui", v438.Handle);
                    v926.Name = "NameEsp" .. Number ;
                    v926.ExtentsOffset = Vector3.new(0, 1, 0);
                    v926.Size = UDim2.new(1, 200, 1, 30);
                    v926.Adornee = v438.Handle;
                    v926.AlwaysOnTop = true;
                    local v933 = Instance.new("TextLabel", v926);
                    v933.Font = Enum.Font.GothamSemibold;
                    v933.FontSize = "Size14";
                    v933.TextWrapped = true;
                    v933.Size = UDim2.new(1, 0, 1, 0);
                    v933.TextYAlignment = "Top";
                    v933.BackgroundTransparency = 1;
                    v933.TextStrokeTransparency = 0.5;
                    v933.TextColor3 = Color3.fromRGB(255, 174, 0);
                    v933.Text = v438.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v438.Handle.Position).Magnitude / 3) .. " Distance" ;
                else
                    v438.Handle["NameEsp" .. Number ].TextLabel.Text = v438.Name .. " " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v438.Handle.Position).Magnitude / 3) .. " Distance" ;
                end
            elseif v438.Handle:FindFirstChild("NameEsp" .. Number) then
                v438.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end
    end
    for v439, v440 in pairs(game.Workspace.BananaSpawner:GetChildren()) do
        if v440:IsA("Tool") then
            if RealFruitESP then
                if not v440.Handle:FindFirstChild("NameEsp" .. Number) then
                    local v945 = Instance.new("BillboardGui", v440.Handle);
                    v945.Name = "NameEsp" .. Number ;
                    v945.ExtentsOffset = Vector3.new(0, 1, 0);
                    v945.Size = UDim2.new(1, 200, 1, 30);
                    v945.Adornee = v440.Handle;
                    v945.AlwaysOnTop = true;
                    local v952 = Instance.new("TextLabel", v945);
                    v952.Font = Enum.Font.GothamSemibold;
                    v952.FontSize = "Size14";
                    v952.TextWrapped = true;
                    v952.Size = UDim2.new(1, 0, 1, 0);
                    v952.TextYAlignment = "Top";
                    v952.BackgroundTransparency = 1;
                    v952.TextStrokeTransparency = 0.5;
                    v952.TextColor3 = Color3.fromRGB(251, 255, 0);
                    v952.Text = v440.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v440.Handle.Position).Magnitude / 3) .. " Distance" ;
                else
                    v440.Handle["NameEsp" .. Number ].TextLabel.Text = v440.Name .. " " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v440.Handle.Position).Magnitude / 3) .. " Distance" ;
                end
            elseif v440.Handle:FindFirstChild("NameEsp" .. Number) then
                v440.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end
    end
end
function UpdateIslandESP()
    for v441, v442 in pairs(game:GetService("Workspace")['_WorldOrigin'].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then
                if (v442.Name ~= "Sea") then
                    if not v442:FindFirstChild("NameEsp") then
                        local v1200 = Instance.new("BillboardGui", v442);
                        v1200.Name = "NameEsp";
                        v1200.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1200.Size = UDim2.new(1, 200, 1, 30);
                        v1200.Adornee = v442;
                        v1200.AlwaysOnTop = true;
                        local v1206 = Instance.new("TextLabel", v1200);
                        v1206.Font = "GothamBold";
                        v1206.FontSize = "Size14";
                        v1206.TextWrapped = true;
                        v1206.Size = UDim2.new(1, 0, 1, 0);
                        v1206.TextYAlignment = "Top";
                        v1206.BackgroundTransparency = 1;
                        v1206.TextStrokeTransparency = 0.5;
                        v1206.TextColor3 = Color3.fromRGB(7, 236, 240);
                    else
                        v442['NameEsp'].TextLabel.Text = v442.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v442.Position).Magnitude / 3) .. " Distance" ;
                    end
                end
            elseif v442:FindFirstChild("NameEsp") then
                v442:FindFirstChild("NameEsp"):Destroy();
            end
        end);
    end
end
function isnil(v200)
    return v200 == nil ;
end
local function v20(v201)
    return math.floor(tonumber(v201) + 0.5);
end
Number = math.random(1, 1000000);
function UpdatePlayerChams()
    for v443, v444 in pairs(game:GetService("Players"):GetChildren()) do
        pcall(function()
            if not isnil(v444.Character) then
                if ESPPlayer then
                    if (not isnil(v444.Character.Head) and not v444.Character.Head:FindFirstChild("NameEsp" .. Number)) then
                        local v1216 = Instance.new("BillboardGui", v444.Character.Head);
                        v1216.Name = "NameEsp" .. Number ;
                        v1216.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1216.Size = UDim2.new(1, 200, 1, 30);
                        v1216.Adornee = v444.Character.Head;
                        v1216.AlwaysOnTop = true;
                        local v1223 = Instance.new("TextLabel", v1216);
                        v1223.Font = Enum.Font.GothamSemibold;
                        v1223.FontSize = "Size14";
                        v1223.TextWrapped = true;
                        v1223.Text = v444.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v444.Character.Head.Position).Magnitude / 3) .. " Distance" ;
                        v1223.Size = UDim2.new(1, 0, 1, 0);
                        v1223.TextYAlignment = "Top";
                        v1223.BackgroundTransparency = 1;
                        v1223.TextStrokeTransparency = 0.5;
                        if (v444.Team == game.Players.LocalPlayer.Team) then
                            v1223.TextColor3 = Color3.new(0, 255, 0);
                        else
                            v1223.TextColor3 = Color3.new(255, 0, 0);
                        end
                    else
                        v444.Character.Head["NameEsp" .. Number ].TextLabel.Text = v444.Name .. " | " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v444.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v20((v444.Character.Humanoid.Health * 100) / v444.Character.Humanoid.MaxHealth) .. "%" ;
                    end
                elseif v444.Character.Head:FindFirstChild("NameEsp" .. Number) then
                    v444.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy();
                end
            end
        end);
    end
end
function UpdateChestChams()
    for v445, v446 in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if string.find(v446.Name, "Chest") then
                if ChestESP then
                    if string.find(v446.Name, "Chest") then
                        if not v446:FindFirstChild("NameEsp" .. Number) then
                            local v1497 = Instance.new("BillboardGui", v446);
                            v1497.Name = "NameEsp" .. Number ;
                            v1497.ExtentsOffset = Vector3.new(0, 1, 0);
                            v1497.Size = UDim2.new(1, 200, 1, 30);
                            v1497.Adornee = v446;
                            v1497.AlwaysOnTop = true;
                            local v1503 = Instance.new("TextLabel", v1497);
                            v1503.Font = Enum.Font.GothamSemibold;
                            v1503.FontSize = "Size14";
                            v1503.TextWrapped = true;
                            v1503.Size = UDim2.new(1, 0, 1, 0);
                            v1503.TextYAlignment = "Top";
                            v1503.BackgroundTransparency = 1;
                            v1503.TextStrokeTransparency = 0.5;
                            if (v446.Name == "Chest1") then
                                v1503.TextColor3 = Color3.fromRGB(109, 109, 109);
                                v1503.Text = "Chest 1" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v446.Position).Magnitude / 3) .. " Distance" ;
                            end
                            if (v446.Name == "Chest2") then
                                v1503.TextColor3 = Color3.fromRGB(173, 158, 21);
                                v1503.Text = "Chest 2" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v446.Position).Magnitude / 3) .. " Distance" ;
                            end
                            if (v446.Name == "Chest3") then
                                v1503.TextColor3 = Color3.fromRGB(85, 255, 255);
                                v1503.Text = "Chest 3" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v446.Position).Magnitude / 3) .. " Distance" ;
                            end
                        else
                            v446["NameEsp" .. Number ].TextLabel.Text = v446.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v446.Position).Magnitude / 3) .. " Distance" ;
                        end
                    end
                elseif v446:FindFirstChild("NameEsp" .. Number) then
                    v446:FindFirstChild("NameEsp" .. Number):Destroy();
                end
            end
        end);
    end
end
function UpdateDevilChams()
    for v447, v448 in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if DevilFruitESP then
                if string.find(v448.Name, "Fruit") then
                    if not v448.Handle:FindFirstChild("NameEsp" .. Number) then
                        local v1234 = Instance.new("BillboardGui", v448.Handle);
                        v1234.Name = "NameEsp" .. Number ;
                        v1234.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1234.Size = UDim2.new(1, 200, 1, 30);
                        v1234.Adornee = v448.Handle;
                        v1234.AlwaysOnTop = true;
                        local v1241 = Instance.new("TextLabel", v1234);
                        v1241.Font = Enum.Font.GothamSemibold;
                        v1241.FontSize = "Size14";
                        v1241.TextWrapped = true;
                        v1241.Size = UDim2.new(1, 0, 1, 0);
                        v1241.TextYAlignment = "Top";
                        v1241.BackgroundTransparency = 1;
                        v1241.TextStrokeTransparency = 0.5;
                        v1241.TextColor3 = Color3.fromRGB(255, 255, 255);
                        v1241.Text = v448.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v448.Handle.Position).Magnitude / 3) .. " Distance" ;
                    else
                        v448.Handle["NameEsp" .. Number ].TextLabel.Text = v448.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v448.Handle.Position).Magnitude / 3) .. " Distance" ;
                    end
                end
            elseif v448.Handle:FindFirstChild("NameEsp" .. Number) then
                v448.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end);
    end
end
function UpdateFlowerChams()
    for v449, v450 in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if ((v450.Name == "Flower2") or (v450.Name == "Flower1")) then
                if FlowerESP then
                    if not v450:FindFirstChild("NameEsp" .. Number) then
                        local v1253 = Instance.new("BillboardGui", v450);
                        v1253.Name = "NameEsp" .. Number ;
                        v1253.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1253.Size = UDim2.new(1, 200, 1, 30);
                        v1253.Adornee = v450;
                        v1253.AlwaysOnTop = true;
                        local v1259 = Instance.new("TextLabel", v1253);
                        v1259.Font = Enum.Font.GothamSemibold;
                        v1259.FontSize = "Size14";
                        v1259.TextWrapped = true;
                        v1259.Size = UDim2.new(1, 0, 1, 0);
                        v1259.TextYAlignment = "Top";
                        v1259.BackgroundTransparency = 1;
                        v1259.TextStrokeTransparency = 0.5;
                        v1259.TextColor3 = Color3.fromRGB(255, 0, 0);
                        if (v450.Name == "Flower1") then
                            v1259.Text = "Blue Flower" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v450.Position).Magnitude / 3) .. " Distance" ;
                            v1259.TextColor3 = Color3.fromRGB(0, 0, 255);
                        end
                        if (v450.Name == "Flower2") then
                            v1259.Text = "Red Flower" .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v450.Position).Magnitude / 3) .. " Distance" ;
                            v1259.TextColor3 = Color3.fromRGB(255, 0, 0);
                        end
                    else
                        v450["NameEsp" .. Number ].TextLabel.Text = v450.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v450.Position).Magnitude / 3) .. " Distance" ;
                    end
                elseif v450:FindFirstChild("NameEsp" .. Number) then
                    v450:FindFirstChild("NameEsp" .. Number):Destroy();
                end
            end
        end);
    end
end
function UpdateRealFruitChams()
    for v451, v452 in pairs(game.Workspace.AppleSpawner:GetChildren()) do
        if v452:IsA("Tool") then
            if RealFruitESP then
                if not v452.Handle:FindFirstChild("NameEsp" .. Number) then
                    local v964 = Instance.new("BillboardGui", v452.Handle);
                    v964.Name = "NameEsp" .. Number ;
                    v964.ExtentsOffset = Vector3.new(0, 1, 0);
                    v964.Size = UDim2.new(1, 200, 1, 30);
                    v964.Adornee = v452.Handle;
                    v964.AlwaysOnTop = true;
                    local v971 = Instance.new("TextLabel", v964);
                    v971.Font = Enum.Font.GothamSemibold;
                    v971.FontSize = "Size14";
                    v971.TextWrapped = true;
                    v971.Size = UDim2.new(1, 0, 1, 0);
                    v971.TextYAlignment = "Top";
                    v971.BackgroundTransparency = 1;
                    v971.TextStrokeTransparency = 0.5;
                    v971.TextColor3 = Color3.fromRGB(255, 0, 0);
                    v971.Text = v452.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v452.Handle.Position).Magnitude / 3) .. " Distance" ;
                else
                    v452.Handle["NameEsp" .. Number ].TextLabel.Text = v452.Name .. " " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v452.Handle.Position).Magnitude / 3) .. " Distance" ;
                end
            elseif v452.Handle:FindFirstChild("NameEsp" .. Number) then
                v452.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end
    end
    for v453, v454 in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
        if v454:IsA("Tool") then
            if RealFruitESP then
                if not v454.Handle:FindFirstChild("NameEsp" .. Number) then
                    local v983 = Instance.new("BillboardGui", v454.Handle);
                    v983.Name = "NameEsp" .. Number ;
                    v983.ExtentsOffset = Vector3.new(0, 1, 0);
                    v983.Size = UDim2.new(1, 200, 1, 30);
                    v983.Adornee = v454.Handle;
                    v983.AlwaysOnTop = true;
                    local v990 = Instance.new("TextLabel", v983);
                    v990.Font = Enum.Font.GothamSemibold;
                    v990.FontSize = "Size14";
                    v990.TextWrapped = true;
                    v990.Size = UDim2.new(1, 0, 1, 0);
                    v990.TextYAlignment = "Top";
                    v990.BackgroundTransparency = 1;
                    v990.TextStrokeTransparency = 0.5;
                    v990.TextColor3 = Color3.fromRGB(255, 174, 0);
                    v990.Text = v454.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v454.Handle.Position).Magnitude / 3) .. " Distance" ;
                else
                    v454.Handle["NameEsp" .. Number ].TextLabel.Text = v454.Name .. " " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v454.Handle.Position).Magnitude / 3) .. " Distance" ;
                end
            elseif v454.Handle:FindFirstChild("NameEsp" .. Number) then
                v454.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end
    end
    for v455, v456 in pairs(game.Workspace.BananaSpawner:GetChildren()) do
        if v456:IsA("Tool") then
            if RealFruitESP then
                if not v456.Handle:FindFirstChild("NameEsp" .. Number) then
                    local v1002 = Instance.new("BillboardGui", v456.Handle);
                    v1002.Name = "NameEsp" .. Number ;
                    v1002.ExtentsOffset = Vector3.new(0, 1, 0);
                    v1002.Size = UDim2.new(1, 200, 1, 30);
                    v1002.Adornee = v456.Handle;
                    v1002.AlwaysOnTop = true;
                    local v1009 = Instance.new("TextLabel", v1002);
                    v1009.Font = Enum.Font.GothamSemibold;
                    v1009.FontSize = "Size14";
                    v1009.TextWrapped = true;
                    v1009.Size = UDim2.new(1, 0, 1, 0);
                    v1009.TextYAlignment = "Top";
                    v1009.BackgroundTransparency = 1;
                    v1009.TextStrokeTransparency = 0.5;
                    v1009.TextColor3 = Color3.fromRGB(251, 255, 0);
                    v1009.Text = v456.Name .. " \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v456.Handle.Position).Magnitude / 3) .. " Distance" ;
                else
                    v456.Handle["NameEsp" .. Number ].TextLabel.Text = v456.Name .. " " .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v456.Handle.Position).Magnitude / 3) .. " Distance" ;
                end
            elseif v456.Handle:FindFirstChild("NameEsp" .. Number) then
                v456.Handle:FindFirstChild("NameEsp" .. Number):Destroy();
            end
        end
    end
end
spawn(function()
    while wait() do
        pcall(function()
            if MobESP then
                for v822, v823 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v823:FindFirstChild("HumanoidRootPart") then
                        if not v823:FindFirstChild("MobEap") then
                            local v1372 = Instance.new("BillboardGui");
                            local v1373 = Instance.new("TextLabel");
                            v1372.Parent = v823;
                            v1372.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                            v1372.Active = true;
                            v1372.Name = "MobEap";
                            v1372.AlwaysOnTop = true;
                            v1372.LightInfluence = 1;
                            v1372.Size = UDim2.new(0, 200, 0, 50);
                            v1372.StudsOffset = Vector3.new(0, 2.5, 0);
                            v1373.Parent = v1372;
                            v1373.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            v1373.BackgroundTransparency = 1;
                            v1373.Size = UDim2.new(0, 200, 0, 50);
                            v1373.Font = Enum.Font.GothamBold;
                            v1373.TextColor3 = Color3.fromRGB(7, 236, 240);
                            v1373.Text.Size = 35;
                        end
                        local v1021 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v823.HumanoidRootPart.Position).Magnitude);
                        v823.MobEap.TextLabel.Text = v823.Name .. "-" .. v1021 .. " Distance" ;
                    end
                end
            else
                for v824, v825 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v825:FindFirstChild("MobEap") then
                        v825.MobEap:Destroy();
                    end
                end
            end
        end);
    end
end);
spawn(function()
    while wait() do
        pcall(function()
            if SeaESP then
                for v826, v827 in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                    if v827:FindFirstChild("HumanoidRootPart") then
                        if not v827:FindFirstChild("Seaesps") then
                            local v1391 = Instance.new("BillboardGui");
                            local v1392 = Instance.new("TextLabel");
                            v1391.Parent = v827;
                            v1391.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                            v1391.Active = true;
                            v1391.Name = "Seaesps";
                            v1391.AlwaysOnTop = true;
                            v1391.LightInfluence = 1;
                            v1391.Size = UDim2.new(0, 200, 0, 50);
                            v1391.StudsOffset = Vector3.new(0, 2.5, 0);
                            v1392.Parent = v1391;
                            v1392.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            v1392.BackgroundTransparency = 1;
                            v1392.Size = UDim2.new(0, 200, 0, 50);
                            v1392.Font = Enum.Font.GothamBold;
                            v1392.TextColor3 = Color3.fromRGB(7, 236, 240);
                            v1392.Text.Size = 35;
                        end
                        local v1023 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v827.HumanoidRootPart.Position).Magnitude);
                        v827.Seaesps.TextLabel.Text = v827.Name .. "-" .. v1023 .. " Distance" ;
                    end
                end
            else
                for v828, v829 in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                    if v829:FindFirstChild("Seaesps") then
                        v829.Seaesps:Destroy();
                    end
                end
            end
        end);
    end
end);
spawn(function()
    while wait() do
        pcall(function()
            if NpcESP then
                for v830, v831 in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    if v831:FindFirstChild("HumanoidRootPart") then
                        if not v831:FindFirstChild("NpcEspes") then
                            local v1410 = Instance.new("BillboardGui");
                            local v1411 = Instance.new("TextLabel");
                            v1410.Parent = v831;
                            v1410.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                            v1410.Active = true;
                            v1410.Name = "NpcEspes";
                            v1410.AlwaysOnTop = true;
                            v1410.LightInfluence = 1;
                            v1410.Size = UDim2.new(0, 200, 0, 50);
                            v1410.StudsOffset = Vector3.new(0, 2.5, 0);
                            v1411.Parent = v1410;
                            v1411.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            v1411.BackgroundTransparency = 1;
                            v1411.Size = UDim2.new(0, 200, 0, 50);
                            v1411.Font = Enum.Font.GothamBold;
                            v1411.TextColor3 = Color3.fromRGB(7, 236, 240);
                            v1411.Text.Size = 35;
                        end
                        local v1025 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v831.HumanoidRootPart.Position).Magnitude);
                        v831.NpcEspes.TextLabel.Text = v831.Name .. "-" .. v1025 .. " Distance" ;
                    end
                end
            else
                for v832, v833 in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    if v833:FindFirstChild("NpcEspes") then
                        v833.NpcEspes:Destroy();
                    end
                end
            end
        end);
    end
end);
function isnil(v202)
    return v202 == nil ;
end
local function v20(v203)
    return math.floor(tonumber(v203) + 0.5);
end
Number = math.random(1, 1000000);
function UpdateIslandMirageESP()
    for v457, v458 in pairs(game:GetService("Workspace")['_WorldOrigin'].Locations:GetChildren()) do
        pcall(function()
            if MirageIslandESP then
                if (v458.Name == "Mirage Island") then
                    if not v458:FindFirstChild("NameEsp") then
                        local v1270 = Instance.new("BillboardGui", v458);
                        v1270.Name = "NameEsp";
                        v1270.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1270.Size = UDim2.new(1, 200, 1, 30);
                        v1270.Adornee = v458;
                        v1270.AlwaysOnTop = true;
                        local v1276 = Instance.new("TextLabel", v1270);
                        v1276.Font = "Code";
                        v1276.FontSize = "Size14";
                        v1276.TextWrapped = true;
                        v1276.Size = UDim2.new(1, 0, 1, 0);
                        v1276.TextYAlignment = "Top";
                        v1276.BackgroundTransparency = 1;
                        v1276.TextStrokeTransparency = 0.5;
                        v1276.TextColor3 = Color3.fromRGB(80, 245, 245);
                    else
                        v458['NameEsp'].TextLabel.Text = v458.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v458.Position).Magnitude / 3) .. " M" ;
                    end
                end
            elseif v458:FindFirstChild("NameEsp") then
                v458:FindFirstChild("NameEsp"):Destroy();
            end
        end);
    end
end
function UpdateAuraESP()
    for v459, v460 in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        pcall(function()
            if AuraESP then
                if (v460.Name == "Master of Enhancement") then
                    if not v460:FindFirstChild("NameEsp") then
                        local v1286 = Instance.new("BillboardGui", v460);
                        v1286.Name = "NameEsp";
                        v1286.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1286.Size = UDim2.new(1, 200, 1, 30);
                        v1286.Adornee = v460;
                        v1286.AlwaysOnTop = true;
                        local v1292 = Instance.new("TextLabel", v1286);
                        v1292.Font = "Code";
                        v1292.FontSize = "Size14";
                        v1292.TextWrapped = true;
                        v1292.Size = UDim2.new(1, 0, 1, 0);
                        v1292.TextYAlignment = "Top";
                        v1292.BackgroundTransparency = 1;
                        v1292.TextStrokeTransparency = 0.5;
                        v1292.TextColor3 = Color3.fromRGB(80, 245, 245);
                    else
                        v460['NameEsp'].TextLabel.Text = v460.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v460.Position).Magnitude / 3) .. " M" ;
                    end
                end
            elseif v460:FindFirstChild("NameEsp") then
                v460:FindFirstChild("NameEsp"):Destroy();
            end
        end);
    end
end
function UpdateLSDESP()
    for v461, v462 in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        pcall(function()
            if LADESP then
                if (v462.Name == "Legendary Sword Dealer") then
                    if not v462:FindFirstChild("NameEsp") then
                        local v1302 = Instance.new("BillboardGui", v462);
                        v1302.Name = "NameEsp";
                        v1302.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1302.Size = UDim2.new(1, 200, 1, 30);
                        v1302.Adornee = v462;
                        v1302.AlwaysOnTop = true;
                        local v1308 = Instance.new("TextLabel", v1302);
                        v1308.Font = "Code";
                        v1308.FontSize = "Size14";
                        v1308.TextWrapped = true;
                        v1308.Size = UDim2.new(1, 0, 1, 0);
                        v1308.TextYAlignment = "Top";
                        v1308.BackgroundTransparency = 1;
                        v1308.TextStrokeTransparency = 0.5;
                        v1308.TextColor3 = Color3.fromRGB(80, 245, 245);
                    else
                        v462['NameEsp'].TextLabel.Text = v462.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v462.Position).Magnitude / 3) .. " M" ;
                    end
                end
            elseif v462:FindFirstChild("NameEsp") then
                v462:FindFirstChild("NameEsp"):Destroy();
            end
        end);
    end
end
function UpdateGeaESP()
    for v463, v464 in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do
        pcall(function()
            if GearESP then
                if (v464.Name == "MeshPart") then
                    if not v464:FindFirstChild("NameEsp") then
                        local v1318 = Instance.new("BillboardGui", v464);
                        v1318.Name = "NameEsp";
                        v1318.ExtentsOffset = Vector3.new(0, 1, 0);
                        v1318.Size = UDim2.new(1, 200, 1, 30);
                        v1318.Adornee = v464;
                        v1318.AlwaysOnTop = true;
                        local v1324 = Instance.new("TextLabel", v1318);
                        v1324.Font = "Code";
                        v1324.FontSize = "Size14";
                        v1324.TextWrapped = true;
                        v1324.Size = UDim2.new(1, 0, 1, 0);
                        v1324.TextYAlignment = "Top";
                        v1324.BackgroundTransparency = 1;
                        v1324.TextStrokeTransparency = 0.5;
                        v1324.TextColor3 = Color3.fromRGB(80, 245, 245);
                    else
                        v464['NameEsp'].TextLabel.Text = v464.Name .. "   \n" .. v20((game:GetService("Players").LocalPlayer.Character.Head.Position - v464.Position).Magnitude / 3) .. " M" ;
                    end
                end
            elseif v464:FindFirstChild("NameEsp") then
                v464:FindFirstChild("NameEsp"):Destroy();
            end
        end);
    end
end
function Tween2(v204)
    local v205 = (v204.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude;
    local v206 = 350;
    if (v205 >= 350) then
        v206 = 350;
    end
    local v207 = TweenInfo.new(v205 / v206, Enum.EasingStyle.Linear);
    local v208 = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v207, {
        CFrame = v204
    });
    v208:Play();
    if _G.CancelTween2 then
        v208:Cancel();
    end
    _G.Clip2 = true;
    wait(v205 / v206);
    _G.Clip2 = false;
end
function BTPZ(v209)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v209;
    task.wait();
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v209;
end
TweenSpeed = 350;
function Tween(v211)
    local v212 = (v211.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude;
    local v213 = TweenSpeed;
    if (v212 >= 350) then
        v213 = TweenSpeed;
    end
    local v214 = TweenInfo.new(v212 / v213, Enum.EasingStyle.Linear);
    local v215 = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v214, {
        CFrame = v211
    });
    v215:Play();
    if _G.StopTween then
        v215:Cancel();
    end
end
function CancelTween(v216)
    if not v216 then
        _G.StopTween = true;
        wait();
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame);
        wait();
        _G.StopTween = false;
    end
end
function EquipTool(v217)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(v217) then
        local v570 = game.Players.LocalPlayer.Backpack:FindFirstChild(v217);
        wait();
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v570);
    end
end
spawn(function()
    local v218 = getrawmetatable(game);
    local v219 = v218.__namecall;
    setreadonly(v218, false);
    v218.__namecall = newcclosure(function(...)
        local v465 = getnamecallmethod();
        local v466 = {
            ...
        };
        if (tostring(v465) == "FireServer") then
            if (tostring(v466[1]) == "RemoteEvent") then
                if ((tostring(v466[2]) ~= "true") and (tostring(v466[2]) ~= "false")) then
                    if _G.UseSkill then
                        if (type(v466[2]) == "vector") then
                            v466[2] = PositionSkillMasteryDevilFruit;
                        else
                            v466[2] = CFrame.new(PositionSkillMasteryDevilFruit);
                        end
                        return v219(unpack(v466));
                    end
                end
            end
        end
        return v219(...);
    end);
end);
spawn(function()
    while task.wait() do
        pcall(function()
            if (_G.AutoEvoRace or _G.CastleRaid or _G.CollectAzure or _G.TweenToKitsune or _G.GhostShip or _G.Ship or _G.Auto_Holy_Torch or _G.TeleportPly or _G.Auto_Sea3 or _G.Auto_Sea2 or _G.Tweenfruit or _G.AutoFishCrew or _G.Auto_Saber or _G.AutoShark or _G.Auto_Warden or _G.Auto_RainbowHaki or AutoFarmRace or _G.AutoQuestRace or Auto_Law or AutoTushita or _G.AutoHolyTorch or _G.AutoTerrorshark or _G.farmpiranya or _G.Auto_MusketeerHat or _G.Auto_ObservationV2 or _G.AutoNear or _G.Auto_PoleV1 or _G.Auto_Buddy or _G.Ectoplasm or AutoEvoRace or AutoBartilo or _G.Auto_Canvander or _G.AutoLevel or _G.Auto_DualKatana or Auto_Quest_Yama_3 or Auto_Quest_Yama_2 or Auto_Quest_Yama_1 or Auto_Quest_Tushita_1 or Auto_Quest_Tushita_2 or Auto_Quest_Tushita_3 or _G.Clip2 or _G.Auto_Regoku or _G.AutoBone or _G.AutoBoneNoQuest or _G.AutoBoss or AutoFarmMasDevilFruit or AutoHallowSycthe or AutoTushita or _G.CakePrince or _G.Auto_SkullGuitar or _G.AutoFarmSwan or _G.DoughKing or _G.AutoEliteor or AutoNextIsland or Musketeer or _G.AutoMaterial or AutoFarmRaceQuest or _G.Factory or _G.Auto_Saw or _G.AutoFrozenDimension or _G.AutoKillTrial or _G.AutoUpgrade or _G.TweenToFrozenDimension) then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local v887 = Instance.new("BodyVelocity");
                    v887.Name = "BodyClip";
                    v887.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart;
                    v887.MaxForce = Vector3.new(100000, 100000, 100000);
                    v887.Velocity = Vector3.new(0, 0, 0);
                end
            else
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy();
            end
        end);
    end
end);
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if (_G.AutoEvoRace or _G.Auto_RainbowHaki or _G.Auto_SkullGuitar or _G.CastleRaid or _G.CollectAzure or _G.TweenToKitsune or _G.Auto_Sea3 or _G.Auto_Sea2 or _G.GhostShip or _G.Ship or _G.Auto_Holy_Torch or _G.TeleportPly or _G.Tweenfruit or _G.Auto_Saber or _G.Auto_PoleV1 or _G.Auto_MusketeerHat or _G.AutoFishCrew or _G.AutoShark or AutoFarmRace or _G.AutoQuestRace or _G.Auto_Warden or Auto_Law or _G.Auto_DualKatana or Auto_Quest_Tushita_1 or Auto_Quest_Tushita_2 or Auto_Quest_Tushita_3 or AutoTushita or _G.AutoHolyTorch or _G.Auto_Buddy or _G.AutoTerrorshark or _G.farmpiranya or Auto_Quest_Yama_3 or _G.Auto_ObservationV2 or Auto_Quest_Yama_2 or Auto_Quest_Yama_1 or _G.AutoNear or _G.Ectoplasm or AutoEvoRace or _G.AutoKillTrial or AutoBartilo or _G.Auto_Regoku or _G.AutoLevel or _G.Clip2 or _G.AutoBone or _G.Auto_Canvander or _G.AutoBoneNoQuest or _G.AutoBoss or _G.Auto_Saw or AutoFarmMasDevilFruit or AutoHallowSycthe or AutoTushita or _G.CakePrince or _G.DoughKing or _G.AutoFarmSwan or _G.AutoEliteor or AutoNextIsland or Musketeer or _G.AutoMaterial or _G.Factory or _G.AutoFrozenDimension or AutoFarmRaceQuest or _G.AutoUpgrade or _G.TweenToFrozenDimension) then
                for v834, v835 in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v835:IsA("BasePart") then
                        v835.CanCollide = false;
                    end
                end
            end
        end);
    end);
end);
task.spawn(function()
    if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
        game.Players.LocalPlayer.Character.Stun.Changed:connect(function()
            pcall(function()
                if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
                    game.Players.LocalPlayer.Character.Stun.Value = 0;
                end
            end);
        end);
    end
end);
function CheckMaterial(v221)
    for v467, v468 in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if (type(v468) == "table") then
            if (v468.Type == "Material") then
                if (v468.Name == v221) then
                    return v468.Count;
                end
            end
        end
    end
    return 0;
end
function GetWeaponInventory(v222)
    for v469, v470 in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if (type(v470) == "table") then
            if (v470.Type == "Sword") then
                if (v470.Name == v222) then
                    return true;
                end
            end
        end
    end
    return false;
end
local v21 = game.Players.LocalPlayer;
function FindEnemiesInRange(v223, v224)
    local v225 = (v21.Character or v21.CharacterAdded:Wait()):GetPivot().Position;
    local v226 = nil;
    for v471, v472 in ipairs(v224) do
        if (not v472:GetAttribute("IsBoat") and v472:FindFirstChildOfClass("Humanoid") and (v472.Humanoid.Health > 0)) then
            local v671 = v472:FindFirstChild("Head");
            if (v671 and ((v225 - v671.Position).Magnitude <= 60)) then
                if (v472 ~= v21.Character) then
                    table.insert(v223, {
                        v472,
                        v671
                    });
                    v226 = v671;
                end
            end
        end
    end
    for v473, v474 in ipairs(game.Players:GetPlayers()) do
        if (v474.Character and (v474 ~= v21)) then
            local v672 = v474.Character:FindFirstChild("Head");
            if (v672 and ((v225 - v672.Position).Magnitude <= 60)) then
                table.insert(v223, {
                    v474.Character,
                    v672
                });
                v226 = v672;
            end
        end
    end
    return v226;
end
function GetEquippedTool()
    local v227 = v21.Character;
    if not v227 then
        return nil;
    end
    for v475, v476 in ipairs(v227:GetChildren()) do
        if v476:IsA("Tool") then
            return v476;
        end
    end
    return nil;
end
function AttackNoCoolDown()
    local v228 = {};
    local v229 = game:GetService("Workspace").Enemies:GetChildren();
    local v230 = FindEnemiesInRange(v228, v229);
    if not v230 then
        return;
    end
    local v231 = GetEquippedTool();
    if not v231 then
        return;
    end
    pcall(function()
        local v477 = game:GetService("ReplicatedStorage");
        local v478 = v477:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack");
        local v479 = v477:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit");
        if (# v228 > 0) then
            v478:FireServer(1e-9);
            v479:FireServer(v230, v228);
        else
            task.wait(1e-9);
        end
    end);
end
Type = 1;
spawn(function()
    while wait() do
        if (Type == 1) then
            Pos = CFrame.new(0, 40, 0);
        elseif (Type == 2) then
            Pos = CFrame.new(- 40, 40, 0);
        elseif (Type == 3) then
            Pos = CFrame.new(40, 40, 0);
        elseif (Type == 4) then
            Pos = CFrame.new(0, 40, 40);
        elseif (Type == 5) then
            Pos = CFrame.new(0, 40, - 40);
        end
    end
end);
spawn(function()
    while wait() do
        Type = 1;
        wait(0.2);
        Type = 2;
        wait(0.2);
        Type = 3;
        wait(0.2);
        Type = 4;
        wait(0.2);
        Type = 5;
        wait(0.2);
    end
end);
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso");
    end
end
function to(v232)
    repeat
        wait(_G.Fast_Delay);
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15);
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v232;
        task.wait();
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v232;
    until (v232.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2000
end
function to(v233)
    pcall(function()
        if (((v233.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 2000) and not Auto_Raid and (game.Players.LocalPlayer.Character.Humanoid.Health > 0)) then
            if (NameMon == "FishmanQuest") then
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
                wait();
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875));
            elseif (Mon == "God's Guard") then
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
                wait();
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.82275, 872.54248, - 1667.55688));
            elseif (NameMon == "SkyExp1Quest") then
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
                wait();
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.6176757813, 5547.1416015625, - 380.29119873047));
            elseif (NameMon == "ShipQuest1") then
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
                wait();
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
            elseif (NameMon == "ShipQuest2") then
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
                wait();
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125));
            elseif (NameMon == "FrostQuest") then
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
                wait();
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 6508.5581054688, 89.034996032715, - 132.83953857422));
            else
                repeat
                    wait(_G.Fast_Delay);
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v233;
                    wait(0.05);
                    game.Players.LocalPlayer.Character.Head:Destroy();
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v233;
                until ((v233.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2500) and (game.Players.LocalPlayer.Character.Humanoid.Health > 0)
                wait();
            end
        end
    end);
end
local v22 = Instance.new("ScreenGui");
local v23 = Instance.new("ImageButton");
local v24 = Instance.new("UICorner");
local v25 = Instance.new("ParticleEmitter");
local v26 = game:GetService("TweenService");
v22.Parent = game.CoreGui;
v22.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
v23.Parent = v22;
v23.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
v23.BorderSizePixel = 0;
v23.Position = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0);
v23.Size = UDim2.new(0, 50, 0, 50);
v23.Draggable = true;
v23.Image = "http://www.roblox.com/asset/?id=83190276951914";
v24.Parent = v23;
v24.CornerRadius = UDim.new(0, 12);
v25.Parent = v23;
v25.LightEmission = 1;
v25.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 0)
});
v25.Lifetime = NumberRange.new(0.5, 1);
v25.Rate = 0;
v25.Speed = NumberRange.new(5, 10);
v25.Color = ColorSequence.new(Color3.fromRGB(255, 85, 255), Color3.fromRGB(85, 255, 255));
local v47 = v26:Create(v23, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Rotation = 360
});
v23.MouseButton1Down:Connect(function()
    v25.Rate = 100;
    task.delay(1, function()
        v25.Rate = 0;
    end);
    v47:Play();
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.End, false, game);
    v47.Completed:Connect(function()
        v23.Rotation = 0;
    end);
    local v235 = v26:Create(v23, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60)
    });
    v235:Play();
    v235.Completed:Connect(function()
        local v483 = v26:Create(v23, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        });
        v483:Play();
    end);
end);
if game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("Death") then
    game:GetService("ReplicatedStorage").Effect.Container.Death:Destroy();
end
if game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("Respawn") then
    game:GetService("ReplicatedStorage").Effect.Container.Respawn:Destroy();
end

local Button = o1Tab:CreateButton({
   Name = "Discord",
   Callback = function()
   setclipboard("https://discord.gg/42nGBWUBN");
   end,
})



_G.FastAttackStrix_Mode = "Super Fast Attack"

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.FastAttackStrix_Mode == "Super Fast Attack" then
                _G.Fast_Delay = 1e-9
            end
        end)
    end
end)

----------------------------------------------------
-- 🔽 Chuyển Dropdown sang Tab:CreateDropdown
----------------------------------------------------

local DropdownWeapon = o2Tab:CreateDropdown({
    Name = "Vũ Khí",
    Options = {"Melee", "Sword", "Blox Fruits"},
    CurrentOption = {"Melee"},
    MultipleOptions = false,
    Flag = "Dropdown_Weapon",
    Callback = function(option)
        ChooseWeapon = option[1] -- Lấy string trong table
    end
})

ChooseWeapon = "Melee" -- set mặc định

----------------------------------------------------
-- 🔽 Auto chọn vũ khí theo Backpack
----------------------------------------------------

task.spawn(function()
    while task.wait() do
        pcall(function()

            -- Melee
            if ChooseWeapon == "Melee" then
                for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        SelectWeapon = v.Name
                    end
                end
            end

            -- Sword
            if ChooseWeapon == "Sword" then
                for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        SelectWeapon = v.Name
                    end
                end
            end

            -- Blox Fruit
            if ChooseWeapon == "Blox Fruits" then
                for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        SelectWeapon = v.Name
                    end
                end
            end

        end)
    end
end)

----------------------------------------------------
-- 🔽 Toggle Auto Level kiểu UI mới
----------------------------------------------------
local ToggleLevel = o2Tab:CreateToggle({
    Name = "farm cấp",
    CurrentValue = false,
    Flag = "Toggle_AutoLevel",
    Callback = function(value)
        _G.AutoLevel = value

        if value == false then
            task.wait()
            Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
            task.wait()
        end
    end
})

_G.AutoLevel = false
ToggleLevel:SetValue(false)
----------------------------------------------------
-- 🔽 Auto Level Main Loop
----------------------------------------------------

task.spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()

                CheckLevel()

                local QuestUI = game.Players.LocalPlayer.PlayerGui.Main.Quest
                local Title = QuestUI.Container.QuestTitle.Title.Text

                ----------------------------------------------------------
                -- Lấy nhiệm vụ
                ----------------------------------------------------------
                if not string.find(Title, NameMon) or QuestUI.Visible == false then

                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                    Tween(CFrameQ)

                    if (CFrameQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                    end

                ----------------------------------------------------------
                -- Bắt đầu farm
                ----------------------------------------------------------
                else
                    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") 
                        and mob:FindFirstChild("HumanoidRootPart") 
                        and mob.Humanoid.Health > 0 
                        and mob.Name == Ms then

                            repeat
                                task.wait(_G.Fast_Delay)

                                AttackNoCoolDown()
                                bringmob = true
                                AutoHaki()
                                EquipTool(SelectWeapon)

                                Tween(mob.HumanoidRootPart.CFrame * Pos)

                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 1
                                mob.Humanoid.JumpPower = 0
                                mob.Humanoid.WalkSpeed = 0
                                mob.HumanoidRootPart.CanCollide = false

                                FarmPos = mob.HumanoidRootPart.CFrame
                                MonFarm = mob.Name

                            until
                                not _G.AutoLevel
                                or not mob.Parent
                                or mob.Humanoid.Health <= 0
                                or not game.Workspace.Enemies:FindFirstChild(mob.Name)
                                or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false

                            bringmob = false
                        end
                    end

                    ----------------------------------------------------------
                    -- Tìm vị trí spawn mob nếu mob chết hoặc hết mob
                    ----------------------------------------------------------
                    for _, sp in pairs(game.Workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                        if string.find(sp.Name, NameMon) then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - sp.Position).Magnitude >= 10 then
                                Tween(sp.CFrame * Pos)
                            end
                        end
                    end

                end
            end)
        end
    end
end)

----------------------------------------------------
-- 🔽 Toggle Đấm Quái Gần (Mob Aura)
----------------------------------------------------
local ToggleMobAura = o2Tab:CreateToggle({
    Name = "farm quái gần",
    CurrentValue = false,
    Flag = "Toggle_MobAura",
    Callback = function(value)
        _G.AutoNear = value

        if value == false then
            task.wait()
            Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
            task.wait()
        end
    end
})

_G.AutoNear = false
ToggleMobAura:SetValue(false)

----------------------------------------------------
-- 🔽 Mob Aura Main Loop
----------------------------------------------------
task.spawn(function()
    while task.wait() do
        if _G.AutoNear then
            pcall(function()

                for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid")
                    and mob:FindFirstChild("HumanoidRootPart")
                    and mob.Humanoid.Health > 0 then

                        -- Kiểm tra khoảng cách
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude <= 5000 then

                            repeat
                                task.wait(_G.Fast_Delay)

                                AttackNoCoolDown()
                                bringmob = true
                                AutoHaki()
                                EquipTool(SelectWeapon)

                                Tween(mob.HumanoidRootPart.CFrame * Pos)

                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 1
                                mob.Humanoid.JumpPower = 0
                                mob.Humanoid.WalkSpeed = 0
                                mob.HumanoidRootPart.CanCollide = false

                                FarmPos = mob.HumanoidRootPart.CFrame
                                MonFarm = mob.Name

                            until not _G.AutoNear
                                or not mob.Parent
                                or mob.Humanoid.Health <= 0
                                or not game.Workspace.Enemies:FindFirstChild(mob.Name)

                            bringmob = false
                        end
                    end
                end

            end)
        end
    end
end)

----------------------------------------------------
-- 📌 Section Xương
----------------------------------------------------
local BoneSection = Tab:CreateSection("Xương")

----------------------------------------------------
-- 📌 Paragraph trạng thái xương
----------------------------------------------------
local BoneParagraph = Tab:CreateParagraph({
    Title = "Xương Trạng Thái",
    Content = "Đang tải..."
})

----------------------------------------------------
-- 📌 Loop cập nhật số lượng xương
----------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            local bones = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Check")
            BoneParagraph:SetDesc("Bạn Có: " .. tostring(bones) .. " Xương")
        end)
    end
end)

----------------------------------------------------
-- 📌 Toggle Auto Bone (Có Quest)
----------------------------------------------------
local ToggleBone = o2Tab:CreateToggle({
    Name = "Cày Xương",
    CurrentValue = false,
    Flag = "Toggle_AutoBone",
    Callback = function(state)
        _G.AutoBone = state
        if state == false then
            task.wait()
            Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
            task.wait()
        end
    end
})

_G.AutoBone = false
ToggleBone:SetValue(false)

----------------------------------------------------
-- 📌 Auto Bone Main Logic
----------------------------------------------------
local BoneQuestCFrame = CFrame.new(-9515.75, 174.85217, 6079.40625)

task.spawn(function()
    while task.wait() do
        if _G.AutoBone then
            pcall(function()

                -- Lấy tên quest hiện tại
                local QuestTitle = game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

                -- Nếu không phải quest Demonic Soul → bỏ quest
                if not string.find(QuestTitle, "Demonic Soul") then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                end

                -- Nếu chưa có quest
                if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    Tween(BoneQuestCFrame)

                    if (BoneQuestCFrame.Position -
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then

                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "HauntedQuest2", 1)
                    end

                else
                    -- Đã có quest
                    if game.Workspace.Enemies:FindFirstChild("Reborn Skeleton")
                    or game.Workspace.Enemies:FindFirstChild("Living Zombie")
                    or game.Workspace.Enemies:FindFirstChild("Demonic Soul")
                    or game.Workspace.Enemies:FindFirstChild("Posessed Mummy") then

                        for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                            if mob:FindFirstChild("HumanoidRootPart")
                            and mob:FindFirstChild("Humanoid")
                            and mob.Humanoid.Health > 0 then

                                if mob.Name == "Reborn Skeleton"
                                or mob.Name == "Living Zombie"
                                or mob.Name == "Demonic Soul"
                                or mob.Name == "Posessed Mummy" then

                                    -- Đúng quest thì farm
                                    if string.find(QuestTitle, "Demonic Soul") then
                                        repeat
                                            task.wait(_G.Fast_Delay)

                                            AttackNoCoolDown()
                                            AutoHaki()
                                            bringmob = true
                                            EquipTool(SelectWeapon)

                                            Tween(mob.HumanoidRootPart.CFrame * Pos)

                                            mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                            mob.HumanoidRootPart.Transparency = 1
                                            mob.Humanoid.JumpPower = 0
                                            mob.Humanoid.WalkSpeed = 0
                                            mob.HumanoidRootPart.CanCollide = false

                                            FarmPos = mob.HumanoidRootPart.CFrame
                                            MonFarm = mob.Name

                                        until not _G.AutoBone
                                        or mob.Humanoid.Health <= 0
                                        or not mob.Parent
                                        or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false

                                    else
                                        -- Sai quest thì bỏ quest
                                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                                        bringmob = false
                                    end
                                end
                            end
                        end
                    end
                end

            end)
        end
    end
end)



----------------------------------------------------
-- 📌 Auto Bone Không Quest (NoQuest)
----------------------------------------------------
local ToggleBoneNoQuest = o2Tab:CreateToggle({
    Name = "farm xương ko nhận nhiệm vụ",
    CurrentValue = false,
    Flag = "Toggle_AutoBoneNoQuest",
    Callback = function(state)
        _G.AutoBoneNoQuest = state
    end
})

_G.AutoBoneNoQuest = false
ToggleBoneNoQuest:SetValue(false)

local BoneFarmPos = CFrame.new(-9515.75, 174.85217, 6079.40625)

task.spawn(function()
    while task.wait() do
        if _G.AutoBoneNoQuest then
            pcall(function()

                Tween(BoneFarmPos)

                if game.Workspace.Enemies:FindFirstChild("Reborn Skeleton")
                or game.Workspace.Enemies:FindFirstChild("Living Zombie")
                or game.Workspace.Enemies:FindFirstChild("Demonic Soul")
                or game.Workspace.Enemies:FindFirstChild("Posessed Mummy") then

                    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart")
                        and mob:FindFirstChild("Humanoid")
                        and mob.Humanoid.Health > 0 then

                            if mob.Name == "Reborn Skeleton"
                            or mob.Name == "Living Zombie"
                            or mob.Name == "Demonic Soul"
                            or mob.Name == "Posessed Mummy" then

                                repeat
                                    task.wait(_G.Fast_Delay)

                                    AttackNoCoolDown()
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)

                                    Tween(mob.HumanoidRootPart.CFrame * Pos)

                                    mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    mob.HumanoidRootPart.Transparency = 1
                                    mob.Humanoid.JumpPower = 0
                                    mob.Humanoid.WalkSpeed = 0
                                    mob.HumanoidRootPart.CanCollide = false

                                    FarmPos = mob.HumanoidRootPart.CFrame
                                    MonFarm = mob.Name

                                until not _G.AutoBoneNoQuest
                                or mob.Humanoid.Health <= 0
                                or not mob.Parent
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local Button = o2Tab:CreateButton({
    Name = "Cầu Nguyện",
    Callback = function()
        local v572 = {
            [1] = "gravestoneEvent",
            [2] = 1
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v572))
    end,
})

local Button = o2Tab:CreateButton({
    Name = "Thử Vận May",
    Callback = function()
        local v573 = {
            [1] = "gravestoneEvent",
            [2] = 2
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v573))
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Random Xương",
    CurrentValue = false,
    Flag = "ToggleRandomBone",
    Callback = function(Value)
        _G.AutoRandomBone = Value
    end,
})

Toggle:SetValue(false)

task.spawn(function()
    while task.wait() do
        if _G.AutoRandomBone then
            local v844 = {
                [1] = "Bones",
                [2] = "Buy",
                [3] = 1,
                [4] = 1
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v844))
        end
    end
end)

if Sea3 then
    
    local Section = o2Tab:CreateSection("Tư Lệnh Bánh")

    local Paragraph = o2Tab:CreateParagraph({
        Title = "Trạng Thái Nó Ra",
        Content = ""
    })

    task.spawn(function()
        while task.wait() do
            pcall(function()
                local info = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                local len = string.len(info)

                if len == 88 then
                    Paragraph:SetDesc("Còn: " .. string.sub(info, 39, 41))
                elseif len == 87 then
                    Paragraph:SetDesc("Còn: " .. string.sub(info, 39, 40))
                elseif len == 86 then
                    Paragraph:SetDesc("Còn: " .. string.sub(info, 39, 39))
                else
                    Paragraph:SetDesc("Tư Lệnh Bánh : ✅️")
                end
            end)
        end
    end)

end

-- Toggle Cày Tư Lệnh Bánh
local v492 = o2Tab:CreateToggle("ToggleCake", {
    Title = "farm Tư Lệnh Bánh",
    Description = "",
    Default = false
})

local v493 = true

v492:OnChanged(function(v575)
    _G.CakePrince = v575;
    if v575 then
        if v493 then
            v493 = false;
            local v895 = CFrame.new(-2003.932861328125, 380.4824523925781, -12561.0185546875)
            Tween(v895)
        end
    else
        v493 = true
        wait()
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)

v17.ToggleCake:SetValue(false)

spawn(function()
    while wait() do
        if _G.CakePrince then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") then
                    for _, v1439 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v1439.Name == "Cake Prince" then
                            if v1439:FindFirstChild("Humanoid") and v1439:FindFirstChild("HumanoidRootPart") and v1439.Humanoid.Health > 0 then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v1439.HumanoidRootPart.CanCollide = false
                                    v1439.Humanoid.WalkSpeed = 0
                                    v1439.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    Tween(v1439.HumanoidRootPart.CFrame * Pos)
                                    AttackNoCoolDown()
                                until not _G.CakePrince or not v1439.Parent or v1439.Humanoid.Health <= 0
                            end
                        end
                    end

                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
                    Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))

                elseif game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 1 then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Cookie Crafter")
                    or game:GetService("Workspace").Enemies:FindFirstChild("Cake Guard")
                    or game:GetService("Workspace").Enemies:FindFirstChild("Baking Staff")
                    or game:GetService("Workspace").Enemies:FindFirstChild("Head Baker") then

                        for _, v1755 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v1755.Name == "Cookie Crafter"
                            or v1755.Name == "Cake Guard"
                            or v1755.Name == "Baking Staff"
                            or v1755.Name == "Head Baker" then

                                if v1755:FindFirstChild("Humanoid") and v1755:FindFirstChild("HumanoidRootPart") and v1755.Humanoid.Health > 0 then
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        AutoHaki()
                                        bringmob = true
                                        EquipTool(SelectWeapon)
                                        v1755.HumanoidRootPart.CanCollide = false
                                        v1755.Humanoid.WalkSpeed = 0
                                        v1755.Head.CanCollide = false
                                        v1755.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        FarmPos = v1755.HumanoidRootPart.CFrame
                                        MonFarm = v1755.Name
                                        Tween(v1755.HumanoidRootPart.CFrame * Pos)
                                        AttackNoCoolDown()
                                    until not _G.CakePrince
                                    or not v1755.Parent
                                    or v1755.Humanoid.Health <= 0
                                    or game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0
                                    or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]")
                                    or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]")

                                    bringmob = false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local ToggleSpawnCake = o2Tab:CreateToggle("ToggleSpawnCake", {
    Title = "Triệu Hồi Tư Lệnh Bánh",
    Description = "",
    Default = true
})

ToggleSpawnCake:OnChanged(function(enabled)
    _G.SpawnCakePrince = enabled
end)

v17.ToggleSpawnCake:SetValue(true)

spawn(function()
    while task.wait() do
        if _G.SpawnCakePrince then
            -- Lệnh spawn 1
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "CakePrinceSpawner",
                true
            )

            -- Lệnh spawn 2
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "CakePrinceSpawner"
            )
        end
    end
end)

local ToggleDoughKing = o2Tab:CreateToggle("ToggleDoughKing", {
    Title = "đánh Vua Bột",
    Description = "",
    Default = false
})

ToggleDoughKing:OnChanged(function(state)
    _G.DoughKing = state;
    if (state == false) then
        wait();
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame);
        wait();
    end
end)

v17.ToggleDoughKing:SetValue(false)

spawn(function()
    while wait() do
        if _G.DoughKing then
            pcall(function()

                -- Kiểm tra boss Dough King có tồn tại chưa
                if game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then

                    -- Lặp toàn bộ Enemy
                    for index, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do

                        -- Chọn đúng Dough King
                        if (enemy.Name == "Dough King") then

                            -- Kiểm tra hợp lệ
                            if (enemy:FindFirstChild("Humanoid") 
                            and enemy:FindFirstChild("HumanoidRootPart") 
                            and (enemy.Humanoid.Health > 0)) then

                                repeat
                                    task.wait(_G.Fast_Delay);

                                    AutoHaki();
                                    EquipTool(SelectWeapon);

                                    enemy.HumanoidRootPart.CanCollide = false;
                                    enemy.Humanoid.WalkSpeed = 0;
                                    enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60);

                                    Tween(enemy.HumanoidRootPart.CFrame * Pos);

                                    AttackNoCoolDown();

                                until not _G.DoughKing 
                                or not enemy.Parent 
                                or (enemy.Humanoid.Health <= 0)

                            end
                        end
                    end
                end

            end)
        end
    end
end)

if Sea2 then

    local SectionEctoplasm = o2Tab:AddSection("Ectoplasm Farm")

    local ToggleEctoplasm = o2Tab:CreateToggle("ToggleVatChatKiDi", {
        Title = "Auto Farm Ectoplasm",
        Description = "",
        Default = false
    })

    ToggleEctoplasm:OnChanged(function(state)
        _G.Ectoplasm = state
    end)

    v17.ToggleVatChatKiDi:SetValue(false)

    spawn(function()
        while wait() do
            pcall(function()

                if _G.Ectoplasm then

                    -- Nếu đã có mob Ship trên map
                    if game.Workspace.Enemies:FindFirstChild("Ship Deckhand")
                    or game.Workspace.Enemies:FindFirstChild("Ship Engineer")
                    or game.Workspace.Enemies:FindFirstChild("Ship Steward")
                    or game.Workspace.Enemies:FindFirstChild("Ship Officer") then

                        for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do

                            if (mob.Name == "Ship Steward")
                            or (mob.Name == "Ship Engineer")
                            or (mob.Name == "Ship Deckhand")
                            or ((mob.Name == "Ship Officer") and mob:FindFirstChild("Humanoid")) then

                                if mob.Humanoid.Health > 0 then

                                    repeat
                                        wait(_G.Fast_Delay)

                                        AttackNoCoolDown()
                                        AutoHaki()

                                        bringmob = true
                                        EquipTool(SelectWeapon)

                                        Tween(mob.HumanoidRootPart.CFrame * Pos)

                                        mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        mob.HumanoidRootPart.Transparency = 1
                                        mob.HumanoidRootPart.CanCollide = false

                                        mob.Humanoid.JumpPower = 0
                                        mob.Humanoid.WalkSpeed = 0

                                        FarmPos = mob.HumanoidRootPart.CFrame
                                        MonFarm = mob.Name

                                    until _G.Ectoplasm == false
                                        or not mob.Parent
                                        or mob.Humanoid.Health == 0
                                        or not game.Workspace.Enemies:FindFirstChild(mob.Name)

                                    bringmob = false
                                end
                            end
                        end

                    else
                        -- Không có mob → dịch chuyển về vị trí mob Ship
                        local Distance = (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875)
                            - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

                        if Distance > 20000 then
                            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                                "requestEntrance",
                                Vector3.new(923.21252441406, 126.9760055542, 32852.83203125)
                            )
                        end

                        Tween(CFrame.new(904.4072265625, 181.05767822266, 33341.38671875))
                    end
                end

            end)
        end
    end)

end

-- Section
o2Tab:CreateSection("Trùm")

-- Danh sách Boss theo Sea
if Sea1 then
    tableBoss = {
        "The Gorilla King","Bobby","Yeti","Mob Leader",
        "Vice Admiral","Warden","Chief Warden","Swan",
        "Magma Admiral","Fishman Lord","Wysper","Thunder God",
        "Cyborg","Saber Expert"
    }
elseif Sea2 then
    tableBoss = {
        "Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral",
        "Cursed Captain","Darkbeard","Order",
        "Awakened Ice Admiral","Tide Keeper"
    }
elseif Sea3 then
    tableBoss = {
        "Stone","Hydra Leader","Kilo Admiral","Captain Elephant",
        "Beautiful Pirate","rip_indra True Form","Longma",
        "Soul Reaper","Cake Queen"
    }
end

-- Dropdown chọn Boss
o2Tab:CreateDropdown({
    Name = "Chọn Trùm",
    Options = tableBoss,
    Default = 1,
    Callback = function(v)
        _G.SelectBoss = v
    end
})

-- Toggle Auto Farm Boss
o2Tab:CreateToggle({
    Name = "fram boss",
    Default = false,
    Callback = function(v)
        _G.AutoBoss = v
    end
})

v17.ToggleAutoFarmBoss:SetValue(false)

-- Auto Farm Boss Loop
spawn(function()
    while task.wait() do
        if _G.AutoBoss then
            pcall(function()

                local boss = game.Workspace.Enemies:FindFirstChild(_G.SelectBoss)

                -- Nếu boss đang xuất hiện
                if boss then
                    for _,mob in pairs(game.Workspace.Enemies:GetChildren()) do
                        if mob.Name == _G.SelectBoss
                        and mob:FindFirstChild("Humanoid")
                        and mob:FindFirstChild("HumanoidRootPart")
                        and mob.Humanoid.Health > 0 then

                            repeat
                                task.wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()
                                EquipTool(SelectWeapon)

                                mob.HumanoidRootPart.CanCollide = false
                                mob.Humanoid.WalkSpeed = 0
                                mob.HumanoidRootPart.Size = Vector3.new(60,60,60)

                                Tween(mob.HumanoidRootPart.CFrame * Pos)
                                sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)

                            until not _G.AutoBoss
                            or not mob.Parent
                            or mob.Humanoid.Health <= 0
                        end
                    end

                -- Boss chưa xuất hiện → đứng chờ tại vị trí trong ReplicatedStorage
                else
                    local bossRS = game.ReplicatedStorage:FindFirstChild(_G.SelectBoss)
                    if bossRS and bossRS:FindFirstChild("HumanoidRootPart") then
                        Tween(bossRS.HumanoidRootPart.CFrame * CFrame.new(5,10,7))
                    end
                end

            end)
        end
    end
end)

-- Section
v16.Main:CreateSection("Nguyên Liệu")

-- Danh sách nguyên liệu theo Sea
if Sea1 then
    MaterialList = {
        "Scrap Metal","Leather","Angel Wings",
        "Magma Ore","Fish Tail"
    }
elseif Sea2 then
    MaterialList = {
        "Scrap Metal","Leather","Radioactive Material",
        "Mystic Droplet","Magma Ore","Vampire Fang"
    }
elseif Sea3 then
    MaterialList = {
        "Scrap Metal","Leather","Demonic Wisp",
        "Conjured Cocoa","Dragon Scale","Gunpowder",
        "Fish Tail","Mini Tusk","Hydra Enforcer",
        "Venomous Assailant"
    }
end

-- Dropdown
o2Tab:CreateDropdown({
    Name = "Chọn Nguyên Liệu",
    Options = MaterialList,
    Default = 1,
    Callback = function(v)
        SelectMaterial = v
    end
})

-- Toggle Auto Material
o2Tab:CreateToggle({
    Name = "Cày Nguyên Liệu",
    Default = false,
    Callback = function(v)
        _G.AutoMaterial = v
        if not v then
            wait()
            Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
            wait()
        end
    end
})

v17.ToggleMaterial:SetValue(false)

-- Auto Farm Loop
spawn(function()
    while task.wait() do
        if _G.AutoMaterial then
            pcall(function()

                MaterialMon(SelectMaterial)
                Tween(MPos)

                local mob = game.Workspace.Enemies:FindFirstChild(MMon)

                if mob then
                    for _,m in pairs(game.Workspace.Enemies:GetChildren()) do
                        if m.Name == MMon
                        and m:FindFirstChild("Humanoid")
                        and m:FindFirstChild("HumanoidRootPart")
                        and m.Humanoid.Health > 0 then

                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()

                                bringmob = true
                                EquipTool(SelectWeapon)

                                Tween(m.HumanoidRootPart.CFrame * Pos)

                                m.HumanoidRootPart.Size = Vector3.new(60,60,60)
                                m.HumanoidRootPart.Transparency = 1
                                m.Humanoid.JumpPower = 0
                                m.Humanoid.WalkSpeed = 0
                                m.HumanoidRootPart.CanCollide = false

                                FarmPos = m.HumanoidRootPart.CFrame
                                MonFarm = m.Name

                            until not _G.AutoMaterial
                            or not m.Parent
                            or m.Humanoid.Health <= 0

                            bringmob = false
                        end
                    end

                else
                    for _,spawnPoint in pairs(game.Workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                        if string.find(spawnPoint.Name, Mon) then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - spawnPoint.Position).Magnitude >= 10 then
                                Tween(spawnPoint.HumanoidRootPart.CFrame * Pos)
                            end
                        end
                    end
                end

            end)
        end
    end
end)

if Sea3 then

    -- SECTION ĐẢO CÁO
    v16.Sea:CreateSection("Đảo Cáo")

    -- PARAGRAPH TRẠNG THÁI
    local KitsuneStatus = o5Tab:CreateParagraph({
        Title = "Trạng Thái Đảo Cáo",
        Content = ""
    })

    function UpdateKitsune()
        if game.Workspace.Map:FindFirstChild("KitsuneIsland") then
            KitsuneStatus:SetDesc("Đảo Cáo : ✅️")
        else
            KitsuneStatus:SetDesc("Đảo Cáo : ❌️")
        end
    end

    spawn(function()
        while task.wait() do
            pcall(UpdateKitsune)
        end
    end)

    -- TOGGLE ESP KITSUNE
    o5Tab:CreateToggle({
        Name = "Định Vị Đảo Cáo",
        Default = false,
        Callback = function(v)
            KitsuneIslandEsp = v
            while KitsuneIslandEsp do
                task.wait()
                UpdateIslandKisuneESP()
            end
        end
    })
    v17.ToggleEspKitsune:SetValue(false)

    -- FUNC UPDATE ESP
    function UpdateIslandKisuneESP()
        for _, loc in pairs(game.Workspace._WorldOrigin.Locations:GetChildren()) do
            pcall(function()
                if KitsuneIslandEsp then
                    if loc.Name == "Kitsune Island" then
                        if not loc:FindFirstChild("NameEsp") then
                            local gui = Instance.new("BillboardGui", loc)
                            gui.Name = "NameEsp"
                            gui.ExtentsOffset = Vector3.new(0, 1, 0)
                            gui.Size = UDim2.new(1, 200, 1, 30)
                            gui.Adornee = loc
                            gui.AlwaysOnTop = true

                            local txt = Instance.new("TextLabel", gui)
                            txt.Font = "Code"
                            txt.TextWrapped = true
                            txt.BackgroundTransparency = 1
                            txt.TextStrokeTransparency = 0.5
                            txt.TextColor3 = Color3.fromRGB(80, 245, 245)
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.TextYAlignment = "Top"
                        else
                            loc.NameEsp.TextLabel.Text =
                                loc.Name .. "\n" ..
                                v20((game.Players.LocalPlayer.Character.Head.Position - loc.Position).Magnitude / 3)
                                .. " M"
                        end
                    end
                elseif loc:FindFirstChild("NameEsp") then
                    loc.NameEsp:Destroy()
                end
            end)
        end
    end

    -- TOGGLE TWEEN TO KITSUNE
    o5Tab:CreateToggle({
        Name = "Bay Vô Đảo Cáo",
        Default = false,
        Callback = function(v)
            _G.TweenToKitsune = v
        end
    })
    v17.ToggleTPKitsune:SetValue(false)

    -- Loop Tween vào đảo cáo
    spawn(function()
        local island
        while not island do
            island = game.Workspace.Map:FindFirstChild("KitsuneIsland")
            task.wait()
        end

        while task.wait() do
            if _G.TweenToKitsune then
                local shrine = island:FindFirstChild("ShrineActive")
                if shrine then
                    for _, part in pairs(shrine:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name:find("NeonShrinePart") then
                            Tween(part.CFrame)
                        end
                    end
                end
            end
        end
    end)

    -- TOGGLE NHẶT LINH HỒN XANH
    o5Tab:CreateToggle({
        Name = "Lụm Linh Hồn Xanh",
        Default = false,
        Callback = function(v)
            _G.CollectAzure = v
        end
    })
    v17.ToggleCollectAzure:SetValue(false)

    spawn(function()
        while task.wait() do
            if _G.CollectAzure then
                pcall(function()
                    if game.Workspace:FindFirstChild("AttachedAzureEmber") then
                        Tween(game.Workspace.EmberTemplate.Part.CFrame)
                    end
                end)
            end
        end
    end)
end

-- NÚT ĐỔI LINH HỒN XANH
o5Tab:CreateButton({
    Name = "Đổi Linh Hồn Xanh",
    Callback = function()
        game.ReplicatedStorage.Modules.Net["RF/KitsuneStatuePray"]:InvokeServer()
    end
})

if Sea3 then

    v16.Sea:CreateSection("Biển")

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VIM = game:GetService("VirtualInputManager")
    local Workspace = game:GetService("Workspace")

    local BoatSpeed = 350

    -- CreateSlider tốc độ thuyền
    o5Tab:CreateSlider({
        Name = "Tốc Độ Thuyền",
        Min = 0,
        Max = 350,
        Default = BoatSpeed,
        Callback = function(v)
            BoatSpeed = v
        end
    })

    -- Toggle tìm đảo dung nham
    o5Tab:CreateToggle({
        Name = "Tìm Đảo Dung Nham",
        Default = false,
        Callback = function(v)
            _G.AutoFindPrehistoric = v
        end
    })

    local BoatSeats = {}
    local Busy = false
    local NotifyFlag = false

    RunService.RenderStepped:Connect(function()

        if not _G.AutoFindPrehistoric then
            NotifyFlag = false
            return
        end

        local plr = Players.LocalPlayer
        local char = plr.Character
        if not char or not char:FindFirstChild("Humanoid") then return end

        local humanoid = char.Humanoid

        -- Tự tìm ghế trống
        local function AutoSit()
            if Busy then return end
            Busy = true
            for _, seat in pairs(BoatSeats) do
                if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
                    Tween2(seat.CFrame)
                    break
                end
            end
            Busy = false
        end

        -- Kiểm tra tất cả thuyền
        local OnBoat = false
        local MyBoatSeat = nil

        for _, boat in pairs(Workspace.Boats:GetChildren()) do
            local seat = boat:FindFirstChild("VehicleSeat")

            if seat then
                if seat.Occupant == humanoid then
                    OnBoat = true
                    MyBoatSeat = seat
                    BoatSeats[boat.Name] = seat
                elseif seat.Occupant == nil then
                    AutoSit()
                end
            end
        end

        if not OnBoat then return end

        -- Điều khiển thuyền
        MyBoatSeat.MaxSpeed = BoatSpeed
        MyBoatSeat.CFrame = CFrame.new(MyBoatSeat.Position) * MyBoatSeat.CFrame.Rotation
        VIM:SendKeyEvent(true, "W", false, game)

        for _, v in pairs(Workspace.Boats:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        -- Xóa các đảo cũ để tìm đảo dung nham
        local HideIslands = {
            "ShipwreckIsland",
            "SandIsland",
            "TreeIsland",
            "TinyIsland",
            "MysticIsland",
            "KitsuneIsland",
            "FrozenDimension"
        }

        for _, island in ipairs(HideIslands) do
            local mdl = Workspace.Map:FindFirstChild(island)
            if mdl and mdl:IsA("Model") then mdl:Destroy() end
        end

        -- Khi tìm thấy đảo dung nham
        local Pre = Workspace.Map:FindFirstChild("PrehistoricIsland")
        if Pre then
            VIM:SendKeyEvent(false, "W", false, game)
            _G.AutoFindPrehistoric = false
            return
        end
    end)

end

local ToggleAutoFindMirage = o5Tab:CreateToggle("AutoFindMirage", {
    Title = "Tìm Đảo Bí Ẩn",
    Description = "",
    Default = false
})

v17.AutoFindMirage:SetValue(false)

ToggleAutoFindMirage:OnChanged(function(state)
    _G.AutoFindMirage = state
end)

local BoatSeatCache = {}
local IsTweeningToBoat = false
local MirageFoundNotified = false

v505.RenderStepped:Connect(function()
    if not _G.AutoFindMirage then
        MirageFoundNotified = false
        return
    end

    local player = v504.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then
        return
    end

    local function MoveToEmptyBoatSeat()
        if IsTweeningToBoat then return end
        IsTweeningToBoat = true

        for _, seat in pairs(BoatSeatCache) do
            if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
                Tween2(seat.CFrame)
                break
            end
        end

        IsTweeningToBoat = false
    end

    local humanoid = character.Humanoid
    local isOnBoat = false
    local currentSeat = nil

    for _, boat in pairs(v507.Boats:GetChildren()) do
        local seat = boat:FindFirstChild("VehicleSeat")

        if seat and seat.Occupant == humanoid then
            isOnBoat = true
            currentSeat = seat
            BoatSeatCache[boat.Name] = seat

        elseif seat and not seat.Occupant then
            MoveToEmptyBoatSeat()
        end
    end

    if not isOnBoat then return end

    -- Boost speed
    currentSeat.MaxSpeed = v508
    currentSeat.CFrame =
        CFrame.new(Vector3.new(
            currentSeat.Position.X,
            currentSeat.Position.Y,
            currentSeat.Position.Z
        )) * currentSeat.CFrame.Rotation

    v506:SendKeyEvent(true, "W", false, game)

    -- No collision
    for _, part in pairs(v507.Boats:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Xoá đảo không quan trọng
    local islandsToDelete = {
        "ShipwreckIsland",
        "SandIsland",
        "TreeIsland",
        "TinyIsland",
        "PrehistoricIsland",
        "KitsuneIsland",
        "FrozenDimension"
    }

    for _, islandName in ipairs(islandsToDelete) do
        local island = v507.Map:FindFirstChild(islandName)
        if island and island:IsA("Model") then
            island:Destroy()
        end
    end

    local MysticIsland = v507.Map:FindFirstChild("MysticIsland")

    if MysticIsland then
        v506:SendKeyEvent(false, "W", false, game)
        _G.AutoFindMirage = false

        -- Notify đã bị xoá theo yêu cầu
        MirageFoundNotified = true

        return
    end
end)

local ToggleAutoFindFrozen = o5Tab:CreateToggle("AutoFindFrozen", {
    Title = "Tìm Đảo Leviathan",
    Description = "Cần 5 Người",
    Default = false
})

v17.AutoFindFrozen:SetValue(false)

ToggleAutoFindFrozen:OnChanged(function(state)
    _G.AutoFindFrozen = state
end)

local BoatSeatCache = {}
local IsTweeningToBoat = false
local FrozenFoundOnce = false

v505.RenderStepped:Connect(function()
    if not _G.AutoFindFrozen then
        FrozenFoundOnce = false
        return
    end

    local player = v504.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then
        return
    end

    local function MoveToEmptyBoatSeat()
        if IsTweeningToBoat then return end
        IsTweeningToBoat = true

        for _, seat in pairs(BoatSeatCache) do
            if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
                Tween2(seat.CFrame)
                break
            end
        end

        IsTweeningToBoat = false
    end

    local humanoid = character.Humanoid
    local isOnBoat = false
    local currentSeat = nil

    for _, boat in pairs(v507.Boats:GetChildren()) do
        local seat = boat:FindFirstChild("VehicleSeat")

        if seat and seat.Occupant == humanoid then
            isOnBoat = true
            currentSeat = seat
            BoatSeatCache[boat.Name] = seat

        elseif seat and not seat.Occupant then
            MoveToEmptyBoatSeat()
        end
    end

    if not isOnBoat then return end

    -- Boost speed
    currentSeat.MaxSpeed = v508
    currentSeat.CFrame = CFrame.new(Vector3.new(
        currentSeat.Position.X,
        currentSeat.Position.Y,
        currentSeat.Position.Z
    )) * currentSeat.CFrame.Rotation

    v506:SendKeyEvent(true, "W", false, game)

    -- No collision
    for _, part in pairs(v507.Boats:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Xoá đảo không liên quan
    local islandsToDelete = {
        "ShipwreckIsland",
        "SandIsland",
        "TreeIsland",
        "TinyIsland",
        "MysticIsland",
        "KitsuneIsland",
        "PrehistoricIsland"
    }

    for _, islandName in ipairs(islandsToDelete) do
        local island = v507.Map:FindFirstChild(islandName)
        if island and island:IsA("Model") then
            island:Destroy()
        end
    end

    -- Kiểm tra Frozen Dimension
    local FrozenDimension = v507.Map:FindFirstChild("FrozenDimension")

    if FrozenDimension then
        v506:SendKeyEvent(false, "W", false, game)
        _G.AutoFindFrozen = false

        -- Notify đã xoá theo yêu cầu
        FrozenFoundOnce = true

        return
    end
end)

local v516 = v16.Sea:CreateToggle("AutoComeTiki", {
    Title = "Lái Thuyền Về Đảo Tiki",
    Description = "",
    Default = false
})
v516:OnChanged(function(v617)
    _G.AutoComeTiki = v617;
end)

v505.RenderStepped:Connect(function()
    if not _G.AutoComeTiki then
        return
    end
    local v618 = v504.LocalPlayer
    local v619 = v618.Character
    if (not v619 or not v619:FindFirstChild("Humanoid")) then
        return
    end
    local v620 = v619.Humanoid
    local v621 = nil
    for v714, v715 in pairs(v507.Boats:GetChildren()) do
        local v716 = v715:FindFirstChild("VehicleSeat")
        if (v716 and (v716.Occupant == v620)) then
            v621 = v716
            break
        end
    end
    if v621 then
        v621.MaxSpeed = v508
        local v776 = CFrame.new(-16217.7568359375, 9.126761436462402, 446.06536865234375)
        local v777 = v621.Position
        local v778 = v776.Position
        local v779 = (v778 - v777).unit
        local v780 = v779 * v621.MaxSpeed * v505.RenderStepped:Wait()
        v621.CFrame = v621.CFrame + v780
        local v782 = CFrame.new(v777, v778)
        v621.CFrame = CFrame.new(v621.Position, v778)
        if ((v621.Position - v778).magnitude < 120) then
            _G.AutoComeTiki = false
            v506:SendKeyEvent(false, "W", false, game)
        end
    end
end)

local v517 = o5Tab:CreateToggle("AutoComeHydra", {
    Title = "Lái Thuyền Về Đảo Hydra",
    Description = "",
    Default = false
})
v517:OnChanged(function(v622)
    _G.AutoComeHydra = v622;
end)

v505.RenderStepped:Connect(function()
    if not _G.AutoComeHydra then
        return
    end
    local v623 = v504.LocalPlayer
    local v624 = v623.Character
    if (not v624 or not v624:FindFirstChild("Humanoid")) then
        return
    end
    local v625 = v624.Humanoid
    local v626 = nil
    for v717, v718 in pairs(v507.Boats:GetChildren()) do
        local v719 = v718:FindFirstChild("VehicleSeat")
        if (v719 and (v719.Occupant == v625)) then
            v626 = v719
            break
        end
    end
    if v626 then
        v626.MaxSpeed = v508
        local v784 = CFrame.new(5193.9375, -0.04690289497375488, 1631.578369140625)
        local v785 = v626.Position
        local v786 = v784.Position
        local v787 = (v786 - v785).unit
        local v788 = v787 * v626.MaxSpeed * v505.RenderStepped:Wait()
        v626.CFrame = v626.CFrame + v788
        v626.CFrame = CFrame.new(v626.Position, v786)
        if ((v626.Position - v786).magnitude < 120) then
            _G.AutoComeHydra = false
            v506:SendKeyEvent(false, "W", false, game)
        end
    end
end)

v16.Sea:CreateButton({
    Title = "Bay Đến Khu Vực Săn",
    Description = "",
    Callback = function()
        Tween2(CFrame.new(-16917.154296875, 7.757596015930176, 511.8203125))
    end
})

local v511 = {}
local v518 = {
    "Beast Hunter",
    "Sleigh",
    "Miracle",
    "The Sentinel",
    "Guardian",
    "Lantern",
    "Dinghy",
    "PirateSloop",
    "PirateBrigade",
    "PirateGrandBrigade",
    "MarineGrandBrigade",
    "MarineBrigade",
    "MarineSloop"
}

local v519 = v16.Sea:CreateDropdown("DropdownBoat", {
    Title = "Chọn Thuyền",
    Description = "",
    Values = v518,
    Multi = false,
    Default = 1
})
v519:SetValue(selectedBoat)
v519:OnChanged(function(v627)
    selectedBoat = v627
end)

local function v520(v628)
    local v629 = {
        [1] = "BuyBoat",
        [2] = v628
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v629))
    task.delay(2, function()
        for v791, v792 in pairs(v507.Boats:GetChildren()) do
            if (v792:IsA("Model") and (v792.Name == v628)) then
                local v896 = v792:FindFirstChild("VehicleSeat")
                if (v896 and not v896.Occupant) then
                    v511[v628] = v896
                end
            end
        end
    end)
end

local function v521()
    for v720, v721 in pairs(v511) do
        if (v721 and v721.Parent and (v721.Name == "VehicleSeat") and not v721.Occupant) then
            Tween2(v721.CFrame)
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    for v722, v723 in pairs(v511) do
        if (v723 and v723.Parent and (v723.Name == "VehicleSeat") and not v723.Occupant) then
            v511[v722] = v723
        end
    end
end)

o5Tab:CreateButton({
    Title = "Mua Thuyền",
    Description = "",
    Callback = function()
        v520(selectedBoat);
     end
})

o5Tab:CreateButton({
    Title = "Bay Đến Thuyền",
    Description = "Duy Nhất Thuyền Bạn Mua Ở Chỗ Chọn",
    Callback = function()
        v521();
    end
})

local v522 = o5Tab:CreateToggle("ToggleTerrorshark", {
    Title = "đánh Cá Mập",
    Description = "",
    Default = false
})
v522:OnChanged(function(v630)
    _G.AutoTerrorshark = v630
end)

v17.ToggleTerrorshark:SetValue(false)

spawn(function()
    while wait() do
        if _G.AutoTerrorshark then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") then
                    for v1444, v1445 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v1445.Name == "Terrorshark" then
                            if v1445:FindFirstChild("Humanoid")
                                and v1445:FindFirstChild("HumanoidRootPart")
                                and v1445.Humanoid.Health > 0 then

                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v1445.HumanoidRootPart.CanCollide = false
                                    v1445.Humanoid.WalkSpeed = 0
                                    v1445.HumanoidRootPart.Size = Vector3.new(60, 60, 60)

                                    Tween(v1445.HumanoidRootPart.CFrame * Pos)
                                until not _G.AutoTerrorshark
                                    or not v1445.Parent
                                    or v1445.Humanoid.Health <= 0
                            end
                        end
                    end

                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") then
                    Tween(game:GetService("ReplicatedStorage").Terrorshark.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                end
            end)
        end
    end
end)

local v523 = o5Tab:CreateToggle("TogglePiranha", {
    Title = "đánh Piranha",
    Description = "",
    Default = false
})
v523:OnChanged(function(v631)
    _G.farmpiranya = v631
end)

v17.TogglePiranha:SetValue(false)

spawn(function()
    while wait() do
        if _G.farmpiranya then
            pcall(function()

                if game:GetService("Workspace").Enemies:FindFirstChild("Piranha") then
                    for v1446, v1447 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v1447.Name == "Piranha" then
                            if v1447:FindFirstChild("Humanoid")
                                and v1447:FindFirstChild("HumanoidRootPart")
                                and v1447.Humanoid.Health > 0 then

                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v1447.HumanoidRootPart.CanCollide = false
                                    v1447.Humanoid.WalkSpeed = 0
                                    v1447.HumanoidRootPart.Size = Vector3.new(60, 60, 60)

                                    Tween(v1447.HumanoidRootPart.CFrame * Pos)
                                until not _G.farmpiranya
                                    or not v1447.Parent
                                    or v1447.Humanoid.Health <= 0
                            end
                        end
                    end

                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Piranha") then
                    Tween(game:GetService("ReplicatedStorage").Piranha.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                end

            end)
        end
    end
end)

local v524 = o5Tab:CreateToggle("ToggleShark", {
    Title = "đánh Cá Con",
    Description = "",
    Default = false
})
v524:OnChanged(function(v632)
    _G.AutoShark = v632
end)

v17.ToggleShark:SetValue(false)

spawn(function()
    while wait() do
        if _G.AutoShark then
            pcall(function()

                if game:GetService("Workspace").Enemies:FindFirstChild("Shark") then
                    for v1448, v1449 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v1449.Name == "Shark" then
                            if v1449:FindFirstChild("Humanoid")
                                and v1449:FindFirstChild("HumanoidRootPart")
                                and v1449.Humanoid.Health > 0 then

                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v1449.HumanoidRootPart.CanCollide = false
                                    v1449.Humanoid.WalkSpeed = 0
                                    v1449.HumanoidRootPart.Size = Vector3.new(60, 60, 60)

                                    Tween(v1449.HumanoidRootPart.CFrame * Pos)

                                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                until not _G.AutoShark
                                    or not v1449.Parent
                                    or v1449.Humanoid.Health <= 0
                            end
                        end
                    end

                else
                    Tween(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

                    if game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") then
                        Tween(game:GetService("ReplicatedStorage").Terrorshark.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end

            end)
        end
    end
end)

local v525 = o5Tab:CreateToggle("ToggleFishCrew", {
    Title = "đánh Tàu Cá",
    Description = "",
    Default = false
})
v525:OnChanged(function(v633)
    _G.AutoFishCrew = v633
end)

v17.ToggleFishCrew:SetValue(false)

spawn(function()
    while wait() do
        if _G.AutoFishCrew then
            pcall(function()

                if game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") then
                    for v1450, v1451 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v1451.Name == "Fish Crew Member" then
                            if v1451:FindFirstChild("Humanoid")
                                and v1451:FindFirstChild("HumanoidRootPart")
                                and v1451.Humanoid.Health > 0 then

                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v1451.HumanoidRootPart.CanCollide = false
                                    v1451.Humanoid.WalkSpeed = 0
                                    v1451.HumanoidRootPart.Size = Vector3.new(60, 60, 60)

                                    Tween(v1451.HumanoidRootPart.CFrame * Pos)

                                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                until not _G.AutoFishCrew
                                    or not v1451.Parent
                                    or v1451.Humanoid.Health <= 0
                            end
                        end
                    end

                else
                    Tween(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

                    if game:GetService("ReplicatedStorage"):FindFirstChild("Fish Crew Member") then
                        Tween(game:GetService("ReplicatedStorage").FishCrewMember.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end

            end)
        end
    end
end)

local v526 = o5Tab:CreateToggle("ToggleShip", {
    Title = "đánh Tàu",
    Description = "",
    Default = false
})
v526:OnChanged(function(v634)
    _G.Ship = v634
end)

v17.ToggleShip:SetValue(false)

function CheckPirateBoat()
    local v635 = {
        "PirateGrandBrigade",
        "PirateBrigade"
    }
    for v724, v725 in next, game:GetService("Workspace").Enemies:GetChildren() do
        if table.find(v635, v725.Name)
            and v725:FindFirstChild("Health")
            and v725.Health.Value > 0 then
            return v725
        end
    end
end

spawn(function()
    while wait() do
        if _G.Ship then
            pcall(function()

                if CheckPirateBoat() then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 32, false, game)
                    wait(0.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 32, false, game)

                    local v1338 = CheckPirateBoat()

                    repeat
                        wait()
                        spawn(Tween(v1338.Engine.CFrame * CFrame.new(0, -20, 0)), 1)
                        AimBotSkillPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                        Skillaimbot = true
                        AutoSkill = false
                    until not v1338
                        or not v1338.Parent
                        or v1338.Health.Value <= 0
                        or not CheckPirateBoat()

                    Skillaimbot = true
                    AutoSkill = false
                end

            end)
        end
    end
end)

local v527 = v16.Sea:CreateToggle("ToggleGhostShip", {
    Title = "đánh Tàu Ma",
    Description = "",
    Default = false
})
v527:OnChanged(function(v636)
    _G.GhostShip = v636
end)

v17.ToggleGhostShip:SetValue(false)

function CheckPirateBoat()
    local v637 = {
        "FishBoat"
    }
    for v726, v727 in next, game:GetService("Workspace").Enemies:GetChildren() do
        if (table.find(v637, v727.Name) and v727:FindFirstChild("Health") and (v727.Health.Value > 0)) then
            return v727
        end
    end
end

spawn(function()
    while wait() do
        pcall(function()
            if _G.bjirFishBoat then
                if CheckPirateBoat() then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 32, false, game)
                    wait()
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 32, false, game)
                    local v1339 = CheckPirateBoat()
                    repeat
                        wait()
                        spawn(Tween(v1339.Engine.CFrame * CFrame.new(0, -20, 0), 1))
                        AutoSkill = true
                        Skillaimbot = true
                        AimBotSkillPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                    until v1339.Parent or (v1339.Health.Value <= 0) or not CheckPirateBoat()
                    AutoSkill = false
                    Skillaimbot = false
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        if _G.bjirFishBoat then
            pcall(function()
                if CheckPirateBoat() then
                    AutoHaki()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))

                    for v1452, v1453 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v1453:IsA("Tool") and v1453.ToolTip == "Melee" then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1453)
                        end
                    end

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game.Players.LocalPlayer.Character.HumanoidRootPart)

                    for v1454, v1455 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v1455:IsA("Tool") and v1455.ToolTip == "Blox Fruit" then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1455)
                        end
                    end

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "V", false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait()

                    for v1456, v1457 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v1457:IsA("Tool") and v1457.ToolTip == "Sword" then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1457)
                        end
                    end

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait()

                    for v1458, v1459 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v1459:IsA("Tool") and v1459.ToolTip == "Gun" then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1459)
                        end
                    end

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    wait(0.2)

                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                end
            end)
        end
    end
end)
