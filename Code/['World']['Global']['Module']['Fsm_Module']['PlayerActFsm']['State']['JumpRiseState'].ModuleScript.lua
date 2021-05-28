local JumpRiseState = class('JumpRiseState', PlayerActState)

function JumpRiseState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    local anims = {
        {'anim_woman_jump_riseuploop_01', 0.0, 1.0},
        {'anim_woman_jumpforward_riseuploop_02', 0.5, 1.0}
    }
    self.animNode = PlayerAnimMgr:Create1DClipNode(anims, 'speedXZ')
end
function JumpRiseState:InitData()
    self:AddTransition('ToJumpHighestState', self.controller.states['JumpHighestState'], 0.1)
end

function JumpRiseState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.1, 0.1, true, true, 1)
end

function JumpRiseState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:FallMonitor()
    self:Move()
    self:SpeedMonitor()
end

function JumpRiseState:OnLeave()
    PlayerActState.OnLeave(self)
end

return JumpRiseState
