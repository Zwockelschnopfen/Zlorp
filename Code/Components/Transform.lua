local TransformComponent
TransformComponent = Concord.component(
        function(c, x, y, r, sx, sy, parent)
            c.x = x or 0
            c.y = y or 0
            c.r = r or 0
            c.sx = sx or 1
            c.sy = sy or 1
            if parent and parent.get then
                print(c.parent)
                c.parent = parent:get(TransformComponent)
            else
                c.parent = parent
            end
        end
)

function TransformComponent:getAbsoluteTransform()
    local tmpE = self
    local x, y, r, sx, sy = 0, 0, 0, 1, 1
    while tmpE do
        x = x + tmpE.x
        y = y + tmpE.y
        r = r + tmpE.r
        sx = sx * tmpE.sx
        sy = sy * tmpE.sy
        tmpE = tmpE.parent
    end
    
    print(sx, sy)

    return x, y, r, sx, sy
end

return TransformComponent