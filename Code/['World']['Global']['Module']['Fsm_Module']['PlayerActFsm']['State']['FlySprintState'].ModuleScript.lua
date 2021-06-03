local FlySprintState = class('FlySprintState', PlayerActState)

function FlySprintState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    local anims = {
        {'anim_woman_flyforward_01', 0.0, 0.0, 1.0},
        {'anim_woman_flyturnleft_01', -1.0, 0.0, 1.0},
        {'anim_woman_flyturnright_01', 1.0, 0.0, 1.0},
        {'anim_woman_flyup_01', 0.0, 1.0, 1.0},
        {'anim_woman_flydown_01', 0.0, -1.0, 1.0}
    }
    self.animNode = PlayerAnimMgr:Create2DClipNode(anims, 'speedX', 'speedY')
end
function FlySprintState:InitData()
    self:AddTransition(
        'ToFlySprintEndState',
        self.controller.states['FlySprintEndState'],
        -1,
        function()
            return not PlayerCtrl.isSprint
        end
    )
    self:AddTransition(
        'ToFlyEndState',
        self.controller.states['FlyEndState'],
        -1,
        function()
            return self:FloorMonitor(0.07)
        end
    )
end

function FlySprintState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, true, 1)
end

function FlySprintState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:SpeedMonitor(localPlayer.MaxFlySpeed)
    self:Fly()
end
function FlySprintState:OnLeave()
    PlayerActState.OnLeave(self)
end

return FlySprintState
