return Concord.component(
        function(c, mode)
            mode = mode or 0
            c.world = love.physics.newWorld(0, 0, true)
            c.world:setGravity(0, 9.81 * 70)
            if mode == 0 then 
                    c.world:setCallbacks(
                            function(f0, f1, c)
                                -- beginContact
                                local u0, u1 = f0:getUserData(), f1:getUserData()
                                if u0 then
                                    u0.collisionCount = (u0.collisionCount or 0) + 1
                                end
                                if u1 then
                                    u1.collisionCount = (u1.collisionCount or 0) + 1
                                end
                                -- print("begin", f0, f1, c)
                            end,
                            function(f0, f1, c)
                                -- endContact
                                local u0, u1 = f0:getUserData(), f1:getUserData()
                                if u0 then
                                    u0.collisionCount = u0.collisionCount - 1
                                end
                                if u1 then
                                    u1.collisionCount = u1.collisionCount - 1
                                end
                                -- print("end", f0, f1, c)
                            end
                    )
            else
                -- IMPLEMENT SHMUP CALLBACKS HERE    
            end
        end
)
