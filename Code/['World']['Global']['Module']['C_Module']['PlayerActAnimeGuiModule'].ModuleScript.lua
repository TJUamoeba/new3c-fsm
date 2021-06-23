--- 角色社交动作UI模块
--- @module Player Cam Module
--- @copyright Lilith Games, Avatar Team
--- @author Dead Ratman

local PlayerActAnimeGui, this = ModuleUtil.New("PlayerActAnimeGui", ClientBase)

local gui

--- 初始化
function PlayerActAnimeGui:Init()
    this:InitListener()
end

function PlayerActAnimeGui:InitListener()
    gui = localPlayer.Local.ControlGui
    this.visible = false
    this.actBtn = gui.ActBtn
    this.childActBtnList = this.actBtn:GetChildren()

    -- 显示子按钮
    this.actBtn.OnClick:Connect(
        function()
            this.visible = not this.visible
            for i = 1, #this.childActBtnList do
                this.childActBtnList[i]:SetActive(this.visible)
            end
        end
    )

    -- 子按钮点击
    for i = 1, #this.childActBtnList do
        local btn = this.childActBtnList[i]
        btn:SetActive(false)
        btn.OnClick:Connect(
            function()
                this:PlayActAnim(i)
            end
        )
    end
end

function PlayerActAnimeGui:PlayActAnim(_id)
    FsmMgr.playerActCtrl:GetActInfo(Config.ActAnim[_id])
    FsmMgr.playerActCtrl:CallTrigger("ActBeginState")
end

return PlayerActAnimeGui
