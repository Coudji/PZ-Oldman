require "OldMan_Config"
require "OldMan_Phobias"

local lastSoundAt = {}

local function onClientCommand(module, command, player, args)
    if module ~= "OldManMode" or command ~= "worldSound" or not player then return end
    if not player:HasTrait(OldMan.Config.traitId) then return end
    local phobia = args and OldMan.Phobias[args.phobia]
    if not phobia or phobia.enabled == false then return end

    local now = getGameTime():getWorldAgeHours()
    if lastSoundAt[player] and now - lastSoundAt[player] < OldMan.Config.serverSoundCooldownHours then return end
    lastSoundAt[player] = now

    local radius = math.max(1, math.min(40, OldMan.GetPhobiaValue(phobia, "worldSoundRadius")))
    local volume = math.max(1, math.min(50, OldMan.GetPhobiaValue(phobia, "worldSoundVolume")))
    addSound(player, player:getX(), player:getY(), player:getZ(), radius, volume)
end

Events.OnClientCommand.Add(onClientCommand)
