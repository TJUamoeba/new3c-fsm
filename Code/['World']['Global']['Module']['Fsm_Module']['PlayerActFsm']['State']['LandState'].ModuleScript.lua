local LandState = class('LandState', PlayerActState)

function LandState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animIdleNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_jumptoidle_01')
    self.animMoveNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_jumpforwardtorun_01')
end
function LandState:InitData()
    self:AddTransition(
        'ToFlyBeginState',
        self.controller.states['FlyBeginState'],
        -1,
        function()
            return self.controller.triggers['FlyBeginState']
        end
    )
end

function LandState:OnEnter()
    PlayerActState.OnEnter(self)
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if dir.Magnitude > 0 then
        self:AddTransition('ToMoveState', self.controller.states['MoveState'], 0.4)
        PlayerAnimMgr:Play(self.animMoveNode, 0, 1, 0.1, 0.1, true, false, 0.8)
    else
        self:AddTransition('ToIdleState', self.controller.states['IdleState'], 0.3)
        self:AddTransition(
            'ToMoveState',
            self.controller.states['MoveState'],
            -1,
            function()
                return self:MoveMonitor()
            end
        )
        PlayerAnimMgr:Play(self.animIdleNode, 0, 1, 0.1, 0.1, true, false, 1)
    end
end

function LandState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Move()
end

function LandState:OnLeave()
    PlayerActState.OnLeave(self)
    self.transitions = {}
end

return LandState
