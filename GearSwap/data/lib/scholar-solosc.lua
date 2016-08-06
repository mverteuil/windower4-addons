--[[
Gearswap rules to perform a skillchain solo
@author : Pulsahr (Carbuncle server)

Don't ask me to enhance it to repeat itself until mob's death. This is botting to me, and I don't do this shit. Don't ever ask.

-- #########################
-- INSTALLATION
-- #########################

1. INCLUDES
include this file in your SCH gearswap by copying it in addons/GearSwap/data/ and put at the bottom of your main SCH file :
include('SCH_soloSC.lua')
Also copy and include the info skillchain file :
include('common_info.skillchain.lua')


2. ADDING FUNCTIONS
If you don't have the following functions, copy paste them as is :
(hint : paste it in your main sch file, so if you later get an update to this file, you won't have to edit it)
--------------------------------------
-- GET NB STRATAGEMS
--------------------------------------
-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
-- Source : SCH file found in https://github.com/Kinematics/GearSwap-Jobs
function getNbStratagems()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]
    local maxStrategems = math.floor((player.main_job_level + 10) / 20)
    local fullRechargeTime = 4*60 -- change 60 with 45 if you have unlocked the job point gift on stratagem recast
    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)
    return currentCharges
end

--------------------------------------
-- ERRLOG
--------------------------------------
function errlog(msg) 
  add_to_chat(167,msg)
end


3. CUSTOM COMMAND
You need to add the custom command for calling the solo skillchain function.
Find the "job_self_command" in your main script. If it doesn't exist, create it as follow :
function job_self_command(cmdParams, eventArgs)
-- insert code here
end

Insert the following code :

  if cmdParams[1] == 'soloSC' then
    if not cmdParams[2] or not cmdParams[3] then
      errlog('missing required parameters for function soloSkillchain')
      return
    else
      soloSkillchain(cmdParams[2],cmdParams[3],cmdParams[4],cmdParams[5])
    end
  end
 

-- #########################
-- INFORMATION
-- #########################

This file contains only the functions required for the soloSC command :
soloSkillchain
getSpellsForSC

Make sure you adjusted the constants in both functions.
the constants part looks like this :

--**************************************************
-- CONSTANTS
some variables to adjust
--**************************************************

The constants in second function are more critical, they contains the cast time for helix and tier1. If too short, you won't be able to cast Immanence, screwing the whole solo SC process.


-- #########################
-- KNOWN ISSUES
-- #########################

1. Why Distortion doesn't work ?
You need some time after a helix to be able to skillchain. If your cast time is 6s, put 7 in the constants and try again. It worked for me.
My hypothesis : it needs the first tick of dot before the next immannenced spell lands. Didn't check. Don't plan to. Feel free to !

2. getStratagems function doesn't work correctly
You probably have a decreased recast time on your stratagems. If you leave it as is, you won't have error, but might be incorrectly rejected for a lack of stratagems. Replace the 60 with 45 as said in the comment on the desired line.

3. The last skillchain didn't happen
You probably made a long skillchain combo (3 ?), and the last one was a bit off the skillchain window. Tune your cast time, or reduce your number of SC.
--]]

--------------------------------------
-- SOLO SKILLCHAIN
--------------------------------------
--[[
@param integer|string nbSC : Number of SkillChains to do, between 1 and 3 or "max".
@param string elementEnd : final SC element (Fusion, Scission, ...).
@param bool MB : if true, will cast the tier V corresponding to the MB. Default is false.
@param bool STFU : if true, no message in party. Default is false.

Usage example : 
/console gs c soloSC 1 Fusion
=> will do 1 skillchain, ending with Fusion : Fire, Thunder. Equivalent to /console gs c soloSC 1 Fusion false false
/console gs soloSC 3 Fragmentation
=> will do 3 skillchains, ending with Fragmentation : Stone, Water, Blizzard, Water
/console gs soloSC max Fusion
=> will spend all stratagems to perform skillchains, ending with Fusion
/console gs c soloSC 1 Fusion true
=> will do 1 SC Fusion, and cast Fire V for magic burst
/console gs c soloSC 1 Fusion true true
=> will do 1 SC Fusion and cast Fire V for magic burst, with no information displayed in party chat
--]]
function soloSkillchain(nbSC,elementEnd,MB,STFU)
--**************************************************
-- CONSTANTS
-- If you have access to helix II and are ok to use them, set to true
local useHelixII = false
--**************************************************

add_to_chat(200,'========== soloSkillchain ==========')

  elementEnd = tostring(elementEnd)
  if not STFU then
    STFU=false
  elseif STFU=='true' then
    STFU=true
  else
    STFU=false
  end
  
  if not MB then
    MB=false
  elseif MB=='true' then
    MB=true
  else
    MB=false
  end

  local plural = ''

-- Checking parameters
  if not elementEnd then
    errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
    return
  elseif elementEnd=='' then
    errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
  end --if not elementEnd

  if not info.skillchain.tier1:contains(elementEnd) and not info.skillchain.tier2:contains(elementEnd) then
    errlog('Finale SC not recognized : '..elementEnd)
    return
  end -- if not info.skillchain.tier1:contains(elementEnd) ...  

   local nbStrat = get_current_strategem_count()            --local nbStrat = getNbStratagems()

  if not nbSC then
    errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
    return
  else
    if nbSC == 'max' then
      nbSC = nbStrat-1
      if buffactive["Tabula Rasa"] then nbSC = 4 end
  end

    nbSC = tonumber(nbSC)
  if nil==nbSC then
      errlog("Shitty parameters : nbSC isn't a number")
      return
    else
      if nbSC>1 then plural='s' end

      if nbSC>4 then
        errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
        return
    elseif (nbSC >= nbStrat) then
        errlog("Not enough stratagems for "..tostring(nbSC).." skillchain"..plural.." : "..tostring(nbStrat)..'/'..tostring(nbSC+1))
        return
      end --if nbSC>4
  end --if nil==nbSC then
  end --else [if not nbSC]

-- Parameters OK.

-- Retrieving lists of spells needed
 spellsSC = getSpellsForSC(nbSC,elementEnd)

 
  local wait = {}
  wait.postImmanence = 1
  local commandSoloSC = '' -- 

  -- Checking you didn't forget Dark Arts
  state.Buff["Dark Arts"] = buffactive["Dark Arts"] or false
  state.Buff["Addendum: Black"] = buffactive["Addendum: Black"] or false
  if not state.Buff["Dark Arts"] and not state.Buff["Addendum: Black"] then
    local spellRecasts = windower.ffxi.get_ability_recasts()
    -- recast id for "Dark Arts" = 232
    if spellRecasts[232] > 0 then
      errlog("ABORT : 'Dark Arts' required and not ready")
      return
    else
      commandSoloSC = commandSoloSC..'input /ja "Dark Arts" <me>;wait 1.5;'
      -- we deactivate MB option, to not mess with stratagem count expected by player
      MB = false
    end
  end  
  
  -- Let's build the command. And if not STFU, let's build the chat spam too muahaha.
  if not STFU then
    commandSoloSC = commandSoloSC..'input /p Starting '..tostring(nbSC)..' Skillchain'..plural..' : '
  for i=1,nbSC,1 do
    if i>1 then commandSoloSC = commandSoloSC..',' end
    commandSoloSC = commandSoloSC..' '..spellsSC[i].SC
  end -- for
  commandSoloSC = commandSoloSC..' <call20>;'
  end --if not STFU

    -- If twice the same helix is used : abort
  local helixUsed = {}
  helixUsed.light = false
  helixUsed.dark = false
  local msgDebug = ''

------------
-- ZE LOOP

  for i=0,nbSC,1 do
  commandCurrentRound = ''
    -- Multiple helix usage check
    if spellsSC[i].magic =='Luminohelix' then
      if helixUsed.light==true then
      -- already used, recast will prevent to chain
    if not (useHelixII==true) then
        errlog("Recast problem : Luminohelix required more than once, aborting.")
        return
    else
      spellsSC[i].magic = '"Luminohelix II"'
      spellsSC[i].castTime = spellsSC[i].castTime+1
    end -- if not (useHelixII==true)
    else
      helixUsed.light=true
    end
    end -- if spellsSC[i].magic =='Luminohelix'

    if spellsSC[i].magic =='Noctohelix' then
      if helixUsed.dark==true then
      if not (useHelixII==true) then
        errlog("Recast problem : Noctohelix required more than once, aborting.")
        return
    else
      spellsSC[i].magic = '"Noctohelix II"'
      spellsSC[i].castTime = spellsSC[i].castTime+1
    end -- if not (useHelixII==true)
    else
      helixUsed.dark=true
    end --if helixUsed.dark==true
    end -- if spellsSC[i].magic =='Noctohelix'
  
    commandCurrentRound = commandCurrentRound..'input /ja Immanence <me>;wait '..tostring(wait.postImmanence)..';'
    commandCurrentRound = commandCurrentRound..'input /ma '..spellsSC[i].magic..' <t>;'
  
  -- calculating waiting times
  -- the higher the SC, the shorter the SC window to next
  wait.windowMB = 7
  if (i==3) then
    wait.windowMB = 6
  elseif (i==4) then
    wait.windowMB = 4
  end

  wait.beforeNextSpell = spellsSC[i].castTime -- between "/p MB NOW !" and next Immanence
  castTimeSpellAfter = 0
  if(i<nbSC) then
    castTimeSpellAfter = spellsSC[i+1].castTime
    -- if this is not the first spell, we maximise the MB window to 7s. 8 sometime fails to SC.
    if (i>0) then
      wait.beforeNextSpell = math.max(0,(wait.windowMB - castTimeSpellAfter - wait.postImmanence))
    end
  end
--add_to_chat(200,tostring(i)..' : '..spellsSC[i].magic..', cast='..tostring(spellsSC[i].castTime)..', wait.beforeNextSpell='..tostring(wait.beforeNextSpell))

  -- info sur la SC en chan pt
  if not STFU and i>0 then
    commandCurrentRound = commandCurrentRound..'input /p ['..spellsSC[i].SC..'] in '..tostring(spellsSC[i].castTime)..'s : '
      commandCurrentRound = commandCurrentRound..'MB '..info.skillchain[ spellsSC[i].SC ].MB
    if i<nbSC then -- we're not done yet, we inform the pt
      commandCurrentRound = commandCurrentRound..' (next SC : ['..spellsSC[i+1].SC..'] in ~'..tostring(wait.beforeNextSpell + wait.postImmanence + castTimeSpellAfter)..'s)'
    end --if i<nbSC
    commandCurrentRound = commandCurrentRound..';'
  end -- if not STFU and i>0

  if i==nbSC then 
    commandCurrentRound = commandCurrentRound.."input /echo ========== DONE ==========;"
  end
  
    commandCurrentRound = commandCurrentRound..'wait '..tostring(spellsSC[i].castTime)..';'
  
  if(i>0) then
    if not STFU then
      -- MB NOW !
      commandCurrentRound = commandCurrentRound..'input /p MB '..info.skillchain[ spellsSC[i].SC ].MB..' NOW !;'
    end

    if i<nbSC then
      -- "+1" because we need one second after the cast to be able to JA or start casting MB
      commandCurrentRound = commandCurrentRound..'wait '..tostring(wait.beforeNextSpell + 1)..';'
    end --if i<nbSC or MB==true
  else
      commandCurrentRound = commandCurrentRound..'wait 1;'
  end --if(i>0)
  commandSoloSC = commandSoloSC..commandCurrentRound
  end  -- for

-- LOOP END
------------

  if MB then
    local spellMB = ''
    if elementEnd=='Fusion' or elementEnd=='Liquefaction' then
      spellMB = 'Fire V'
    elseif elementEnd=='Gravitation' or elementEnd=='Scission' then
      spellMB = 'Stone V'
    elseif elementEnd=='Distortion' or elementEnd=='Induration' then
      spellMB = 'Blizzard V'
    elseif elementEnd=='Fragmentation' or elementEnd=='Impaction' then
      spellMB = 'Thunder V'
    elseif elementEnd=='Reverberation' then
      spellMB = 'Water V'
    elseif elementEnd=='Detonation' then
      spellMB = 'Aero V'
  elseif elementEnd=='Transfixion' then
      spellMB = 'Luminohelix II'
  elseif elementEnd=='Compression' then
      spellMB = 'Noctohelix II'
    end
    if spellMB~='' then 
      -- only a little wait is needed, we already waited for seconds corresponding to castTime
      commandSoloSC = commandSoloSC..'wait 1;input /ma "'..spellMB..'" <t>'
    end
  end

  --add_to_chat(200,commandSoloSC)  -- for debug purpose
  send_command(commandSoloSC)
end



--------------------------------------
-- GET SPELLS FOR SC
--------------------------------------
-- Returns the spells required for the SC
-- do not call this function alone. It has to be called from soloSC and only there.
-- @param nbSC : number of SC to do
-- @param elementSCFinale : ex 'Liquefaction' /!\ NO CHECKING, 'Light' => non handled error
-- @return tabSpells
function getSpellsForSC(nbSC,elementSCFinale)
  nbSC = tonumber(nbSC)
  if nbSC>4 then nbSC=4 end
  if nbSC<1 then
    errlog('Dafuq ? '..tostring(nbSC)..' SC ?')
  return spellsSC
  end
  
  local spellsSC = {}
  spellsSC[0] = {}
  spellsSC[0].magic = 'undefined'
  spellsSC[0].castTime = -1
  spellsSC[0].SC = ''
  
  spellsSC[1] = {}
  spellsSC[1].magic = 'undefined'
  spellsSC[1].castTime = -1
  spellsSC[1].SC = ''
  
  spellsSC[2] = {}
  spellsSC[2].magic = 'undefined'
  spellsSC[2].castTime = -1
  spellsSC[2].SC = ''
  
  spellsSC[3] = {}
  spellsSC[3].magic = 'undefined'
  spellsSC[3].castTime = -1
  spellsSC[3].SC = ''
  
  spellsSC[4] = {}
  spellsSC[4].magic = 'undefined'
  spellsSC[4].castTime = -1
  spellsSC[4].SC = ''


  local wait = {}
  wait.postImmanence = 1
  local castTime = {}
  
  --**************************************************
  -- CONSTANTS
  -- tune this according to your cast time
  castTime.helix = 5
  castTime.tier1 = 3
  --**************************************************


  -- Wall of shit defining all the elements used for SC.
  local dataSC = {}
  local el = '' -- For reading convenience, will store current SC element.
    
  -- Tier 1
  el = 'Transfixion'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Noctohelix'
  dataSC[el].open.SC = 'Compression'
  dataSC[el].open.castTime = castTime.helix
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Luminohelix'
  dataSC[el].close.castTime = castTime.helix

  el = 'Compression'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Luminohelix'
  dataSC[el].open.SC = 'Transfixion'
  dataSC[el].open.castTime = castTime.helix
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Noctohelix'
  dataSC[el].close.castTime = castTime.helix
  
  -- some of the following settings are arbitrary : let's prioritize elemental to light/dark, and focus on most powerful ones : fire/blizzard/thunder
  el = 'Liquefaction'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Thunder'
  dataSC[el].open.SC = 'Impaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Fire'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Scission'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Fire'
  dataSC[el].open.SC = 'Liquefaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Stone'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Reverberation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Stone'
  dataSC[el].open.SC = 'Scission'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Water'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Detonation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Thunder'
  dataSC[el].open.SC = 'Impaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Aero'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Induration'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Water'
  dataSC[el].open.SC = 'Reverberation'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Blizzard'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Impaction'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Blizzard'
  dataSC[el].open.SC = 'Induration'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Thunder'
  dataSC[el].close.castTime = castTime.tier1
 
 
  -- Tier 2
  
  el = 'Fusion'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Fire'
  dataSC[el].open.SC = 'Liquefaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Thunder'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Gravitation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Aero'
  dataSC[el].open.SC = 'Detonation'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Noctohelix'
  dataSC[el].close.castTime = castTime.helix
  
  el = 'Fragmentation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Blizzard'
  dataSC[el].open.SC = 'Induration'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Water'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Distortion'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Luminohelix'
  dataSC[el].open.SC = 'Transfixion'
  dataSC[el].open.castTime = castTime.helix
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Stone'
  dataSC[el].close.castTime = castTime.tier1

  
  local elementSC = {} -- SC element for each step
  elementSC[1] = ''
  elementSC[2] = ''
  elementSC[3] = ''
  elementSC[4] = ''
  
  elementSC[nbSC] = elementSCFinale
  
  -- Now we define the spells to chain. Warning, wall of code incoming.
  local step
  local elementSCEnCours

  for step=nbSC,1,-1 do
    -- Retrieving the SC element for this step.
    elementSCEnCours = elementSC[step]
  -- Retrieving spell.
  spellsSC[step].SC = elementSCEnCours
  spellsSC[step].magic= dataSC[elementSCEnCours].close.magic
  spellsSC[step].castTime = dataSC[elementSCEnCours].close.castTime

  -- Let's define the SC required for previous step.
  if step>1 then
    elementSC[step-1] = dataSC[elementSCEnCours].open.SC
  end
  end

  spellsSC[0].magic= dataSC[ elementSC[1] ].open.magic
  spellsSC[0].castTime = dataSC[ elementSC[1] ].open.castTime
  -- Oh look, we're already done ! I'm a genius. #hohoho

  return spellsSC
end -- function getSpellsForSC