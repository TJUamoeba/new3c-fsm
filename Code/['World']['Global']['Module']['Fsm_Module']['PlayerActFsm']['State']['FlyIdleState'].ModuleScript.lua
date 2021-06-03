local FlyIdleState = class('FlyIdleState', PlayerActState)

function FlyIdleState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    local anims = {
        {'anim_woman_hoveridle_01', 0.0, 1.0},
        {'anim_woman_hoverup_01', 0.5, 1.0},
        {'anim_woman_hoverdown_01', -0.5, 1.0}
    }
    self.animNode = PlayerAnimMgr:Create1DClipNode(anims, 'speedY')
end
function FlyIdleState:InitData()
    self:AddTransition(
        'ToFlyMoveState',
        self.controller.states['FlyMoveState'],
        -1,
        function()
            return self:MoveMonitor()
        end
    )
    self:AddTransition(
        'ToFlyEndState',
        self.controller.states['FlyEndState'],
        -1,
        function()
            return self:FloorMonitor()
        end
    )
end

function FlyIdleState:OnEnter()
    PlayerActState.OnEnter(self)
    localPlayer:SetMovementMode(Enum.MovementMode.MOVE_Flying)
    localPlayer.RotationRate = EulerDegree(0, 250, 0)
    PlayerAnimMgr:Play(self.animNode, 0, 1, 0.2, 0.2, true, true, 0.5)
end

function FlyIdleState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:SpeedMonitor()
    self:UpAndDown()
end
function FlyIdleState:OnLeave()
    PlayerActState.OnLeave(self)
end

return FlyIdleState
