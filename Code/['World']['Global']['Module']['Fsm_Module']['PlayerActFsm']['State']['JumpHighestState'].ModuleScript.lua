local JumpHighestState = class('JumpHighestState', PlayerActState)

function JumpHighestState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    local anims = {
        {'anim_woman_jumpforward_highest_01', 0.0, 1.0},
        {'anim_woman_jumpforward_highest_02', 0.3, 1.0}
    }
    self.animNode = PlayerAnimMgr:Create1DClipNode(anims, 'speedXZ')
end
function JumpHighestState:InitData()
    self:AddTransition('ToFallState', self.controller.states['FallState'], 0.5)
end

function JumpHighestState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.1, 0.1, true, false, 1)
end

function JumpHighestState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Move()
end

function JumpHighestState:OnLeave()
    PlayerActState.OnLeave(self)
end

return JumpHighestState
