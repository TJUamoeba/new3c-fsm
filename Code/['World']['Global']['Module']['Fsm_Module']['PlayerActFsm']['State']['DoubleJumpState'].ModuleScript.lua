local DoubleJumpState = class('DoubleJumpState', PlayerActState)

function DoubleJumpState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_doublejump_01')
end
function DoubleJumpState:InitData()
    self:AddTransition('ToFallState', self.controller.states['FallState'], 0.8)
    self:AddTransition(
        'ToDoubleJumpSprintState',
        self.controller.states['DoubleJumpSprintState'],
        -1,
        function()
            return self.controller.triggers['DoubleJumpSprintState']
        end
    )
end

function DoubleJumpState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, false, 1)
    self.controller.jumpCount = self.controller.jumpCount - 1
    localPlayer:AddImpulse(Vector3(0, 1200, 0))
end

function DoubleJumpState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Move()
end

function DoubleJumpState:OnLeave()
    PlayerActState.OnLeave(self)
end

return DoubleJumpState
