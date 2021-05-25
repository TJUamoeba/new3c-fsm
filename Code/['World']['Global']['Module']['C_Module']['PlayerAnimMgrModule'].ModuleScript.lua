--- 角色动画管理模块
--- @module PlayerAnim Mgr, client-side
--- @copyright Lilith Games, Avatar Team
--- @author Dead Ratman
local PlayerAnimMgr, this = ModuleUtil.New('PlayerAnimMgr', ClientBase)

--- 初始化
function PlayerAnimMgr:Init()
    print('PlayerAnimMgr:Init')
    this:NodeRef()
    this:DataInit()
    this:EventBind()
end

--- 节点引用
function PlayerAnimMgr:NodeRef()
end

--- 数据变量初始化
function PlayerAnimMgr:DataInit()
    local anims = {
        'anim_woman_idle_01',
        'anim_woman_walkfront_01',
        'anim_woman_runfront_01',
        'anim_woman_sprint_01',
        'anim_woman_jump_begin_01',
        'anim_woman_jump_riseuploop_01',
        'anim_woman_jump_highest_01',
        'anim_woman_jump_falldownloop_01',
        'anim_woman_jumptoidle_01',
        'anim_woman_jumptorun_01',
        'anim_woman_jumpforward_riseuploop_01',
        'anim_woman_jumpforward_riseuploop_02',
        'anim_woman_jumpforward_highest_01',
        'anim_woman_jumpforward_highest_02',
        'anim_woman_jumpforward_falldownloop_01',
        'anim_woman_jumpforward_falldownloop_02',
        'anim_woman_jumpforwardtoidle_01',
        'anim_woman_jumpforward_falldownloop_02',
        'anim_woman_jumpforwardtoidle_01',
        'anim_woman_jumpforwardtorun_01',
        'anim_woman_stop_l_01',
        'anim_woman_stop_r_01',
        'anim_woman_stop_l_03',
        'anim_woman_stop_r_03',
        'anim_woman_stop_l_04',
        'anim_woman_stop_r_04',
        'anim_woman_stop_l_05',
        'anim_woman_stop_r_05',
        'anim_woman_stop_l_06',
        'anim_woman_stop_r_06',
        'anim_woman_stop_l_07',
        'anim_woman_stop_r_07',
        'anim_woman_idletosliding_01',
        'anim_woman_slidingloop_01',
        'anim_woman_slidingtoidle_01',
        'anim_woman_slidingloop_01',
        'anim_woman_slidingtoidle_01',
        'anim_woman_crouch_idle_01',
        'anim_woman_crouch_front_01',
        'anim_woman_crouchtostand_01',
        'anim_woman_standtocrouch_01',
        'anim_woman_crouch_idle_02',
        'anim_woman_crouch_front_02',
        'anim_woman_crouchtostand_02',
        'anim_woman_standtocrouch_02',
        'anim_woman_death_01',
        'anim_woman_death_loop_01',
        'anim_woman_doublejump_01',
        'anim_woman_doublejump_02',
        'anim_woman_death_loop_01',
        'anim_woman_doublejump_01',
        'anim_woman_doublejump_02',
        'anim_woman_walkoffledge_01',
        'anim_woman_jumptohover_01',
        'anim_woman_hoveridle_01',
        'anim_woman_hoverforward_01',
        'anim_woman_hoverup_01',
        'anim_woman_hoverdown_01',
        'anim_woman_hovertoland_01',
        'anim_woman_flyup_01',
        'anim_woman_flydown_01',
        'anim_woman_flyforward_01',
        'anim_woman_hovertofly_01',
        'anim_woman_flytohover_01',
        'anim_woman_turnleft_01',
        'anim_woman_turnright_01',
        'anim_woman_flyturnleft_01',
        'anim_woman_flyturnright_01',
        'anim_woman_turnleft_03',
        'anim_woman_turnright_03',
        'anim_woman_hoveridle_02',
        'anim_woman_hovertoland_02',
        'anim_human_swim_idle_01',
        'anim_human_swim_freestyle_01',
        'anim_human_swim_breaststroke_01',
        'anim_human_swimup_01',
        'anim_human_swimdown_01',
        'anim_human_idletofreestyle_01',
        'anim_human_freestyletoidle_01',
        'anim_human_idletobreaststroke_01',
        'anim_human_breaststroketoidle_01'
    }
    this:ImportAnimation(anims, 'Animation/')
end

--- 节点事件绑定
function PlayerAnimMgr:EventBind()
end

--导入动画资源
function PlayerAnimMgr:ImportAnimation(_anims, _path)
    for _, animaName in pairs(_anims) do
        ResourceManager.GetAnimation(_path .. animaName)
    end
end

--创建一个包含单个动作的混合空间节点,并设置动作速率
function PlayerAnimMgr:CreateSingleClipNode(_animName, _speed)
    local node = localPlayer.Avatar:AddBlendSpaceSingleNode()
    node:AddClipSingle(_animName, _speed or 1)
    return node
end

--创建一个一维混合空间节点并附带一个参数
--[[anims = 
		{
			{"anim_woman_idle_01", 0.0, 1.0},
			{"anim_woman_walkfront_01", 0.25, 1.0}
		}
]]
function PlayerAnimMgr:Create1DClipNode(_anims, _param)
    local node = localPlayer.Avatar:AddBlendSpace1DNode(_param)
    for _, v in pairs(_anims) do
        node:AddClip1D(v[1], v[2], v[3] or 1)
    end
    return node
end

function PlayerAnimMgr:Create2DClipNode(_anims, _param1, _param2)
    local node = localPlayer.Avatar:AddBlendSpace2DNode(_param1, _param2)
    for _, v in pairs(_anims) do
        node:AddClip2D(v[1], v[2], v[3], v[4] or 1)
    end
    return node
end

function PlayerAnimMgr:Play(_animNode, _layer, _weight, _transIn, _transOut, _isInterrupt, _isLoop, _speedScale)
    localPlayer.Avatar:PlayBlendSpaceNode(
        _animNode,
        _layer,
        _weight or 1,
        _transIn or 0,
        _transOut or 0,
        _isInterrupt or true,
        _isLoop or false,
        _speedScale or 1
    )
end

function PlayerAnimMgr:Update(dt)
end

return PlayerAnimMgr
