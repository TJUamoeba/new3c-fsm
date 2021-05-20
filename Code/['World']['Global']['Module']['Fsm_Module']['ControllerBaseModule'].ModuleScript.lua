--- 状态机控制器基类
-- @module ControllerBase
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local ControllerBase = class('ControllerBase')

local paramTypeEnum = {
    Num = 1,
    Bool = 2,
    Trigger = 3
}

function ControllerBase:initialize(_baseLayerStateModule)
    print('ControllerBase:initialize()')
    local tempStateClass = require(_baseLayerStateModule)
    self.params = {}
    self.baseLayerState = tempStateClass:new(_baseLayerStateModule, _baseLayerStateModule.Name, self.params)
    self.lastState = nil
    self.curState = nil
    self:SetDefaultState()
end

--添加变量
function ControllerBase:AddParam(_paramName, _type, _value)
    if _type ~= paramTypeEnum.Trigger then
        self.params[_paramName] = {
            value = _value,
            type = _type,
            changeFunc = nil
        }
    else
        self.params[_paramName] = {
            value = false,
            type = _type,
            changeFunc = function()
                self.params[_paramName].value = false
            end
        }
    end
end

--改变变量
function ControllerBase:ChangeParam(_paramName, _value)
    self.params[_paramName].value = _value
    self:CheckAllCondition()
    self.params[_paramName].changeFunc()
end

--初始化默认状态
function ControllerBase:SetDefaultState()
    self.curState = self.baseLayerState:CheckEntryCondition()
end

--更新当前状态
function ControllerBase:Update(dt)
    if self.curState then
        self.curState:OnUpdate(dt)
        self:Switch(self.curState:TransUpdate(dt))
    end
end

--切换状态
function ControllerBase:Switch(_state)
    if _state then
        self.curState:OnLeave()
        self.lastState = self.curState
        self.curState = _state
        self.curState:OnEnter()
        return
    end
end

--检查可行的Transition和AnyState条件
function ControllerBase:CheckAllCondition()
    self:Switch(self.curState:CheckTransitionsCondition())
    self:Switch(self.baseLayerState:CheckAnyStateCondition())
end

return ControllerBase
