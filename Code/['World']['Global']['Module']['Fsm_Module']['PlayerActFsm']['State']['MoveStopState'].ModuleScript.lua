local MoveStopState = class('MoveStopState', PlayerActState)

function MoveStopState:initialize(_controller, _stateName)
    PlayerActState.initialize(self, _controller, _stateName)
    self.anims = {
        {'stopLW', 'anim_woman_stop_l_05', 0.2, 1.0},
        {'stopLR1', 'anim_woman_stop_l_03', 0.1, 1.0},
        {'stopLS', 'anim_woman_stop_l_07', 0.2, 1.0},
        {'stopLR2', 'anim_woman_stop_l_06', 0.1, 1.0},
        {'stopRW', 'anim_woman_stop_r_05', 0.2, 1.0},
        {'stopRR1', 'anim_woman_stop_r_03', 0.1, 1.0},
        {'stopRS', 'anim_woman_stop_r_07', 0.2, 1.0},
        {'stopRR2', 'anim_woman_stop_r_06', 0.1, 1.0}
    }
    self.animNode = {}
    for i, v in pairs(self.anims) do
        self.animNode[i] = PlayerAnimMgr:CreateSingleClipNode(v[2])
    end
end
function MoveStopState:InitData()
    self:AddTransition('ToIdleState', self.controller.states['IdleState'], 0.4)
    self:AddTransition(
        'ToMoveState',
        self.controller.states['MoveState'],
        -1,
        function()
            return self:MoveMonitor()
        end
    )
    self:AddTransition(
        'ToCrouchBeginState',
        self.controller.states['CrouchBeginState'],
        -1,
        function()
            return self.controller.isCrouch
        end
    )
    self:AddTransition(
        'ToFlyBeginState',
        self.controller.states['FlyBeginState'],
        -1,
        function()
            return self.controller.triggers['FlyBeginState']
        end
    )
end

function MoveStopState:OnEnter()
    PlayerActState.OnEnter(self)
    local index = self:GetStopIndex()
    print(index, table.dump(self.anims[index]))
    PlayerAnimMgr:Play(self.animNode[index], 0, 1, self.anims[index][3], 0, true, false, 1)
end

function MoveStopState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end
function MoveStopState:OnLeave()
    PlayerActState.OnLeave(self)
end

return MoveStopState
