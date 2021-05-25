local MoveStopState = class('MoveStopState', PlayerActState)

--获取停步时哪只脚在前以及双脚间距
local function GetStopInfo()
    local lToe = localPlayer.Avatar.Bone_L_Toe0
    local rToe = localPlayer.Avatar.Bone_R_Toe0
    local toeDir = Vector2(lToe.Position.x - rToe.Position.x, lToe.Position.z - rToe.Position.z)
    local fDir = Vector2(localPlayer.Avatar.Forward.x, localPlayer.Avatar.Forward.z)
    local dis = Vector2(lToe.Position.x - rToe.Position.x, lToe.Position.z - rToe.Position.z).Magnitude
    local stopL, stopDis = (Vector2.Angle(toeDir, fDir) < 90), dis
    return stopL, stopDis
end

--确定该播放哪个停步动作
local function GetStopIndex()
    local stopSSpeed = 0.6
    local stopRSpeed = 0.3
    local stopDisGap = 0.7

    local index = 1
    local stopL, stopDis = GetStopInfo()
    local speedXZ = math.clamp(localPlayer.Velocity.Magnitude / 12, 0, 1)
    if speedXZ > stopSSpeed then
        if stopDis > stopDisGap then
            index = 3
        else
            index = 3
        end
    elseif speedXZ > stopRSpeed then
        if stopDis > stopDisGap then
            index = 2
        else
            index = 4
        end
    else
        index = 1
    end
    index = index + (stopL and 0 or 4)

    return index, stopL
end

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
    self:AddTransition('ToIdleState', self.controller.states['IdleState'], 0.5)
    self:AddTransition(
        'ToMoveState',
        self.controller.states['MoveState'],
        -1,
        function()
            return self:MoveMonitor()
        end
    )
end

function MoveStopState:OnEnter()
    PlayerActState.OnEnter(self)
    local index = GetStopIndex()
    print(index, table.dump(self.anims[index]))
    PlayerAnimMgr:Play(self.animNode[index], 0, 1, self.anims[index][3], self.anims[index][3], true, false, 1)
end

function MoveStopState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
end
function MoveStopState:OnLeave()
    PlayerActState.OnLeave(self)
end

return MoveStopState
