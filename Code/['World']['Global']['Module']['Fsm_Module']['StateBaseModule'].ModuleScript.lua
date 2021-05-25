--- 状态机状态基类
-- @module StateBase
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local StateBase = class('StateBase')

function StateBase:initialize(_controller, _stateName)
    print(_stateName, 'initialize()')
    self.stateName = _stateName
    self.controller = _controller

    self.transitions = {}
    self.anyState = {}
end

function StateBase:InitData()
end

--增加一个transition
function StateBase:AddTransition(_transitonName, _nextState, _dur, ...)
    local transiton = TransitonBase:new(_transitonName, _nextState, _dur)
    transiton:InitConditions(...)
    self.transitions[_transitonName] = transiton
end

--增加一个anyState
function StateBase:AddAnyState(_transitonName, _nextState, _dur, ...)
    local transiton = TransitonBase:new(_transitonName, _nextState, _dur)
    transiton:InitConditions(...)
    self.anyState[_transitonName] = transiton
end

--变化运行
function StateBase:TransUpdate(dt)
    for _, trans in pairs(self.transitions) do
        local nextState = trans:GetTransState(dt)
        if nextState then
            return nextState
        end
    end
    return nil
end

--anyState监测
function StateBase:AnyStateCheck()
    for _, trans in pairs(self.anyState) do
        local nextState = trans:GetTransState(0)
        if nextState then
            return nextState
        end
    end
    return nil
end


--进入状态
function StateBase:OnEnter()
    print('进入' .. self.stateName)
end

--更新状态
function StateBase:OnUpdate()
    --print('更新' .. self.stateName)
end

--离开状态
function StateBase:OnLeave()
    --print("离开" .. self.stateName)
end

return StateBase
