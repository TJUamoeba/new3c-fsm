local FlyBeginState = class('FlyBeginState', PlayerActState)

function FlyBeginState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_jumptohover_01')
end
function FlyBeginState:InitData()
    self:AddTransition('ToJumpRiseState', self.controller.states['JumpRiseState'], 0.1)
end

function FlyBeginState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.05, 0.05, true, false, 1)
end

function FlyBeginState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end

function FlyBeginState:OnLeave()
    PlayerActState.OnLeave(self)
    self:LaunchCharacter(Vector3(0, 5, 0), false, true)
end

return FlyBeginState
