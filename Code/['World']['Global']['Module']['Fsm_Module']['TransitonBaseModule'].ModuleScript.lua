--- 状态机过渡基类
-- @module TransitonBase
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local TransitonBase = class('TransitonBase')

function TransitonBase:initialize(_params, _parentState)
    print('TransitonBase:initialize()')
    self.params = _params
    self.parentState = _parentState or nil
    self.nextState = nil
    self.dur = 0
    self.curTime = 0
    self.conditions = {}
    self:InitData()
end

function TransitonBase:InitData()
    for k, v in pairs(self.parentState.parentState.subStates) do
        if k == script.NextState.Value then
            self.nextState = v
        end
    end
    self.dur = script.Dur.Value
    for k, v in pairs(script:GetChildren()) do
        local prefix, suffix = string.match(k, '(%s)_(%s)')
        if prefix and prefix == 'Condition' and self.params[suffix] then
            self.conditions[suffix] = v.Value
        end
    end
end

--检查变量是否满足条件
function TransitonBase:CheckCondition()
    for k, v in pairs(self.params) do
        if self.conditions[k] and self.conditions[k] ~= v then
            return nil
        end
    end
    return self:GetTransState()
end

--获取过渡State
function TransitonBase:GetTransState()
    if self.nextState == self.parentState.parentState then
        return self.nextState:CheckTransitionsCondition()
    else
        if #self.nextState.subStates > 0 then
            return self.nextState:CheckEntryCondition()
        else
            return self.nextState
        end
    end
end

--变化更新
function TransitonBase:Update(dt)
    if self.dur ~= -1 then
        if self.curTime < self.dur then
            self.curTime = self.curTime + dt
        else
            self.curTime = 0
            return self:GetTransState()
        end
    end
    return nil
end

return TransitonBase
