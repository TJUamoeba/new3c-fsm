local FlySprintEndState = class('FlySprintEndState', PlayerActState)

function FlySprintEndState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_flytohover_01')
end
function FlySprintEndState:InitData()
    self:AddTransition('FlyMoveState', self.controller.states['FlyMoveState'], 0.5)
    self:AddTransition(
        'ToFlySprintEndState',
        self.controller.states['FlySprintEndState'],
        -1,
        function()
            return self:FloorMonitor(0.05)
        end
    )
end

function FlySprintEndState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, false, 1)
end

function FlySprintEndState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Fly(0.3)
end

function FlySprintEndState:OnLeave()
    PlayerActState.OnLeave(self)
end

return FlySprintEndState
