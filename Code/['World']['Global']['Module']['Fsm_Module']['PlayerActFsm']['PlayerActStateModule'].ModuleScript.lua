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
    print(world.Water.Position, world.Water.Size)
    waterData = {
        rangeMin = world.Water.Position -
            Vector3(world.Water.Size.x / 2, world.Water.Size.y / 2, world.Water.Size.z / 2),
        rangeMax = world.Water.Position +
            Vector3(world.Water.Size.x / 2, world.Water.Size.y / 2, world.Water.Size.z / 2)
    }
end

---移动
function PlayerActState:Move(_multiple)
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if _multiple then
        _multiple = _multiple * 0.6
    else
        _multiple = 0.6
    end

    _multiple = PlayerCtrl.isSprint and _multiple / 0.6 or _multiple
    local velocity = localPlayer.Velocity
    velocity.y = 0
    if math.clamp((velocity.Magnitude / 9), 0, 1) > 0.61 and PlayerCtrl.isSprint == false then
        localPlayer:AddMovementInput(Vector3.Zero, _multiple)
    else
        localPlayer:AddMovementInput(dir, _multiple)
    end
end

---游泳
function PlayerActState:Swim(_multiple)
    local lvY = self:MoveMonitor() and math.clamp((PlayerCam.playerGameCam.Forward.y + 0.2), -1, 1) or 0
    if self:IsWaterSuface() and lvY > 0 then
        lvY = 0
    end
    local dir = Vector3(PlayerCtrl.finalDir.x, lvY, PlayerCtrl.finalDir.z)
    --print(dir)
    localPlayer:AddMovementInput(dir, _multiple or 1)
end

---沉浮
function PlayerActState:UpAndDown()
    local lvY = PlayerCtrl.upright
    if localPlayer.Position.y > waterData.rangeMax.y - 3 and lvY > 0 then
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

---监听游泳
function PlayerActState:SwimMonitor()
    if
        localPlayer.Position.x > waterData.rangeMin.x and localPlayer.Position.x < waterData.rangeMax.x and
            localPlayer.Position.y > waterData.rangeMin.y and
            localPlayer.Position.y < waterData.rangeMax.y - 1 and
            localPlayer.Position.z > waterData.rangeMin.z and
            localPlayer.Position.z < waterData.rangeMax.z
     then
        return true
    else
        localPlayer.CharacterWidth = 0.5
        localPlayer.CharacterHeight = 1.7
        localPlayer.Avatar.LocalPosition = Vector3.Zero
        localPlayer:SetSwimming(false)
        return false
    end
end

---监听速度
function PlayerActState:SpeedMonitor()
    local velocity = localPlayer.Velocity
    localPlayer.Avatar:SetParamValue('speedY', math.clamp((velocity.y / 10), -1, 1))
    velocity.y = 0
    localPlayer.Avatar:SetParamValue('speedXZ', math.clamp((velocity.Magnitude / 9), 0, 1))
end

---监听空中状态
function PlayerActState:FallMonitor()
    if not localPlayer.IsOnGround and localPlayer.Velocity.y < 0.5 then
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
end

return PlayerActState
