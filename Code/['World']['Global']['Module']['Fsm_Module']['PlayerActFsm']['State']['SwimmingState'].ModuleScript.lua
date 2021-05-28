local SwimmingState = class('SwimmingState', PlayerActState)

local isSufaceWater = true

function SwimmingState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animFreestyleNode = PlayerAnimMgr:CreateSingleClipNode('anim_human_swim_freestyle_01')
    self.animBreaststrokeNode = PlayerAnimMgr:CreateSingleClipNode('anim_human_swim_breaststroke_01')
end

function SwimmingState:InitData()
    self:AddTransition(
        'ToSwimmingEndState',
        self.controller.states['SwimmingEndState'],
        -1,
        function()
            return not self:MoveMonitor()
        end
    )
    self:AddTransition(
        'ToIdleState',
        self.controller.states['IdleState'],
        -1,
        function()
            return not self:SwimMonitor()
        end
    )
end

function SwimmingState:OnEnter()
    PlayerActState.OnEnter(self)
    isSufaceWater = self:IsWaterSuface()
    if isSufaceWater then
        PlayerAnimMgr:Play(self.animFreestyleNode, 0, 1, 0.3, 0.3, true, true, 1)
    else
        PlayerAnimMgr:Play(self.animBreaststrokeNode, 0, 1, 0.3, 0.3, true, true, 1)
    end
end

function SwimmingState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Swim()
    if isSufaceWater ~= self:IsWaterSuface() then
        self:OnEnter()
    end
end

function SwimmingState:OnLeave()
    PlayerActState.OnLeave(self)
end

return SwimmingState
