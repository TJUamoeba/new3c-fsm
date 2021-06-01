local FlyMoveState = class('FlyMoveState', PlayerActState)

function FlyMoveState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
     --   {'anim_woman_hoveridle_02', 0.8, 1.0}
    local anims = {
        {'anim_woman_hoveridle_01', 0.0, 1.0},
        {'anim_woman_hoverforward_01', 0.5, 1.0}
    }
    self.animNode = PlayerAnimMgr:Create1DClipNode(anims, 'speedXZ')
end
function FlyMoveState:InitData()
    self:AddTransition(
        'ToFlyIdleState',
        self.controller.states['FlyIdleState'],
        -1,
        function()
            return not self:MoveMonitor()
        end
    )
    self:AddTransition(
        'ToFlyEndState',
        self.controller.states['FlyEndState'],
        -1,
        function()
            return self:FloorMonitor(0.05)
        end
    )
    self:AddTransition(
        'ToFlySprintBeginState',
        self.controller.states['FlySprintBeginState'],
        -1,
        function()
            return PlayerCtrl.isSprint
        end
    )
end

function FlyMoveState:OnEnter()
    PlayerActState.OnEnter(self)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, true, 1)
end

function FlyMoveState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:SpeedMonitor()
    self:Fly()
end
function FlyMoveState:OnLeave()
    PlayerActState.OnLeave(self)
end

return FlyMoveState
