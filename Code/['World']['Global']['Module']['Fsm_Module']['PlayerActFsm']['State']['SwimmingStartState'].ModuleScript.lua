local SwimmingStartState = class('SwimmingStartState', PlayerActState)

function SwimmingStartState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animFreestyleNode = PlayerAnimMgr:CreateSingleClipNode('anim_human_idletofreestyle_01')
    self.animBreaststrokeNode = PlayerAnimMgr:CreateSingleClipNode('anim_human_idletobreaststroke_01')
end

function SwimmingStartState:InitData()
    self:AddTransition('ToSwimmingState', self.controller.states['SwimmingState'], 1)
    self:AddTransition(
        'ToIdleState',
        self.controller.states['IdleState'],
        -1,
        function()
            return not self:SwimMonitor()
        end
    )
    self:AddTransition(
        'ToSwimIdleState',
        self.controller.states['SwimIdleState'],
        -1,
        function()
            return not self:MoveMonitor()
        end
    )
end

function SwimmingStartState:OnEnter()
    PlayerActState.OnEnter(self)
    if self:IsWaterSuface() then
        print('Freestyle')
        PlayerAnimMgr:Play(self.animFreestyleNode, 0, 1, 0.1, 0.1, true, false, 1)
    else
        PlayerAnimMgr:Play(self.animBreaststrokeNode, 0, 1, 0.1, 0.1, true, false, 1.5)
    end
end

function SwimmingStartState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Swim(0.1)
end

function SwimmingStartState:OnLeave()
    PlayerActState.OnLeave(self)
    localPlayer:AddImpulse(localPlayer.Forward * 400)
end

return SwimmingStartState
