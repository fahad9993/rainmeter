function Update()
    local filepath = "C:\\Users\\Fahad\\Documents\\Rainmeter\\Skins\\CashInHand\\var.inc"  -- Use double backslashes for Windows paths
    local file = io.open(filepath, "r")  -- Open file in read mode

    if file then
        for line in file:lines() do  -- Read the file line by line
            local key, value = string.match(line, "(%w+)%s*=%s*(%d+)")  -- Match "Cash=857"
            if key == "Cash" then
                SKIN:Bang("!SetVariable", "Cash", value)  -- Update Rainmeter variable
                file:close()  -- Close file
                return value  -- Return extracted value
            end
        end
        file:close()  -- Close file if no match is found
    end
    
    return "Error"  -- Return an error message if file is missing or no value is found
end
