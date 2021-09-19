ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local properties = nil

RegisterNUICallback("buttonSubmit", function(data, cb)
    SetNuiFocus(false)
    properties:resolve(data.data)
    properties = nil
    cb("ok")
end)

RegisterNUICallback("closeMenu", function(data, cb)
    SetNuiFocus(false)
    properties:resolve(nil)
    properties = nil
    cb("ok")
end)

function DialogInput(data)
    Citizen.Wait(150)
    if not data then return end
    if properties then return end
    
    properties = promise.new()

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })

    return Citizen.Await(properties)
end

exports("DialogInput", DialogInput)
RegisterNetEvent('zf_dialog:DialogInput')
AddEventHandler('zf_dialog:DialogInput', function(data)
    DialogInput(data)
end)



RegisterCommand('testdialog', function()
    local dialog = exports['zf_dialog']:DialogInput({
        header = "Tuner Billing", 
        rows = {
            {
                id = 0, 
                txt = "Citizen ID (#)"
            },
            {
                id = 1, 
                txt = "Bill Price ($)"
            },
        }
    })
    
    if dialog ~= nil then
        if dialog[1].input == nil or dialog[2].input == nil then
            ESX.ShowNotification('Veuillez remplir les champs.')
        else
            ESX.ShowNotification('Citizen ID: ' .. dialog[1].input .. ' Price: ' .. dialog[2].input)
        end
    end
end, false)