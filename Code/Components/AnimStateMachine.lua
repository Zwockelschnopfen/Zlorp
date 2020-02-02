local asm = Concord.component(
        function(c)
            c.currentState = "idle"
            c.states = {
                idle = function(anim, vals, dt)
                    if vals.isPickingUp then
                        c.timer = 1.0
                        anim:setActiveAnim("junkPickup")
                        return "pickup"
                    elseif vals.isRepairing then
                        c.timer = 1.0
                        anim:setActiveAnim("repair")
                        return "repair"
                    elseif vals.isClimbing then
                        if vals.hasJunk then
                            anim:setActiveAnim("junkClimb")
                        else
                            anim:setActiveAnim("climb")
                        end
                    elseif vals.isMoving then
                        if vals.hasJunk then
                            anim:setActiveAnim("junkWalk")
                        else
                            anim:setActiveAnim("walk")
                        end
                    else
                        if vals.hasJunk then
                            anim:setActiveAnim("junkIdle")
                        else
                            anim:setActiveAnim("idle")
                        end
                    end
                    return "idle"
                end,
                pickup = function(anim, vals, dt)
                    c.timer = c.timer - dt
                    if c.timer < 0.0 then
                        return "idle"
                    else
                        return "pickup"
                    end
                end,
                repair = function(anim, vals, dt)
                    c.timer = c.timer - dt
                    if c.timer < 0.0 then
                        return "idle"
                    else
                        return "repair"
                    end
                end,
            }
            c.transitions = {}
            c.values = {
                isMoving = false,
                isClimbing = false,
                isRepairing = false,
                isPickingUp = false,
                hasJunk = false
            }
        end
)

function asm:setValue(key, value)
    self.values[key] = value
    self.isDirty = true
end

function asm:update(anim, dt)
    self.currentState = self.states[self.currentState](anim, self.values, dt) or self.currentState
    
    self.isDirty = false
end

return asm