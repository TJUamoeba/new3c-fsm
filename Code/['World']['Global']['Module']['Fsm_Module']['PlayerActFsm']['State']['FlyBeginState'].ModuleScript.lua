local FlyBeginState = class('FlyBeginState', PlayerActState)

function FlyBeginState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_jumptohover_01')
end
function FlyBeginState:InitData()
    self:AddTransition('ToFlyIdleState', self.controller.states['FlyIdleState'], 0.2)
end

function FlyBeginState:OnEnter()
    PlayerActState.OnEnter(self)
    localPlayer:StopMovementImmediately()
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.1, 0.1, true, false, 1)
end

function FlyBeginState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end

function FlyBeginState:OnLeave()
    PlayerActState.OnLeave(self)
    localPlayer:AddImpulse(Vector3(0, 100, 0))
end

return FlyBeginState
