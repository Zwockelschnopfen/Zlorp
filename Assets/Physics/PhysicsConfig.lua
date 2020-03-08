--[[
collision groups:
player
enemies
neutral

collision categories:
ship
projectile
]]

return {
    shmup = {
        group = {
            player = 1,
            enemy = 2,
            neutral = 3,
        },
        categories = {
            ship = {1},
            projectile = {2}
        },
        masks = {
            projectile = {2}
        }
    }
}