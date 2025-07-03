function removeTrailingDecimal(value)
    return tostring(value):gsub("%.00$", "")
end

function Update()
    local filepath = "C:\\Users\\Fahad\\Documents\\Rainmeter\\Skins\\CashInHand\\var.inc"  -- Use double backslashes for Windows paths
    local file = io.open(filepath, "r")  -- Open file in read mode

    if file then
        local cash, total
        for line in file:lines() do  -- Read file line by line
            local key, value = string.match(line, "(%w+)%s*=%s*([%d,%.]+)")  -- Match numbers with commas
            if key == "Cash" then
                cash = value
                cash = removeTrailingDecimal(cash)
            elseif key == "Total" then
                total = value
                total = removeTrailingDecimal(total)
            elseif key == "SoFar" then
                sofar = value
                sofar = removeTrailingDecimal(sofar)
            end
        end
        file:close()  -- Close file after reading

        -- Update Rainmeter variables only if values were found
        if cash then SKIN:Bang("!SetVariable", "Cash", cash) end
        if total then SKIN:Bang("!SetVariable", "Total", total) end
        if sofar then SKIN:Bang("!SetVariable", "SoFar", sofar) end
    end
    
    return "Updated"  -- Return success message
end
