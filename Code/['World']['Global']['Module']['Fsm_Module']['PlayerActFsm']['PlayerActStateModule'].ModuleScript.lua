--- 玩家动作状态
-- @module  PlayerActState
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local PlayerActState = class('PlayerActState', StateBase)

---监听静止
function PlayerActState:IdleMonitor()
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if dir.Magnitude > 0 then
        if PlayerCam:IsFreeMode() then
            localPlayer:FaceToDir(dir, 4 * math.pi)
        end
        localPlayer:MoveTowards(Vector2(dir.x, dir.z))
    else
        FsmMgr.playerActCtrl:ChangeParam('isMove', false)
    end
end

---监听移动
function PlayerActState:MoveMonitor()
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if dir.Magnitude > 0 then
        FsmMgr.playerActCtrl:ChangeParam('isMove', true)
    end
end

---监听奔跑
function PlayerActState:RunMonitor()
    if PlayerCtrl.finalDir.Magnitude >= 0.6 then
        FsmMgr.playerActCtrl:ChangeParam('isRun', true)
    end
end

---监听行走
function PlayerActState:WalkMonitor()
    if PlayerCtrl.finalDir.Magnitude < 0.6 then
        FsmMgr.playerActCtrl:ChangeParam('isRun', false)
    end
end

---监听着地
function PlayerActState:OnGroundMonitor()
    if localPlayer.IsOnGround then
        FsmMgr.playerActCtrl:ChangeParam('isOnGround', true)
    else
        FsmMgr.playerActCtrl:ChangeParam('isOnGround', false)
    end
end

return PlayerActState
