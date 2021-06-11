--- 玩家动作状态
-- @module  PlayerActState
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local PlayerActState = class('PlayerActState', StateBase)

function PlayerActState:initialize(_controller, _stateName)
    print('ControllerBase:initialize()')
    StateBase.initialize(self, _controller, _stateName)
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

---监听速度
function PlayerActState:SpeedMonitor(_maxSpeed)
    local velocity = localPlayer.Velocity
    localPlayer.Avatar:SetParamValue('speedY', math.clamp((velocity.y / 10), -1, 1))
    velocity.y = 0
    localPlayer.Avatar:SetParamValue(
        'speedXZ',
        math.clamp((velocity.Magnitude / (_maxSpeed or localPlayer.MaxWalkSpeed)), 0, 1)
    )
    --print(math.clamp((velocity.Magnitude / (_maxSpeed or 9)), 0, 1))
    velocity = math.cos(math.rad(Vector3.Angle(velocity, localPlayer.Left))) * velocity.Magnitude
    localPlayer.Avatar:SetParamValue('speedX', math.clamp((velocity / (_maxSpeed or localPlayer.MaxWalkSpeed)), -1, 1))
end

---监听下落状态
function PlayerActState:FallMonitor()
    if not self:FloorMonitor(0.5) and localPlayer.Velocity.y < 0.5 then
        self.controller:CallTrigger('JumpHighestState')
    end
end

function PlayerActState:OnUpdate()
    StateBase.OnUpdate(self)
end

return PlayerActState
