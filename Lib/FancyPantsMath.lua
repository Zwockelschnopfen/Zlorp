

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
  local t = math.clamp((val - min) / (max - min), 0.0, 1.0);
  return t * t * (3.0 - 2.0 * t);
end