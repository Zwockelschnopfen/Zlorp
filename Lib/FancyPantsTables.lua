
function table.dump(table)  -- for quick debugging
    for k, v in pairs(table) do
        print(k, v)
    end
    return table
end

function table.update(table, updates)
    for k, v in pairs(updates) do
        table[k] = v
    end
    return table
end
