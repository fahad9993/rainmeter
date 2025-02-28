function Initialize()
    dofile(SKIN:GetVariable('@') .. 'Scripts\\FrequencyData.lua')
end

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

function IsoToUnix(iso_time)
    local year, month, day, hour, min, sec = iso_time:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
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

function ConvertMyDate(date_str, output_format)
    local day, month, year = date_str:match("(%d+)-(%d+)-(%d+)")

    local date_table = {
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = 0,
        min = 0,
        sec = 0,
    }

    local timestamp = os.time(date_table)
    return os.date(output_format, timestamp)
end

function Update()
    local currentUnix = ConvertToUnixTimestamp()
    local startDateTimeStr = SKIN:GetVariable("StartDateTime")

    -- Convert StartDateTime from ISO to Unix
    local startDateTime = IsoToUnix(startDateTimeStr)
    if not startDateTime then return "Invalid StartDateTime format" end

    table.sort(Milestones, function(a, b) return a.days < b.days end)

    -- Calculate elapsed days
    local elapsedSeconds = math.floor(currentUnix - startDateTime)

    -- Find next milestone
    local nextMilestone = nil
    Frequency = nil
    local last_achieved_on = nil
    for i, milestone in ipairs(Milestones) do
        if elapsedSeconds < milestone.days * 86400 then
            nextMilestone = milestone.days * 86400
            Frequency = milestone.freq
            last_achieved_on = ConvertMyDate(milestone.last_achieved_on, "%A, %d %B %Y")
            --last_achieved_on = milestone.last_achieved_on
            break
        end
    end

    SKIN:Bang("!SetVariable", "LastAchievedOn", last_achieved_on)

    -- Hiding the Frequency Meter on condition--
    if Frequency == 1 then
        SKIN:Bang("!SetVariable", "HideFrequency", 1)
    else
        SKIN:Bang("!SetVariable", "HideFrequency", 0)
    end

    -- If all milestones are reached, return completion message
    if not nextMilestone then
        return "All milestones reached"
    end

    -- Calculate percentage toward the next milestone
    Progress = (elapsedSeconds / nextMilestone) * 100

    -- Format result
    return "Next: " .. (nextMilestone / 86400) .. " days (" .. string.format("%.2f", Progress) .. "%)"
end
