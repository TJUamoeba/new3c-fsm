--- 角色控制模块
--- @module Player Ctrl Module
--- @copyright Lilith Games, Avatar Team
--- @author Dead Ratman
local PlayerCtrl, this = ModuleUtil.New('PlayerCtrl', ClientBase)

--声明变量
local isDead = false
local forwardDir = Vector3.Forward
local rightDir = Vector3.Right
local horizontal = 0
local vertical = 0

-- PC端交互按键
local FORWARD_KEY = Enum.KeyCode.W
local BACK_KEY = Enum.KeyCode.S
local LEFT_KEY = Enum.KeyCode.A
local RIGHT_KEY = Enum.KeyCode.D
local JUMP_KEY = Enum.KeyCode.Space
local SPRINT_KEY = Enum.KeyCode.LeftShift
local UP_KEY = Enum.KeyCode.Q
local DOWN_KEY = Enum.KeyCode.E

-- 键盘的输入值
local moveForwardAxis = 0
local moveBackAxis = 0
local moveLeftAxis = 0
local moveRightAxis = 0
local upAxis = 0
local downAxis = 0

--- 初始化
function PlayerCtrl:Init()
    ----print('[PlayerCtrl] Init()')
    this:DataInit()
    this:EventBind()
end

--- 数据变量初始化
function PlayerCtrl:DataInit()
    this.finalDir = Vector3.Zero
    this.isSprint = false
    this.upright = 0
end

--- 节点事件绑定
function PlayerCtrl:EventBind()
    -- Keyboard Input
    Input.OnKeyDown:Connect(
        function()
            if Input.GetPressKeyData(JUMP_KEY) == 1 then
                this:PlayerJump()
            end
        end
    )
end
--获取按键盘时的移动方向最终取值
function GetKeyValue()
    moveForwardAxis = Input.GetPressKeyData(FORWARD_KEY) > 0 and 1 or 0
    moveBackAxis = Input.GetPressKeyData(BACK_KEY) > 0 and -1 or 0
    moveLeftAxis = Input.GetPressKeyData(LEFT_KEY) > 0 and 1 or 0
    moveRightAxis = Input.GetPressKeyData(RIGHT_KEY) > 0 and -1 or 0
    this.isSprint = Input.GetPressKeyData(SPRINT_KEY) == 2
    upAxis = Input.GetPressKeyData(UP_KEY) == 2 and 1 or 0
    downAxis = Input.GetPressKeyData(DOWN_KEY) == 2 and 1 or 0
    if localPlayer.State == Enum.CharacterState.Died then
        moveForwardAxis, moveBackAxis, moveLeftAxis, moveRightAxis = 0, 0, 0, 0
    end
end

-- 获取移动方向
function GetMoveDir()
    forwardDir = PlayerCam:IsFreeMode() and PlayerCam.curCamera.Forward or localPlayer.Forward
    forwardDir.y = 0
    rightDir = Vector3(0, 1, 0):Cross(forwardDir)
    horizontal = GuiControl.joystick.Horizontal
    vertical = GuiControl.joystick.Vertical
    this.upright = upAxis - downAxis
    if horizontal ~= 0 or vertical ~= 0 then
        this.finalDir = rightDir * horizontal + forwardDir * vertical
    else
        GetKeyValue()
        this.finalDir = forwardDir * (moveForwardAxis + moveBackAxis) - rightDir * (moveLeftAxis + moveRightAxis)
        if this.finalDir.Magnitude > 0 then
            this.finalDir = this.finalDir.Normalized
        end
    end
end

-- 跳跃逻辑
function PlayerCtrl:PlayerJump()
    FsmMgr.playerActCtrl:CallTrigger('JumpBeginState')
end

-- 冲刺逻辑
function PlayerCtrl:PlayerSprint()
    FsmMgr.playerActCtrl:CallTrigger('JumpBeginState')
end

function PlayerCtrl:Update(dt)
    GetMoveDir()
end

return PlayerCtrl
