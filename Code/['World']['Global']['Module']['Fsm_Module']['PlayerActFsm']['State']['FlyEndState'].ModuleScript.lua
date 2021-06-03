local FlyEndState = class('FlyEndState', PlayerActState)

function FlyEndState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_hovertoland_02')
end
function FlyEndState:InitData()
    self:AddTransition('IdleState', self.controller.states['IdleState'], 0.8)
end

function FlyEndState:OnEnter()
    PlayerActState.OnEnter(self)
    localPlayer:StopMovementImmediately()
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.15, 0.15, true, false, 1)
end

function FlyEndState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end

function FlyEndState:OnLeave()
    PlayerActState.OnLeave(self)
end

return FlyEndState
