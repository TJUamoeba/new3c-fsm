--- 状态机状态基类
-- @module StateBase
-- @copyright Lilith Games, Avatar Team
-- @author Dead Ratman
local StateBase = class('StateBase')

function StateBase:initialize(_stateModule, _stateName, _params, _parantState)
    print('StateBase:initialize()')
    self.stateName = _stateName
    self.parentState = _parantState or nil
    self.subStates = {}
    self.transitions = {}
    self.anyState = {}
    self.entry = {}
    self:ConnectSubStates(_stateModule, _params)
    self:ConnectTransitions(_stateModule, _params)
end

--绑定所有Transitions
function StateBase:ConnectTransitions(_stateModule, _params)
    if _stateModule.AnyState then
        for k, v in pairs(_stateModule.AnyState:GetChildren()) do
            local tempTransitionClass = require(v)
            self.anyState[k] = tempTransitionClass:new(_params, self)
        end
    end
    if _stateModule.Entry then
        for k, v in pairs(_stateModule.Entry:GetChildren()) do
            local tempTransitionClass = require(v)
            self.entry[k] = tempTransitionClass:new(_params, self)
        end
    end
    for k, v in pairs(_stateModule.Transitions:GetChildren()) do
        local tempTransitionClass = require(v)
        self.transitions[k] = tempTransitionClass:new(_params, self)
    end
end

--绑定所有SubStates
function StateBase:ConnectSubStates(_stateModule, _params)
    if _stateModule.States then
        for stateName, stateModule in pairs(_stateModule.States:GetChildren()) do
            local tempStateClass = require(stateModule)
            self.subStates[stateName] = tempStateClass:new(stateModule, stateName, _params, self)
        end
    end
end

--检查变量是否满足Transitions条件
function StateBase:CheckTransitionsCondition()
    local nextState = nil
    for _, trans in pairs(self.transitions) do
        nextState = trans:CheckCondition()
        if nextState then
            return nextState
        end
    end
    return nextState
end

--检查变量是否满足AnyState条件
function StateBase:CheckAnyStateCondition()
    local nextState = nil
    if #self.anyState > 0 then
        for _, trans in pairs(self.anyState) do
            nextState = trans:CheckCondition()
            if nextState then
                return nextState
            end
        end
    end
    if #self.subStates then
        for _, subState in pairs(self.subStates) do
            nextState = subState:CheckAnyStateCondition()
            if nextState then
                return nextState
            end
        end
    end
    return nextState
end

--检查变量是否满足Entry条件
function StateBase:CheckEntryCondition()
    local nextState = nil
    for _, trans in pairs(self.entry) do
        nextState = trans:CheckCondition()
        if nextState then
            return nextState
        end
    end
    return nextState
end

--变化运行
function StateBase:TransUpdate(dt)
    for _, trans in pairs(self.transitions) do
        local nextState = trans:Update(dt)
        if nextState then
            return nextState
        end
    end
    return nil
end

--进入状态
function StateBase:OnEnter()
    --print("进入" .. self.stateName)
end

--更新状态
function StateBase:OnUpdate(dt)
    --print("更新" .. self.stateName)
end

--离开状态
function StateBase:OnLeave()
    --print("离开" .. self.stateName)
end

return StateBase
