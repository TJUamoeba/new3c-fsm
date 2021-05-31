local CrouchBeginState = class('CrouchBeginState', PlayerActState)

function CrouchBeginState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_standtocrouch_01')
end
function CrouchBeginState:InitData()
    self:AddTransition('ToCrouchIdleState', self.controller.states['CrouchIdleState'], 0.1)
end

function CrouchBeginState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.1, 0.1, true, false, 1)
end

function CrouchBeginState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end

function CrouchBeginState:OnLeave()
    PlayerActState.OnLeave(self)
end

return CrouchBeginState
