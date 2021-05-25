--- 玩家动作状态
-- @module  PlayerActState
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local PlayerActState = class('PlayerActState', StateBase)

function PlayerActState:initialize(_controller, _stateName)
    print('ControllerBase:initialize()')
    StateBase.initialize(self, _controller, _stateName)
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
    localPlayer:AddMovementInput(dir, _multiple)
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

---监听速度
function PlayerActState:SpeedMonitor()
    localPlayer.Avatar:SetParamValue('speedXZ', math.clamp((localPlayer.Velocity.Magnitude / 9), 0, 1))
end

---监听空中状态
function PlayerActState:FallMonitor()
    if not localPlayer.IsOnGround and localPlayer.Velocity.y < 0.5 then
        self.controller:CallTrigger('JumpHighestState')
    end
end

function PlayerActState:OnUpdate()
    print(localPlayer.Velocity.Magnitude)
    StateBase.OnUpdate(self)
end

return PlayerActState
