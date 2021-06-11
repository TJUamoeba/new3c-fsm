--- 玩家动作状态
-- @module  PlayerActState
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local PlayerActState = class('PlayerActState', StateBase)

--水体
local waterData = {}

function PlayerActState:initialize(_controller, _stateName)
    print('ControllerBase:initialize()')
    StateBase.initialize(self, _controller, _stateName)
    waterData = {
        rangeMin = world.Water.Position -
            Vector3(world.Water.Size.x / 2, world.Water.Size.y / 2, world.Water.Size.z / 2),
        rangeMax = world.Water.Position +
            Vector3(world.Water.Size.x / 2, world.Water.Size.y / 2, world.Water.Size.z / 2)
    }
end

--获取停步时哪只脚在前以及双脚间距
function PlayerActState:GetStopInfo()
    local lToe = localPlayer.Avatar.Bone_L_Toe0
    local rToe = localPlayer.Avatar.Bone_R_Toe0
    local toeDir = Vector2(lToe.Position.x - rToe.Position.x, lToe.Position.z - rToe.Position.z)
    local fDir = Vector2(localPlayer.Avatar.Forward.x, localPlayer.Avatar.Forward.z)
    local dis = Vector2(lToe.Position.x - rToe.Position.x, lToe.Position.z - rToe.Position.z).Magnitude
    local stopL, stopDis = (Vector2.Angle(toeDir, fDir) < 90), dis
    return stopL, stopDis
end

--确定该播放哪个停步动作
function PlayerActState:GetStopIndex()
    local stopSSpeed = 0.6
    local stopRSpeed = 0.3
    local stopDisGap = 0.7

    local index = 1
    local stopL, stopDis = self:GetStopInfo()
    local speedXZ = math.clamp(localPlayer.Velocity.Magnitude / 12, 0, 1)
    if speedXZ > stopSSpeed then
        if stopDis > stopDisGap then
            index = 3
        else
            index = 3
        end
    elseif speedXZ > stopRSpeed then
        if stopDis > stopDisGap then
            index = 2
        else
            index = 4
        end
    else
        index = 1
    end
    index = index + (stopL and 0 or 4)

    return index, stopL
end

---移动
function PlayerActState:Move(_isSprint)
    _isSprint = _isSprint or false
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if _isSprint then
        if PlayerCtrl.isSprint then
            localPlayer:AddMovementInput(dir, 1)
        else
            localPlayer:AddMovementInput(dir, 0.5)
        end
    else
        localPlayer:AddMovementInput(dir, 0.5)
    end
end

--更新镜头
function PlayerActState:UpdateCam()
    local acceleration = localPlayer:GetCurrentAcceleration().Magnitude
    local fovChange = acceleration / 50 - 0.2
    local fovMax = acceleration * 1.5 + 60
    PlayerCam:CameraFOVZoom(fovChange, fovMax)
end

---游泳
function PlayerActState:Swim(_multiple)
    local lvY = self:MoveMonitor() and math.clamp((PlayerCam.playerGameCam.Forward.y + 0.2), -1, 1) or 0
    if self:IsWaterSuface() and lvY > 0 then
        lvY = 0
        localPlayer.Velocity.y = 0
    end
    if self:FloorMonitor(3) and lvY < 0 then
        lvY = 0
    end
    local dir = Vector3(PlayerCtrl.finalDir.x, lvY, PlayerCtrl.finalDir.z)
    --print(dir)
    localPlayer:AddMovementInput(dir, _multiple or 1)
end

---飞行
function PlayerActState:Fly()
    local lvY = self:MoveMonitor() and math.clamp((PlayerCam.playerGameCam.Forward.y + 0.2), -1, 1) or 0
    local dir = (PlayerCtrl.finalDir + localPlayer.Forward).Normalized
    dir.y = lvY
    dir = dir.Normalized
    if PlayerCtrl.isSprint then
        localPlayer:AddMovementInput(dir, 1)
    else
        localPlayer:AddMovementInput(dir, 0.5)
    end
end

---沉浮
function PlayerActState:UpAndDown()
    local lvY = PlayerCtrl.upright
    if localPlayer:IsSwimming() and localPlayer.Position.y > waterData.rangeMax.y - 2 and lvY > 0 then
        lvY = 0
    end
    localPlayer:AddMovementInput(Vector3(0, lvY, 0))
end

---监听移动
function PlayerActState:MoveMonitor()
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if dir.Magnitude > 0 then
        return true
    else
        return false
    end
end

--监听是否在地面上
function PlayerActState:FloorMonitor(_dis)
    local startPos = localPlayer.Position
    local endPos = localPlayer.Position + Vector3.Down * (_dis or 0.03)
    local hitResult = Physics:RaycastAll(startPos, endPos, true)
    for i, v in pairs(hitResult.HitObjectAll) do
        if v.Block and v ~= localPlayer then
            return true
        end
    end
    return false
end

---监听游泳
function PlayerActState:SwimMonitor()
    if
        localPlayer.Position.x > waterData.rangeMin.x and localPlayer.Position.x < waterData.rangeMax.x and
            localPlayer.Position.y > waterData.rangeMin.y and
            localPlayer.Position.y < waterData.rangeMax.y and
            localPlayer.Position.z > waterData.rangeMin.z and
            localPlayer.Position.z < waterData.rangeMax.z
     then
        if self:FloorMonitor(0.1) and localPlayer.Position.y > waterData.rangeMax.y - 1.5 then
            return false
        end
        return true
    else
        return false
    end
end

---监听速度
function PlayerActState:SpeedMonitor(_maxSpeed)
    local velocity = localPlayer.Velocity
    localPlayer.Avatar:SetParamValue('speedY', math.clamp((velocity.y / 10), -1, 1))
    velocity.y = 0
    localPlayer.Avatar:SetParamValue('speedXZ', math.clamp((velocity.Magnitude / (_maxSpeed or 9)), 0, 1))
    --print(math.clamp((velocity.Magnitude / (_maxSpeed or 9)), 0, 1))
    velocity = math.cos(math.rad(Vector3.Angle(velocity, localPlayer.Left))) * velocity.Magnitude
    localPlayer.Avatar:SetParamValue('speedX', math.clamp((velocity / (_maxSpeed or 9)), -1, 1))
end

---监听下落状态
function PlayerActState:FallMonitor()
    if not self:FloorMonitor(0.5) and localPlayer.Velocity.y < 0.5 then
        self.controller:CallTrigger('JumpHighestState')
    end
end

---是否在水面
function PlayerActState:IsWaterSuface()
    if localPlayer.Position.y > waterData.rangeMax.y - 1.5 then
        return true
    else
        return false
    end
end

function PlayerActState:OnUpdate()
    StateBase.OnUpdate(self)
    self:UpdateCam()
end

return PlayerActState
