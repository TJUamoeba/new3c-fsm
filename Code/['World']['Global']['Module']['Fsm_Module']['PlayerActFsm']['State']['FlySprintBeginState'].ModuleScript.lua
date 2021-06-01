local FlySprintBeginState = class('FlySprintBeginState', PlayerActState)

function FlySprintBeginState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.animNode = PlayerAnimMgr:CreateSingleClipNode('anim_woman_hovertofly_01')
    self.animNode:AddAnimationEvent(0.5):Connect(
        function()
            if self:MoveMonitor() then
                localPlayer:AddImpulse(localPlayer.Forward * 500)
            end
        end
    )
end
function FlySprintBeginState:InitData()
    self:AddTransition('ToFlySprintState', self.controller.states['FlySprintState'], 0.6)
    self:AddTransition(
        'ToFlyEndState',
        self.controller.states['FlyEndState'],
        -1,
        function()
            return self:FloorMonitor(0.05)
        end
    )
end

function FlySprintBeginState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, false, 0.8)
end

function FlySprintBeginState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:Fly(0.3)
    self:SpeedMonitor()
end

function FlySprintBeginState:OnLeave()
    PlayerActState.OnLeave(self)
end

return FlySprintBeginState
