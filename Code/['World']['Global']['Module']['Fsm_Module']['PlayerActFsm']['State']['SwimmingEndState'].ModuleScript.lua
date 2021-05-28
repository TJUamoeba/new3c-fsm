local SwimmingEndState = class('SwimmingEndState', PlayerActState)

function SwimmingEndState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animFreestyleNode = PlayerAnimMgr:CreateSingleClipNode('anim_human_freestyletoidle_01')
    self.animBreaststrokeNode = PlayerAnimMgr:CreateSingleClipNode('anim_human_breaststroketoidle_01')
end

function SwimmingEndState:InitData()
    self:AddTransition('ToSwimIdleState', self.controller.states['SwimIdleState'], 0.5)
    self:AddTransition(
        'ToIdleState',
        self.controller.states['IdleState'],
        -1,
        function()
            return not self:SwimMonitor()
        end
    )
end

function SwimmingEndState:OnEnter()
    PlayerActState.OnEnter(self)
    if self:IsWaterSuface() then
        PlayerAnimMgr:Play(self.animFreestyleNode, 0, 1, 0.1, 0.1, true, false, 1)
    else
        PlayerAnimMgr:Play(self.animBreaststrokeNode, 0, 1, 0.1, 0.1, true, false, 1)
    end
end

function SwimmingEndState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Swim(0.1)
end

function SwimmingEndState:OnLeave()
    PlayerActState.OnLeave(self)
end

return SwimmingEndState
