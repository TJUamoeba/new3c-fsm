local IdleState = class('IdleState', PlayerActState)

function IdleState:OnEnter()
    PlayerActState.OnEnter(self)
    localPlayer:MoveTowards(Vector2.Zero)
    localPlayer.Avatar:PlayAnimation('Idle', 2, 1, 0.1, true, true, 1)
end

function IdleState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end

function IdleState:OnLeave()
    PlayerActState.OnLeave(self)
end

return IdleState
