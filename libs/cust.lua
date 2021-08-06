local component = require('component')
local selectorAddresses = { {}, {}, {}, {} }
local io = require('io')
local serialization = require('serialization')
local event = require('event')
selectorAddresses[1][1] = "a6ae8d65-fbdf-4c1d-92f3-307eac20277f"
selectorAddresses[2][1] = "e8a7afe4-0205-4a28-ab62-3f4bd0ab1580"
selectorAddresses[3][1] = "9c3c7fde-e2a4-4bf5-b6ed-803d687d0517"
selectorAddresses[4][1] = "34c42cd9-6167-4308-b70d-f3aa9e0f4389"
selectorAddresses[1][2] = "6937cb19-10a3-48cb-a6bb-a79c7d5aed6a"
selectorAddresses[2][2] = "b0f4bf63-1169-4568-b978-b69edcb30369"
selectorAddresses[3][2] = "8c79ea99-6737-4c07-8689-259b2d1c1608"
selectorAddresses[4][2] = "bbd7b633-07fc-4653-88c5-2f9fb35f9609"
selectorAddresses[1][3] = "9a301dbe-8105-4ba4-bf64-c2b694b936c1"
selectorAddresses[2][3] = "ddad55ef-f0c3-4de5-9756-2170136b7efd"
selectorAddresses[3][3] = "42e86c50-6bdf-4252-a0cc-d26addc3aa7c"
selectorAddresses[4][3] = "f8feafb8-18db-4934-81f7-fb886c46de37"
selectorAddresses[1][4] = "b64e440b-8713-4d6b-8487-80f05a20ee09"
selectorAddresses[2][4] = "8a76ab8a-32dc-4e14-9eb4-295a9d23d8de"
selectorAddresses[3][4] = "bbccdbc9-6b2e-47ea-b055-dd0813fb8d54"
selectorAddresses[4][4] = "01e6a934-62ab-4d97-8fea-1373d2f8ade8"

local selectors = {}

local function getSelectorByAddress(address)
    for index, selObj in pairs(selectors) do
        if (selObj.selector.address == address) then
            return selObj
        end
    end
end

local function customizeSelectors()
    for k, v in pairs(component.list("openperipheral_selector")) do
        local selectorObj = {}
        selectorObj.selector = component.proxy(k)
        selectorObj.componentAddress = k
        selectorObj.colors = { {}, {}, {}, {} }
        selectorObj.items = {}
        table.insert(selectors, selectorObj)
    end
    local index = 1
    for index, selObj in pairs(selectors) do
        selObj.selector.setSlots({})
        selObj.index = index
        selObj.selector.setSlot(1, { id = "minecraft:wool", dmg = index })
        index = index + 1
    end

    for i = 1, 4 do
        for j = 1, 4 do
            _, slot, address = event.pull("slot_click")
            local selObj = getSelectorByAddress(selectorAddresses[j][i])
            selObj.clickAddress = address
            selObj.x = j
            selObj.y = i
            selObj.selector.setSlots({})
        end
    end

    for index, selObj in pairs(selectors) do
        selObj.selector = nil
    end

    local file = io.open('selectors.cfg','w')
    file:write(serialization.serialize(selectors))
    file:close()
end
customizeSelectors()
