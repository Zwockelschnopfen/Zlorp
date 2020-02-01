return Concord.component(
        function(c, first, interval, last, fire)
            c.time = 0
            c.first = first
            c.interval = interval
            c.last = last
            c.fire = fire
        end
)
