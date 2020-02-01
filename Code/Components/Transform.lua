return Concord.component(
        function(c, x, y, r, sx, sy, parent)
            c.x = x
            c.y = y
            c.r = r or 0
            c.sx = sx or 1
            c.sy = sy or 1
            c.parent = parent
        end
)
