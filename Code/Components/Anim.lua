return Concord.component(
        function(c, img, config)
            c.t = 0
            c.duration = 1
            c.quads = {}
            for i = 1, config.numRows do
                for j = 1, config.numCols do
                    table.insert(
                            c.quads, 
                            love.graphics.newQuad(
                                config.px * (j - 1) + 1 * (j - 1), 
                                config.py * (i - 1) + 1 * (i - 1), 
                                config.px, 
                                config.py, 
                                img:getDimensions()
                            )
                    )
                end
            end
        end
)
