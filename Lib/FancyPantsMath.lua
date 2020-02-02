function math.rad(deg)
  return deg * 2 * math.pi / 360
end

function math.clamp(val, min, max)
  if val < min then
    return min
  elseif val > max then
    return max
  else
    return val
  end
end

function math.smoothstep(val, min, max)
  min = min or 0
  max = max or 1
  local t = math.clamp((val - min) / (max - min), 0.0, 1.0);
  return t * t * (3.0 - 2.0 * t);
end

function math.sign(val)
  if val < 0 then
    return -1
  elseif val > 0 then
    return 1
  else
    return 0
  end
end

function math.lerp(l, r, f)
  return l * (1-f) + f * r
end