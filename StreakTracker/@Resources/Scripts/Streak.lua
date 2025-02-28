function ConvertToUnixTimestamp()
    local year = SKIN:GetMeasure("MeasureTimeYear"):GetValue()
    local month = SKIN:GetMeasure("MeasureTimeMonth"):GetValue()
    local day = SKIN:GetMeasure("MeasureTimeDay"):GetValue()
    local hours = SKIN:GetMeasure("MeasureTimeHour"):GetValue()
    local minutes = SKIN:GetMeasure("MeasureTimeMinute"):GetValue()
    local seconds = SKIN:GetMeasure("MeasureTimeSeconds"):GetValue()

    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hours),
        min = tonumber(minutes),
        sec = tonumber(seconds)
    })
end

-- Converts an ISO 8601 timestamp (YYYY-MM-DDTHH:MM:SS) to Unix timestamp
function IsoToUnix(iso_time)
    local year, month, day, hour, min, sec = iso_time:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
    
    -- Ensure valid parsing
    if not year then return nil end  

    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    })
end

function Update()
    local currentUnix = ConvertToUnixTimestamp()
    local startDateTimeStr = SKIN:GetVariable("StartDateTime")
    local targetDays = tonumber(SKIN:GetVariable("Target"))

    if not targetDays or targetDays == 0 then
        return "Invalid target days"
    end

    -- Convert StartDateTime from ISO to Unix
    local startDateTime = IsoToUnix(startDateTimeStr)
    if not startDateTime then return "Invalid StartDateTime format" end

    -- Calculate the total difference in seconds
    local totalSeconds = currentUnix - startDateTime

    -- Calculate days, hours, and minutes
    local days = math.floor(totalSeconds / 86400)  -- 86400 seconds in a day
    local hours = math.floor((totalSeconds % 86400) / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)

    -- Function to handle singular/plural formatting
    local function pluralize(value, singular, plural)
        return value .. " " .. (value == 1 and singular or plural)
    end

    -- Calculate elapsed time in seconds
    local elapsedSeconds = currentUnix - startDateTime
    local targetSeconds = targetDays * 86400  -- Convert target days to seconds

    -- Ensure we don't divide by zero
    local percentage = (elapsedSeconds / targetSeconds) * 100
    if targetSeconds == 0 then
        percentage = 0
    end

    SKIN:Bang("!SetVariable", "Percentage", percentage, "StreakTracker\\RoundProgressBar")
    -- SKIN:Bang("!SetVariable", "Percentage", percentage, "StreakTracker\\Bar")

    -- Format the result dynamically
    local result = ""

    if days > 0 then
        result = result .. pluralize(days, "day", "days") .. " "
    end

    if hours > 0 then
        result = result .. pluralize(hours, "hour", "hours") .. " "
    end

    if minutes > 0 then
        result = result .. pluralize(minutes, "minute", "minutes")
    end

    return result

end
