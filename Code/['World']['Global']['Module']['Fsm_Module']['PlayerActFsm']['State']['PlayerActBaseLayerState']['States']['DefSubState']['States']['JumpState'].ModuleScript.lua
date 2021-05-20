local JumpState = class("JumpState", PlayerActState)

function JumpState:OnEnter()
    PlayerActState.OnEnter(self)
    localPlayer:Jump()
    localPlayer.Avatar:PlayAnimation("Jump01_Boy", 2, 1, 0.1, true, false, 1)
end

function JumpState:OnUpdate(dt)
    PlayerActState.OnUpdate(self, dt)
    self:IdleMonitor()
    self:OnGroundMonitor()
end

function JumpState:IdleMonitor()
    local dir = PlayerCtrl.finalDir
    dir.y = 0
    if dir.Magnitude > 0 then
        if PlayerCam:IsFreeMode() then
            localPlayer:FaceToDir(dir, 4 * math.pi)
        end
        localPlayer:MoveTowards(Vector2(dir.x, dir.z))
    else
        localPlayer:MoveTowards(Vector2.Zero)
    end
end

function JumpState:OnLeave()
    PlayerActState.OnLeave(self)
end

return JumpState
