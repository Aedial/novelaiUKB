function convert_timestamp(meta)
  local timestamp = meta.date

  if type(timestamp) == "string" then
    meta.date = "No date available"
  else
    local day = os.date("%d/%m/%Y", timestamp)
    local hour = os.date("%H:%M", timestamp)

    meta.date = "Last updated " .. day .. " at " .. hour
  end

  return meta
end

return {
  { Meta = convert_timestamp }
}
