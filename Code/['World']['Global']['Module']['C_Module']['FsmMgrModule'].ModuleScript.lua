--- 角色动作状态机模块
--- @module Fsm Mgr, client-side
--- @copyright Lilith Games, Avatar Team
--- @author Dead Ratman
local FsmMgr, this = ModuleUtil.New('FsmMgr', ClientBase)

--- 变量声明
local params = {
    ['isMove'] = {
        value = false,
        type = 2
    },
    ['isRun'] = {
        value = false,
        type = 2
    },
    ['jumpTrigger'] = {
        value = false,
        type = 3
    },
    ['isOnGround'] = {
        value = false,
        type = 2
    }
}

--- 初始化
function FsmMgr:Init()
    print('FsmMgr:Init')
    this:NodeRef()
    this:DataInit()
    this:EventBind()
end

--- 节点引用
function FsmMgr:NodeRef()
end

--- 数据变量初始化
function FsmMgr:DataInit()
    -- 玩家动作状态机
    this.playerActCtrl =
        PlayerActController:new(world.Global.Module.Fsm_Module.PlayerActCtrl.State.PlayerActBaseLayerState)
    for k, v in pairs(params) do
        this.playerActCtrl:AddParam(k, v.type, v.value)
    end

    world.OnRenderStepped:Connect(
        function(dt)
            this.playerActCtrl:Update(dt)
        end
    )
end

--- 节点事件绑定
function FsmMgr:EventBind()
end

function FsmMgr:Update(dt)
    --this.playerActCtrl:Update(dt)
    --print(this.playerActCtrl.curState.stateName)
    --print(this.playerActCtrl.stateTrigger.BowAttack)
end

return FsmMgr
