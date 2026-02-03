Name = "rescue"
NamePretty = "Rescue window"
Icon = "window-new"
Action = "hyprctl dispatch focuswindow address:%VALUE% && hyprctl dispatch centerwindow"
HideFromProviderlist = true

function GetEntries()
    local hyprctl = io.popen("hyprctl clients -j")
    local data = jsonDecode(hyprctl:read("*a"))
    hyprctl:close()

    local results = {}

    for _, window in ipairs(data) do
        if window.floating then
            table.insert(results, {
                Text = window.title,
                Icon = window.class,
                Value = window.address,
            })
        end
    end
    
    return results
end
