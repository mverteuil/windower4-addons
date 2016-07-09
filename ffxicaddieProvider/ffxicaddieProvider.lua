--[[
Copyright (c) 2015-2016, Greenshoe
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of ffxicaddieProvider nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL GREENSHOE BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

require('logger')
require('pack')
require('strings')
require('tables')

res = require 'resources'

_addon.name = 'ffxicaddieProvider'
_addon.author = 'Greenshoe'
_addon.version = '1.0.2'
_addon.commands = {'fcp', 'ffxicaddieProvider'}

local host = "127.0.0.1"
local socket = require("socket")
socket.TIMEOUT = 2
local tcps = {}

local connectServer = nil
local connectServerPort = nil
local disconnectServer = nil
local disconnectServerPort = nil
local infoProviderPortRangeStart = 14811
local infoProviderPortRangeStop  = 14851
local infoProviderPort = infoProviderPortRangeStart
local infoProviderServer = nil

local entityArray = {}

windower.register_event('load', function()
    connectServer, connectServerPort = getNewServerWithArbitraryPort()
    disconnectServer, disconnectServerPort = getNewServerWithArbitraryPort()
	setupInfoProviderServer()
end)

windower.register_event('unload', function()
	for ffxiCaddieServerPort,tcpObject in pairs(tcps) do
        windower.add_to_chat(10, "[ffxicaddieProvider]: disconnected from ffxicaddie (port: " .. ffxiCaddieServerPort .. ").")
	    tcpObject:close()
	    tcps[ffxiCaddieServerPort] = nil
	end
    
    if (connectServer ~= nil) then
        connectServer:close()
    end
    
    if (disconnectServer ~= nil) then
        disconnectServer:close()
    end
    
    if (infoProviderServer ~= nil) then
        infoProviderServer:close()
    end
end)

windower.register_event('logout', function(characterName)
	for ffxiCaddieServerPort,tcpObject in pairs(tcps) do
        windower.add_to_chat(10, "[ffxicaddieProvider]: disconnected from ffxicaddie (port: " .. ffxiCaddieServerPort .. ").")
	    tcpObject:close()
	    tcps[ffxiCaddieServerPort] = nil
	end
end)

windower.register_event('postrender', function()
    checkForNewDisconnectServerConnection()
    checkForNewConnectServerConnection()
    checkForNewInfoProviderServerConnection()

	sendZoneInfo()
	sendPlayerData()
	sendEntityInfo()
end)

windower.register_event('mouse', function(typeNumber, x, y, delta, blocked)
    -- typeNumber 0 is hover
    -- typeNumber 1 is left click down
    -- typeNumber 2 is left click up
    -- typeNumber 4 is right click down
    -- typeNumber 5 is right click up
    -- typeNumber 7 is middle click down
    -- typeNumber 8 is middle click up
    -- typeNumber 10 is mouse wheel

    if (typeNumber ~= 0 and typeNumber ~= 10) then
        sendActiveSignal()
    end
    
    return false -- indicate that the event has not been handled by returning false, that is pass it on to the next stage, returning true here would result in the event never reaching the game
end)

windower.register_event('keyboard', function(dik, flags, blocked)
    sendActiveSignal()
    return false -- indicate that the event has not been handled by returning false, that is pass it on to the next stage, returning true here would result in the event never reaching the game
end)

windower.register_event('addon command', function(...)
	local param = L{...}
	local command = param[1]
	local arg1 = param[2]
	local arg2 = param[3]
	local arg3 = param[4]
	
	if (command == 'reload') then
		windower.send_command("lua reload ffxicaddieProvider")
	end
end)

windower.register_event('incoming chunk', function(id, org, new, isInjected, isBlocked)
    if is_injected then return end
    if id == 0x00E or id == 0x00D or id == 0x00F then
        local entityIndex = org:unpack('H',9)
        if org:byte(11)%2 == 1 then -- First bit of byte 11 is a flag for position updating
            entityArray[entityIndex] = os.clock()
        end
    elseif id == 0x00B then
        entityArray = {}
    end
end)

windower.register_event('time change', function(newTime, oldTime)
	for entityIndex = #entityArray, 1, -1 do
		timeStamp = entityArray[entityIndex]
		currentTimeStamp = os.clock()
		if (timeStamp ~= nil and currentTimeStamp ~= nil) then
			timeStampNumber = tonumber(timeStamp)
			currentTimeStampNumber = tonumber(currentTimeStamp)
			if (timeStampNumber ~= nil and currentTimeStampNumber ~= nil) then
				table.remove(entityArray, entityIndex)
			end
		end
	end
end)

function setupInitialEntityArray()
    for id, entity in pairs(windower.ffxi.get_mob_array()) do
        entityArray[entity.index] = os.clock()
    end
end

function getNewServerWithArbitraryPort()
    local server = assert(socket.bind(host, 0)) -- we're happy that the operating system provides a port for us
    local ip, port = server:getsockname()
    server:settimeout(0)
    return server, port
end

function setupInfoProviderServer()
    if (infoProviderServer == nil) then
        repeat
            tcpSocket = assert(socket.tcp())
            local success, errorMessage = tcpSocket:bind(host, infoProviderPort)
            
            if (success == nil) then
                chooseNewInfoProviderPort()
            else
                tcpSocket:listen(100) -- transforms tcpSocket into a server object
                tcpSocket:settimeout(0)
                tcpSocket:setoption('reuseaddr', true)
                infoProviderServer = tcpSocket
            end
        until (infoProviderServer ~= nil)
    end
end

function checkForNewDisconnectServerConnection()
    if (disconnectServer ~= nil) then
        local client = disconnectServer:accept()
        if (client ~= nil) then
            lingerTable = {}
            lingerTable['on'] = true
            lingerTable['timeout'] = 0
            client:setoption('linger', lingerTable)
            client:settimeout(0)
            local message, errorMessage = client:receive()
            
            if (message ~= nil) then
                local disconnectMessageIdentificator = "disconnectFfxicaddieServerPort:"
                local indexOfDisconnectMessageIdentificator = message:find(disconnectMessageIdentificator)
                if (indexOfDisconnectMessageIdentificator == 1) then
                    local ffxiCaddieServerPort, numberOfSubstitutions = string.gsub(message, disconnectMessageIdentificator, "")
                    ffxiCaddieServerPort = tonumber(ffxiCaddieServerPort)
                    if (ffxiCaddieServerPort ~= nil) then
                        if (tcps[ffxiCaddieServerPort] ~= nil) then
                            tcps[ffxiCaddieServerPort]:close()
                            tcps[ffxiCaddieServerPort] = nil
                            windower.add_to_chat(10, "[ffxicaddieProvider]: disconnected from ffxicaddie (port: " .. ffxiCaddieServerPort .. ").")
                        end
                    end
                end
            else
                if (errorMessage ~= nil) then
                    windower.add_to_chat(10, "[ffxicaddieProvider]: unable to disconnect. Reason: " .. errorMessage)
                end
            end
        end
    end
end

function checkForNewConnectServerConnection()
    if (connectServer ~= nil) then
        local client = connectServer:accept()
        if (client ~= nil) then
            lingerTable = {}
            lingerTable['on'] = true
            lingerTable['timeout'] = 0
            client:setoption('linger', lingerTable)
            client:settimeout(0)
            local message, errorMessage = client:receive()
            
            if (message ~= nil) then
                local connectMessageIdentificator = "connectFfxicaddieServerPort:"
                local indexOfConnectMessageIdentificator = message:find(connectMessageIdentificator)
                if (indexOfConnectMessageIdentificator == 1) then
                    local ffxiCaddieServerPort, numberOfSubstitutions = string.gsub(message, connectMessageIdentificator, "")
                    ffxiCaddieServerPort = tonumber(ffxiCaddieServerPort)
                    if (ffxiCaddieServerPort ~= nil) then
                        local tcp = assert(socket.tcp())
                        tcp:connect(host, ffxiCaddieServerPort)
                        tcps[ffxiCaddieServerPort] = tcp
                        
                        local handshakeSuccess = sendHandShake(ffxiCaddieServerPort)
                        
                        if handshakeSuccess then
                            windower.add_to_chat(10, "[ffxicaddieProvider]: connected to ffxicaddie (port: " .. ffxiCaddieServerPort .. ").")
                            sendPlayerId()
                            setupInitialEntityArray()
                        else
                            windower.add_to_chat(10, "[ffxicaddieProvider]: unable to connect to ffxicaddie (port: " .. ffxiCaddieServerPort .. ").")
                            tcp:close()
                            tcps[ffxiCaddieServerPort] = nil
                        end
                    end
                end
            else
                if (errorMessage ~= nil) then
                    windower.add_to_chat(10, "[ffxicaddieProvider]: unable to connect. Reason: " .. errorMessage)
                end
            end
        end
    end
end

function chooseNewInfoProviderPort()
    infoProviderPort = infoProviderPort + 1
    if (infoProviderPort > infoProviderPortRangeStop) then
        infoProviderPort = infoProviderPortRangeStart
    end
end

function checkForNewInfoProviderServerConnection()
    if (infoProviderServer ~= nil) then
        local client = infoProviderServer:accept()
        if (client ~= nil) then
            lingerTable = {}
            lingerTable['on'] = true
            lingerTable['timeout'] = 0
            client:setoption('linger', lingerTable)
            client:settimeout(0)
            local player = windower.ffxi.get_player()
            local info = windower.ffxi.get_info()
            if (player ~= nil and info ~= nil and connectServerPort ~= nil and disconnectServerPort) then
                local serverName = "unknown"
                if (info.server ~= nil and res.servers[info.server] ~= nil and res.servers[info.server].name ~= nil) then
                   serverName = res.servers[info.server].name
                end
            
                client:send("caddieprovider[connectPort:" .. connectServerPort .. ",disconnectPort:" .. disconnectServerPort .. "]:" .. serverName .. "." .. player.name .. "\n")
            end
        end
    end
end

function sendHandShake(ffxicaddieServerPort)
	local handshakeCommand = string.reverse(string.pack('I', 1))
    local sendSuccess = false
    
    local player = windower.ffxi.get_player()
    local info = windower.ffxi.get_info()
	if (player ~= nil and info ~= nil) then
        local serverName = "unknown"
        if (info.server ~= nil and res.servers[info.server] ~= nil and res.servers[info.server].name ~= nil) then
           serverName = res.servers[info.server].name
        end
        
        local handshakeMessage = string.pack('izz', ffxicaddieServerPort, player.name, serverName)
        local handshakeMessageLength = string.reverse(string.pack('i', string.len(handshakeMessage)))
        local completeMessage = handshakeCommand .. handshakeMessageLength .. handshakeMessage
        sendSuccess = sendToFfxiCaddy(completeMessage, ffxicaddieServerPort)
    end

	return sendSuccess
end


function sendZoneInfo()
	local zoneInfoCommand = string.reverse(string.pack('I', 2))
	local sendSuccess = false

	local info = windower.ffxi.get_info()
	local player = windower.ffxi.get_player()
	if (info ~= nil and player ~= nil) then
		subMapId, mapX, mapY = windower.ffxi.get_map_data(player.index)
		if (info.zone ~= nil and subMapId ~= nil) then
			local zoneInfoMessage = string.pack('hhB', info.zone, subMapId, info.mog_house)
			local zoneInfoMessageLength = string.reverse(string.pack('i', string.len(zoneInfoMessage)))
			local completeMessage = zoneInfoCommand .. zoneInfoMessageLength .. zoneInfoMessage
			sendSuccess = sendToAllFfxiCaddies(completeMessage)
		end
	end

	return sendSuccess
end

function sendPlayerData()
	local playerDataCommand = string.reverse(string.pack('I', 3))
	local sendSuccess = false

	local player = windower.ffxi.get_player()
	if (player ~= nil) then
		entity = windower.ffxi.get_mob_by_id(player.id)
		if (entity ~= nil) then
			local subMapId, mapX, mapY = windower.ffxi.get_map_data(player.index)
            local isMapPosition = true
            local xPos = mapX
            local yPos = mapY
            if (xPos == nil or yPos == nil or xPos == 0 or yPos == 0) then
                isMapPosition = false
                xPos = entity.x
                yPos = entity.y
            end
            
			local playerDataMessage = string.pack('Bfff', isMapPosition, xPos, yPos, entity.facing)
            local playerDataMessageLength = string.reverse(string.pack('i', string.len(playerDataMessage)))
            local completeMessage = playerDataCommand .. playerDataMessageLength .. playerDataMessage
            sendSuccess = sendToAllFfxiCaddies(completeMessage)
		end
	end

	return sendSuccess
end

function sendEntityInfo()
	local entityInfoCommand = string.reverse(string.pack('I', 4))
	local entityInfoMessage = ""
	
	for entityIndex, entity in pairs(entityArray) do 
		entityInfo = windower.ffxi.get_mob_by_index(entityIndex)
		if entityInfo ~= nil and entityInfo.valid_target then
			local entityInfoSubMapId, entityInfoMapX, entityInfoMapY = windower.ffxi.get_map_data(entityInfo.x, entityInfo.y, entityInfo.z)
            local isMapPosition = true
            local xPos = entityInfoMapX
            local yPos = entityInfoMapY
            if (xPos == nil or yPos == nil or xPos == 0 or yPos == 0) then
                isMapPosition = false
                xPos = entityInfo.x
                yPos = entityInfo.y
            end
            
			local entityData = string.pack('izhcfBff', entityInfo.id, entityInfo.name, entityInfoSubMapId, entityInfo.spawn_type, entityInfo.facing, isMapPosition, xPos, yPos)
			entityInfoMessage = entityInfoMessage .. entityData
		end
	end
	
	local entityInfoMessageLength = string.reverse(string.pack('i', string.len(entityInfoMessage)))
	local completeMessage = entityInfoCommand .. entityInfoMessageLength .. entityInfoMessage
	local sendSuccess = sendToAllFfxiCaddies(completeMessage)
	return sendSuccess
end

function sendPlayerId()
	local playerIdCommand = string.reverse(string.pack('I', 5))
	local sendSuccess = false

	local player = windower.ffxi.get_player()
	if (player ~= nil) then
		local playerIdMessage = string.pack('i', player.id)
		local playerIdMessageLength = string.reverse(string.pack('i', string.len(playerIdMessage)))
		local completeMessage = playerIdCommand .. playerIdMessageLength .. playerIdMessage
		sendSuccess = sendToAllFfxiCaddies(completeMessage)
	end

	return sendSuccess
end

function sendActiveSignal()
	local activeSignalCommand = string.reverse(string.pack('I', 6))
	local sendSuccess = false

	local player = windower.ffxi.get_player()
	if (player ~= nil) then
		local activeSignalMessageLength = string.reverse(string.pack('i', 0)) -- zero length, just need to tell we're active
		local completeMessage = activeSignalCommand .. activeSignalMessageLength
		sendSuccess = sendToAllFfxiCaddies(completeMessage)
	end

	return sendSuccess
end

function sendToAllFfxiCaddies(message)
	local sendSuccess = true
    
	local info = windower.ffxi.get_info()
    if info.logged_in then
		for ffxicaddieServerPort,tcpObject in pairs(tcps) do -- send to each server (ffxicaddie instance)
			local sendComplete = tcpObject:send(message)
			
			if (sendComplete ~= nil) then
				sendSuccess = sendSuccess and true
			else
				sendSuccess = sendSuccess and false
				
				tcpObject:close()
				tcps[ffxicaddieServerPort] = nil
				
				windower.add_to_chat(10, "[ffxicaddieProvider]: disconnected from ffxicaddie (port: " .. ffxicaddieServerPort .. ").")
			end
		end
    end
    
	return sendSuccess
end

function sendToFfxiCaddy(message, specifiedServerPort)
	local sendSuccess = false

	local info = windower.ffxi.get_info()
    if info.logged_in then
		for ffxicaddieServerPort,tcpObject in pairs(tcps) do -- send to each server (ffxicaddie instance)
            if (specifiedServerPort == ffxicaddieServerPort) then
                local sendComplete = tcpObject:send(message)
                
                if (sendComplete ~= nil) then
                    sendSuccess = true
                else
                    tcpObject:close()
                    tcps[ffxicaddieServerPort] = nil
                    
                    windower.add_to_chat(10, "[ffxicaddieProvider]: disconnected from ffxicaddie (port: " .. ffxicaddieServerPort .. ").")
                end
             end
		end
    end

	return sendSuccess
end
