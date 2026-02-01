local RunService = game:GetService("RunService")

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = game:GetService("Players")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()
local Confirmed = false

WindUI:Popup({
    Title = 'TnineHub',
    IconThemed = true,
    Icon = "crown",
    Content = "凌乱自制 想要更多自制脚本加入Q群717897412",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行脚本",
            Icon = "arrow-right",
            Callback = function()
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})

local sixPathsModule = {
    enabled = false,
    connection = nil,
    
    start = function(self)
        if self.connection then
            self.connection:Disconnect()
        end
        
        self.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if self.enabled then
                local players = Players:GetPlayers()
                local localPlayer = Players.LocalPlayer
                
                for _, player in ipairs(players) do
                    if player ~= localPlayer then
                        local args = {[1] = 99999999}
                        game:GetService("ReplicatedStorage").events.SendSlap:FireServer(unpack(args))
                    end
                end
                wait(0.00000000000001)
            end
        end)
    end,
    
    stop = function(self)
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
    end
}

local onePunchModule = {
    enabled = false,
    connection = nil,
    
    start = function(self)
        if self.connection then
            self.connection:Disconnect()
        end
        
        self.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if self.enabled then
                local players = Players:GetPlayers()
                local localPlayer = Players.LocalPlayer
                
                for _, player in ipairs(players) do
                    if player ~= localPlayer then
                        local args = {[1] = 0.9995162487030029}
                        game:GetService("ReplicatedStorage").events.SendSlap:FireServer(unpack(args))
                    end
                end
                wait(1)
            end
        end)
    end,
    
    stop = function(self)
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
    end
}

local infiniteSlapModule = {
    enabled = false,
    connection = nil,
    
    start = function(self)
        if self.connection then
            self.connection:Disconnect()
        end
        
        self.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if self.enabled then
                game:GetService("ReplicatedStorage").events.SlapQueue:FireServer()
                wait(0.01)
            end
        end)
    end,
    
    stop = function(self)
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
    end
}

local attackerDetection = {
    lastAttacker = nil,
    lastAttackedTime = 0,
    connection = nil,
    
    start = function(self)
        if self.connection then
            self.connection:Disconnect()
        end
        
        self.connection = game:GetService("RunService").Heartbeat:Connect(function()
            local localPlayer = Players.LocalPlayer
            local character = localPlayer.Character
            
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local currentHealth = humanoid.Health
                    local maxHealth = humanoid.MaxHealth
                    
                    if currentHealth < maxHealth then
                        local players = Players:GetPlayers()
                        local closestPlayer = nil
                        local closestDistance = math.huge
                        local localPos = character:GetPivot().Position
                        
                        for _, player in ipairs(players) do
                            if player ~= localPlayer then
                                local targetChar = player.Character
                                if targetChar then
                                    local targetPos = targetChar:GetPivot().Position
                                    local distance = (localPos - targetPos).Magnitude
                                    
                                    if distance < 50 and distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                        
                        if closestPlayer then
                            self.lastAttacker = closestPlayer
                            self.lastAttackedTime = tick()
                        end
                    end
                end
            end
        end)
    end,
    
    stop = function(self)
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
    end,
    
    getLastAttacker = function(self)
        if self.lastAttacker and tick() - self.lastAttackedTime < 5 then
            return self.lastAttacker
        end
        return nil
    end
}

local undergroundModule = {
    enabled = false,
    connection = nil,
    undergroundPosition = Vector3.new(0, -100, 0), 
    originalPosition = nil, 
    undergroundTimer = nil, 
    isUnderground = false, 
    
    start = function(self)
        if self.connection then
            self.connection:Disconnect()
        end
        
        self.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if self.enabled then
                local localPlayer = Players.LocalPlayer
                local character = localPlayer.Character
                
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local currentHealth = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        
                        if currentHealth < maxHealth and not self.isUnderground then
                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                self.originalPosition = rootPart.CFrame
                                rootPart.CFrame = CFrame.new(self.undergroundPosition)
                                self.isUnderground = true
                                
                                if self.undergroundTimer then
                                    self.undergroundTimer:Disconnect()
                                end
                                
                                self.undergroundTimer = game:GetService("RunService").Heartbeat:Connect(function()
                                    wait(10) 
                                    if self.enabled and self.isUnderground and character and rootPart then
                                        if self.originalPosition then
                                            rootPart.CFrame = self.originalPosition
                                        else
                                            rootPart.CFrame = CFrame.new(0, 5, 0)
                                        end
                                        self.isUnderground = false
                                        self.originalPosition = nil
                                    end
                                    self.undergroundTimer:Disconnect()
                                    self.undergroundTimer = nil
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end,
    
    stop = function(self)
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
        if self.undergroundTimer then
            self.undergroundTimer:Disconnect()
            self.undergroundTimer = nil
        end
        
        if self.isUnderground then
            local localPlayer = Players.LocalPlayer
            local character = localPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    if self.originalPosition then
                        rootPart.CFrame = self.originalPosition
                    else
                        rootPart.CFrame = CFrame.new(0, 5, 0)
                    end
                end
            end
            self.isUnderground = false
            self.originalPosition = nil
        end
    end
}

function createUI()
    local Window = WindUI:CreateWindow({
        Title = 'TnineHub-猜猜小偷',
        Icon = "https://raw.githubusercontent.com/tnine-n9/tnine_Hub/refs/heads/main/retouch_2026012321291407.png",
        IconThemed = true,
        Author = "by凌乱",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(500, 390),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/tnine-n9/tnine_Hub/refs/heads/main/IMG_20260129_204606.jpg",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己的头像",
                    Content = "没什么",
                    Duration = 1,
                    Icon = "4483362748"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索功能",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button",
                    Text = "",
                    Style = "Subtle",
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })
    
    Window:EditOpenButton({
        Title = "tnine user",
        Icon = "https://raw.githubusercontent.com/tnine-n9/tnine_Hub/refs/heads/main/retouch_2026012321291407.png",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 1.25,
        Color = ColorSequence.new(Color3.fromHex("00FFFF")),
        Draggable = true,
    })
    
    Window:Tag({
        Title = "tnine team",
        Color = Color3.fromHex("#00FFFF")
    })
    
    Window:Tag({
        Title = "雄狮",
        Color = Color3.fromHex("#00FFFF")
    })

    local SixPathsTab = Window:Tab({
        Title = "超快速连抽",
        Desc = "直接抽死",
        Icon = "crown",
        IconColor = Color3.fromHex("#FF0000"),
        IconShape = "Square",
        Border = true,
    })

    SixPathsTab:Section({
        Title = "超快速连抽",
    })

    SixPathsTab:Toggle({
        Title = "开关",
        Description = "开启/关闭快速连抽",
        Default = false,
        Callback = function(enabled)
            sixPathsModule.enabled = enabled
            if enabled then
                sixPathsModule:start()
            else
                sixPathsModule:stop()
            end
        end
    })

    local OnePunchTab = Window:Tab({
        Title = "一拳超人",
        Desc = "一拳超人循环攻击",
        Icon = "crown",
        IconColor = Color3.fromHex("#00FF00"),
        IconShape = "Square",
        Border = true,
    })

    OnePunchTab:Section({
        Title = "一拳超人",
    })

    OnePunchTab:Toggle({
        Title = "开关",
        Description = "开启/关闭一拳超人攻击",
        Default = false,
        Callback = function(enabled)
            onePunchModule.enabled = enabled
            if enabled then
                onePunchModule:start()
            else
                onePunchModule:stop()
            end
        end
    })

    local GuessTab = Window:Tab({
        Title = "猜玩家",
        Desc = "自动猜服务器中的玩家",
        Icon = "crown",
        IconColor = Color3.fromHex("#00AAFF"),
        IconShape = "Square",
        Border = true,
    })

    GuessTab:Section({
        Title = "猜玩家功能",
    })

    local attackerInfo = GuessTab:Section({
        Title = "攻击者：无",
        TextSize = 14,
        FontWeight = Enum.FontWeight.Medium,
    })

    local autoGuessEnabled = false
    local autoGuessConnection = nil

    local function getSortedPlayersByDistance()
        local players = Players:GetPlayers()
        local localPlayer = Players.LocalPlayer
        local localChar = localPlayer.Character
        local sortedPlayers = {}
        
        if not localChar then return players end
        
        local localPos = localChar:GetPivot().Position
        
        for _, player in ipairs(players) do
            if player ~= localPlayer then
                local targetChar = player.Character
                if targetChar then
                    local targetPos = targetChar:GetPivot().Position
                    local distance = (localPos - targetPos).Magnitude
                    table.insert(sortedPlayers, {
                        player = player,
                        distance = distance
                    })
                else
                    table.insert(sortedPlayers, {
                        player = player,
                        distance = math.huge
                    })
                end
            end
        end
        
        table.sort(sortedPlayers, function(a, b)
            return a.distance < b.distance
        end)
        
        return sortedPlayers
    end

    local function updateAttackerInfo()
        local attacker = attackerDetection:getLastAttacker()
        if attacker then
            attackerInfo:SetTitle("攻击玩家：" .. attacker.Name)
        else
            attackerInfo:SetTitle("攻击玩家：无")
        end
    end

    local function guessAttackerFirst()
        local attacker = attackerDetection:getLastAttacker()
        if attacker then
            local args = {[1] = attacker.Name}
            game:GetService("ReplicatedStorage").events.Guess:FireServer(unpack(args))
            return true
        end
        return false
    end

    GuessTab:Toggle({
        Title = "自动猜人开关",
        Description = "开启后按距离优先自动猜人",
        Default = false,
        Callback = function(enabled)
            autoGuessEnabled = enabled
            
            if enabled then
                attackerDetection:start()
                
                autoGuessConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if not autoGuessEnabled then return end
                    
                    local guessed = guessAttackerFirst()
                    
                    if not guessed then
                        local sortedPlayers = getSortedPlayersByDistance()
                        
                        for _, data in ipairs(sortedPlayers) do
                            if data.player and data.distance < 100 then
                                local args = {[1] = data.player.Name}
                                game:GetService("ReplicatedStorage").events.Guess:FireServer(unpack(args))
                                wait(0.2)
                                break
                            end
                        end
                    end
                    
                    updateAttackerInfo()
                end)
            else
                if autoGuessConnection then
                    autoGuessConnection:Disconnect()
                    autoGuessConnection = nil
                end
                attackerDetection:stop()
                attackerInfo:SetTitle("攻击者：无")
            end
        end
    })

    GuessTab:Button({
        Title = "猜最近玩家",
        Description = "只猜距离最近的玩家",
        Callback = function()
            local sortedPlayers = getSortedPlayersByDistance()
            
            if #sortedPlayers > 0 then
                local nearestPlayer = sortedPlayers[1].player
                local args = {[1] = nearestPlayer.Name}
                game:GetService("ReplicatedStorage").events.Guess:FireServer(unpack(args))
            end
        end
    })

    GuessTab:Toggle({
        Title = "自动传送地下(10秒返回)",
        Description = "10秒后回到地面",
        Default = false,
        Callback = function(enabled)
            undergroundModule.enabled = enabled
            if enabled then
                undergroundModule:start()
            else
                undergroundModule:stop()
            end
        end
    })

    local InfiniteSlapTab = Window:Tab({
        Title = "无限抢人头",
        Desc = "无限触发SlapQueue事件",
        Icon = "crown",
        IconColor = Color3.fromHex("#FF00FF"),
        IconShape = "Square",
        Border = true,
    })

    InfiniteSlapTab:Section({
        Title = "无限抢人头",
    })

    InfiniteSlapTab:Toggle({
        Title = "无限抢人头开关",
        Description = "开启后自动快速触发SlapQueue事件",
        Default = false,
        Callback = function(enabled)
            infiniteSlapModule.enabled = enabled
            if enabled then
                infiniteSlapModule:start()
            else
                infiniteSlapModule:stop()
            end
        end
    })

    local AboutTab = Window:Tab({
        Title = "About 雄狮",
        Desc = "凌乱牛逼", 
        Icon = "solar:info-square-bold",
        IconColor = Color3.fromHex("#83889E"),
        IconShape = "Square",
        Border = true,
    })

    AboutTab:Section({
        Title = "About 雄狮",
    })

    AboutTab:Image({
        Image = "https://raw.githubusercontent.com/tnine-n9/tnine_Hub/refs/heads/main/Image_1769596721060_218.jpg",
        AspectRatio = "16:9",
        Radius = 9,
    })

    AboutTab:Space({ Columns = 3 })

    AboutTab:Section({
        Title = "什么是雄狮",
        TextSize = 24,
        FontWeight = Enum.FontWeight.SemiBold,
    })

    AboutTab:Space()

    AboutTab:Section({
        Title = "是由messy和龙王组成的一个强大团队",
        TextSize = 18,
        TextTransparency = .35,
        FontWeight = Enum.FontWeight.Medium,
    })

    AboutTab:Space({ Columns = 4 })

    AboutTab:Button({
        Title = "关闭所有功能并销毁UI",
        Color = Color3.fromHex("#ff4830"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            sixPathsModule:stop()
            onePunchModule:stop()
            infiniteSlapModule:stop()
            attackerDetection:stop()
            undergroundModule:stop()
            if autoGuessConnection then
                autoGuessConnection:Disconnect()
            end
            Window:Destroy()
        end
    })
end