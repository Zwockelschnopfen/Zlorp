return Concord.component(
        function(c, img, quad, layer)
            c.img = img
            c.quad = quad
            c.layer = layer or "default"
        end
)
