function formatLocalNumber(n)
    local str = tostring(n)  -- Convert number to string
    str = str:reverse()  -- Reverse the string (e.g., "1000000" → "0000001")
    
    -- First, add a comma after every three digits
    str = str:gsub("(%d%d%d)", "%1,")  

    -- Then, modify the placement of the first comma for the Indian system
    str = str:reverse():gsub("(%d+),(%d%d%d,)", "%1,%2")  

    return str
end


function Update()
    local filepath = "C:\\Users\\Fahad\\Documents\\Rainmeter\\Skins\\CashInHand\\var.inc"  -- Use double backslashes for Windows paths
    local file = io.open(filepath, "r")  -- Open file in read mode

    if file then
        local cash, total
        for line in file:lines() do  -- Read file line by line
            local key, value = string.match(line, "(%w+)%s*=%s*([%d,%.]+)")  -- Match numbers with commas
            if key == "Cash" then
                cash = string.gsub(value, ",", "")  -- Remove commas
                cash = math.floor(tonumber(cash))
                cash = formatLocalNumber(cash)
            elseif key == "Total" then
                total = string.gsub(value, ",", "")  -- Remove commas
                total = math.floor(tonumber(total))
                total = formatLocalNumber(total)
            end
        end
        file:close()  -- Close file after reading

        -- Update Rainmeter variables only if values were found
        if cash then SKIN:Bang("!SetVariable", "Cash", cash) end
        if total then SKIN:Bang("!SetVariable", "Total", total) end
    end
    
    return "Updated"  -- Return success message
end
