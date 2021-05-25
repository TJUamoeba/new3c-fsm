local IdleState = class('IdleState', PlayerActState)

function IdleState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_idle_01')
end

function IdleState:InitData()
    self:AddTransition(
        'ToMoveState',
        self.controller.states['MoveState'],
        -1,
        function()
            return self:MoveMonitor()
        end
    )
    self:AddTransition(
        'ToJumpBeginState',
        self.controller.states['JumpBeginState'],
        -1,
        function()
            return self.controller.triggers['JumpBeginState']
        end
    )
end

function IdleState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, true, 1)
    self:FallMonitor()
end

function IdleState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end

function IdleState:OnLeave()
    PlayerActState.OnLeave(self)
end

return IdleState
