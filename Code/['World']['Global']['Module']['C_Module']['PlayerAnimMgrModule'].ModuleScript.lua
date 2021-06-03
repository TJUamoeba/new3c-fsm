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
        'new_anim_human_swim_freestyle_01',
        'new_anim_human_swim_breaststroke_01',
        'new_anim_human_idletofreestyle_01',
        'new_anim_human_freestyletoidle_01',
        'new_anim_human_idletobreaststroke_01',
        'new_anim_human_breaststroketoidle_01',
        'anim_human_sit_swim_goashore',
        'new_anim_human_swim_intowater'
    }
    this:ImportAnimation(anims, 'Animation/')
end

--- 节点事件绑定
function PlayerAnimMgr:EventBind()
end

--导入动画资源
function PlayerAnimMgr:ImportAnimation(_anims, _path)
    for _, animaName in pairs(_anims) do
        print(_path .. animaName)
        ResourceManager.GetAnimation(_path .. animaName)
    end
end

--创建一个包含单个动作的混合空间节点,并设置动作速率
function PlayerAnimMgr:CreateSingleClipNode(_animName, _speed)
    local node = localPlayer.Avatar:AddBlendSpaceSingleNode(false)
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
