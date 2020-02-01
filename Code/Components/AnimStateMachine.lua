local asm = Concord.component(
        function(c)
            c.currentState = "idle"
            c.states = {
                idle = function(anim, vals)
                    if vals.isClimbing then
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

function asm:update(anim)
    self.currentState = self.states[self.currentState](anim, self.values) or self.currentState
    
    self.isDirty = false
end

return asm