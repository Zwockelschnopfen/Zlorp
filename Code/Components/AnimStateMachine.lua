local asm = Concord.component(
        function(c)
            c.currentState = "idle"
            c.states = {
                idle = function(anim, vals)
                    if vals.isMoving then
                        anim:setActiveAnim("walk")
                        return "walk"
                    elseif vals.isClimbing then
                        anim:setActiveAnim("climb")
                        return "climb"
                    elseif vals.isPickingUp then
                        anim:setActiveAnim("junkPickup")
                        return "junkPickup"
                    end
                end,
                walk = function(anim, vals)
                    if not vals.isMoving then
                        anim:setActiveAnim("idle")
                        return "idle"
                    elseif vals.isClimbing then
                        anim:setActiveAnim("climb")
                        return "climb"
                    elseif vals.isPickingUp then
                        anim:setActiveAnim("junkPickup")
                        return "junkPickup"
                    end
                end,
                climb = function(anim, vals)
                    if not vals.isClimbing then
                        if vals.isMoving then
                            anim:setActiveAnim("walk")
                            return "walk"
                        else
                            anim:setActiveAnim("idle")
                            return "idle"
                        end
                    end
                end,
                repair = function(anim, vals)
                        if not vals.isRepairing then
                            if vals.hasJunk then
                                anim:setActiveAnim("junkIdle")
                                return "junkIdle"
                            else
                                anim:setActiveAnim("idle")
                                return "idle"
                            end
                        end
                    end,
                junkWalk = function(anim, vals)
                        if not vals.isMoving then
                            anim:setActiveAnim("junkIdle")
                            return "junkIdle"
                        elseif vals.isClimbing then
                            anim:setActiveAnim("junkClimb")
                            return "junkClimb"
                        end
                    end,
                junkIdle = function(anim, vals)
                        if vals.isMoving then
                            anim:setActiveAnim("junkWalk")
                            return "junkWalk"
                        elseif vals.isRepairing then
                            anim:setActiveAnim("repair")
                            return "repair"
                        elseif vals.isClimbing then
                            anim:setActiveAnim("junkClimb")
                            return "junkClimb"
                        end
                    end,
                junkClimb = function(anim, vals)
                        if not vals.isClimbing then
                            if vals.isMoving then
                                anim:setActiveAnim("junkWalk")
                                return "junkWalk"
                            else
                                anim:setActiveAnim("junkIdle")
                                return "junkIdle"
                            end
                        end
                    end,
                junkPickup = function(anim, vals)
                        if not vals.isPickingUp then
                            if vals.hasJunk then
                                anim:setActiveAnim("junkIdle")
                                return "junkIdle"
                            else
                                anim:setActiveAnim("idle")
                                return "idle"
                            end
                        end
                    end
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