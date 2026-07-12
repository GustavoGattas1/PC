local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1
L0_1 = config
if not L0_1 then
  L0_1 = error
  L1_1 = "[criticalscripts.shop] cs-hall configuration file has a syntax error, please resolve it otherwise the resource will not work."
  L0_1(L1_1)
  return
end
L0_1 = config
L0_1 = L0_1.updatesCheck
if L0_1 then
  L0_1 = GetResourceMetadata
  L1_1 = GetCurrentResourceName
  L1_1 = L1_1()
  L2_1 = "version"
  L3_1 = 0
  L0_1 = L0_1(L1_1, L2_1, L3_1)
  L1_1 = PerformHttpRequest
  L2_1 = "https://updates.criticalscripts.com/cs-hall"
  function L3_1(A0_2, A1_2, A2_2)
    local L3_2, L4_2, L5_2, L6_2
    if 200 == A0_2 then
      L3_2 = json
      L3_2 = L3_2.decode
      L4_2 = A1_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        L4_2 = L3_2.version
        L5_2 = L0_1
        if L4_2 ~= L5_2 then
          L4_2 = print
          L5_2 = "[criticalscripts.shop] Resource \"cs-hall\" is outdated, please download the latest version through your keymaster."
          L4_2(L5_2)
        else
          L4_2 = print
          L5_2 = "[criticalscripts.shop] Resource \"cs-hall\" is up to date."
          L4_2(L5_2)
        end
        L4_2 = L3_2.message
        if L4_2 then
          L4_2 = print
          L5_2 = "[criticalscripts.shop] "
          L6_2 = L3_2.message
          L5_2 = L5_2 .. L6_2
          L4_2(L5_2)
        end
      else
        L4_2 = print
        L5_2 = "[criticalscripts.shop] Resource \"cs-hall\" failed to perform update check."
        L4_2(L5_2)
      end
    else
      L3_2 = print
      L4_2 = "[criticalscripts.shop] Resource \"cs-hall\" failed to perform update check."
      L3_2(L4_2)
    end
  end
  L4_1 = "GET"
  L5_1 = ""
  L6_1 = {}
  L1_1(L2_1, L3_1, L4_1, L5_1, L6_1)
end
L0_1 = {}
L1_1 = {}
L2_1 = {}
L3_1 = {}
L4_1 = 500
L5_1 = false
L6_1 = pairs
L7_1 = config
L7_1 = L7_1.entries
L6_1, L7_1, L8_1, L9_1 = L6_1(L7_1)
for L10_1, L11_1 in L6_1, L7_1, L8_1, L9_1 do
  L12_1 = {}
  L13_1 = {}
  L13_1.playing = false
  L13_1.stopped = true
  L13_1.time = 0
  L14_1 = L11_1.maxVolumePercent
  if L14_1 then
    L14_1 = 0.5
    L15_1 = L11_1.maxVolumePercent
    L15_1 = L15_1 / 100
    if L14_1 > L15_1 then
      L14_1 = L11_1.maxVolumePercent
      L14_1 = L14_1 / 100
      if L14_1 then
        goto lbl_65
      end
    end
  end
  L14_1 = 0.5
  ::lbl_65::
  L13_1.volume = L14_1
  L13_1.loop = false
  L13_1.url = nil
  L13_1.thumbnailUrl = nil
  L13_1.thumbnailTitle = nil
  L13_1.title = nil
  L13_1.icon = nil
  L13_1.duration = nil
  L12_1.media = L13_1
  L13_1 = {}
  L13_1.advancingAt = nil
  L13_1.advancedAt = nil
  L13_1.retractingAt = nil
  L13_1.retractedAt = nil
  L12_1.screens = L13_1
  L13_1 = {}
  L13_1.lastTriggeredAt = nil
  L12_1.smoke = L13_1
  L13_1 = {}
  L13_1.lastTriggeredAt = nil
  L12_1.sparklers = L13_1
  L13_1 = {}
  L13_1.bassSmoke = false
  L13_1.bassSparklers = false
  L13_1.whiteSpotlights = false
  L13_1.dynamicSpotlights = false
  L13_1.scenesEnabled = false
  L13_1.photorythmicSpotlights = true
  L13_1.videoToggle = true
  L12_1.settings = L13_1
  L12_1.updater = nil
  L12_1.controller = nil
  L3_1[L10_1] = L12_1
  L12_1 = {}
  L0_1[L10_1] = L12_1
end
L6_1 = GetResourceKvpString
L7_1 = "data"
L6_1 = L6_1(L7_1)
L7_1 = GetResourceKvpString
L8_1 = "queue"
L7_1 = L7_1(L8_1)
if L6_1 then
  L8_1 = json
  L8_1 = L8_1.decode
  L9_1 = L6_1
  L8_1 = L8_1(L9_1)
  L6_1 = L8_1
  if L6_1 then
    L8_1 = pairs
    L9_1 = L6_1
    L8_1, L9_1, L10_1, L11_1 = L8_1(L9_1)
    for L12_1, L13_1 in L8_1, L9_1, L10_1, L11_1 do
      L14_1 = config
      L14_1 = L14_1.entries
      L14_1 = L14_1[L12_1]
      if L14_1 then
        L14_1 = L6_1[L12_1]
        if L14_1 then
          L14_1 = L6_1[L12_1]
          L15_1 = L6_1[L12_1]
          L15_1 = L15_1.media
          if not L15_1 then
            L15_1 = {}
          end
          L14_1.media = L15_1
          L14_1 = L6_1[L12_1]
          L15_1 = L6_1[L12_1]
          L15_1 = L15_1.smoke
          if not L15_1 then
            L15_1 = {}
          end
          L14_1.smoke = L15_1
          L14_1 = L6_1[L12_1]
          L15_1 = L6_1[L12_1]
          L15_1 = L15_1.sparklers
          if not L15_1 then
            L15_1 = {}
          end
          L14_1.sparklers = L15_1
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.smoke
          if L14_1 then
            L14_1 = L6_1[L12_1]
            L14_1 = L14_1.smoke
            L14_1.lastTriggeredAt = nil
          end
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.sparklers
          if L14_1 then
            L14_1 = L6_1[L12_1]
            L14_1 = L14_1.sparklers
            L14_1.lastTriggeredAt = nil
          end
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.media
          L14_1.time = 0
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.media
          L14_1.duration = nil
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.media
          L14_1.stopped = true
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.media
          L14_1.playing = false
          L14_1 = L6_1[L12_1]
          L14_1 = L14_1.media
          L15_1 = config
          L15_1 = L15_1.entries
          L15_1 = L15_1[L12_1]
          L15_1 = L15_1.maxVolumePercent
          if L15_1 then
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.media
            L15_1 = L15_1.volume
            L16_1 = config
            L16_1 = L16_1.entries
            L16_1 = L16_1[L12_1]
            L16_1 = L16_1.maxVolumePercent
            L16_1 = L16_1 / 100
            if L15_1 > L16_1 then
              L15_1 = config
              L15_1 = L15_1.entries
              L15_1 = L15_1[L12_1]
              L15_1 = L15_1.maxVolumePercent
              L15_1 = L15_1 / 100
              if L15_1 then
                goto lbl_215
              end
            end
          end
          L15_1 = L6_1[L12_1]
          L15_1 = L15_1.media
          L15_1 = L15_1.volume
          ::lbl_215::
          L14_1.volume = L15_1
          L14_1 = L6_1[L12_1]
          L14_1.controller = nil
          L14_1 = L6_1[L12_1]
          L14_1.updater = nil
          L14_1 = 0
          L15_1 = config
          L15_1 = L15_1.entries
          L15_1 = L15_1[L12_1]
          L15_1 = L15_1.screens
          if L15_1 then
            L15_1 = 1
            L16_1 = config
            L16_1 = L16_1.entries
            L16_1 = L16_1[L12_1]
            L16_1 = L16_1.screens
            L16_1 = #L16_1
            L17_1 = 1
            for L18_1 = L15_1, L16_1, L17_1 do
              L19_1 = config
              L19_1 = L19_1.entries
              L19_1 = L19_1[L12_1]
              L19_1 = L19_1.screens
              L19_1 = L19_1[L18_1]
              L19_1 = L19_1.advance
              L19_1 = L19_1.durationMs
              if L14_1 < L19_1 then
                L19_1 = config
                L19_1 = L19_1.entries
                L19_1 = L19_1[L12_1]
                L19_1 = L19_1.screens
                L19_1 = L19_1[L18_1]
                L19_1 = L19_1.advance
                L14_1 = L19_1.durationMs
              end
            end
          end
          L15_1 = L6_1[L12_1]
          L16_1 = L6_1[L12_1]
          L16_1 = L16_1.screens
          if not L16_1 then
            L16_1 = {}
          end
          L15_1.screens = L16_1
          L15_1 = L6_1[L12_1]
          L15_1 = L15_1.screens
          if L15_1 then
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.screens
            L15_1 = L15_1.advancedAt
            if L15_1 then
              L15_1 = L6_1[L12_1]
              L15_1 = L15_1.screens
              L15_1 = L15_1.retractedAt
              if not L15_1 then
             --   goto lbl_287
              end
            end
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.screens
            L15_1 = L15_1.advancedAt
            if L15_1 then
              L15_1 = L6_1[L12_1]
              L15_1 = L15_1.screens
              L15_1 = L15_1.advancedAt
              L16_1 = L6_1[L12_1]
              L16_1 = L16_1.screens
              L16_1 = L16_1.retractedAt
              ::lbl_287::
              if (L16_1 == nil) or (L15_1 > L16_1) then
                L15_1 = L6_1[L12_1]
                L15_1 = L15_1.screens
                L16_1 = GetGameTimer
                L16_1 = L16_1()
                L15_1.advancingAt = L16_1
                L15_1 = L6_1[L12_1]
                L15_1 = L15_1.screens
                L16_1 = GetGameTimer
                L16_1 = L16_1()
                L16_1 = L16_1 + L14_1
                L15_1.advancedAt = L16_1
                L15_1 = L6_1[L12_1]
                L15_1 = L15_1.screens
                L15_1.retractingAt = nil
                L15_1 = L6_1[L12_1]
                L15_1 = L15_1.screens
                L15_1.retractedAt = nil
            end
          end
          else
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.screens
            L15_1.advancingAt = nil
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.screens
            L15_1.advancedAt = nil
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.screens
            L16_1 = GetGameTimer
            L16_1 = L16_1()
            L15_1.retractingAt = L16_1
            L15_1 = L6_1[L12_1]
            L15_1 = L15_1.screens
            L16_1 = GetGameTimer
            L16_1 = L16_1()
            L16_1 = L16_1 + L14_1
            L15_1.retractedAt = L16_1
          end
        end
      end
    end
    L8_1 = pairs
    L9_1 = L3_1
    L8_1, L9_1, L10_1, L11_1 = L8_1(L9_1)
    for L12_1, L13_1 in L8_1, L9_1, L10_1, L11_1 do
      L14_1 = L6_1[L12_1]
      if L14_1 then
        L14_1 = CopyAndMerge
        L15_1 = L3_1[L12_1]
        L16_1 = L6_1[L12_1]
        L14_1 = L14_1(L15_1, L16_1)
        L3_1[L12_1] = L14_1
      end
    end
  end
end
if L7_1 then
  L8_1 = json
  L8_1 = L8_1.decode
  L9_1 = L7_1
  L8_1 = L8_1(L9_1)
  L7_1 = L8_1
  if L7_1 then
    L8_1 = pairs
    L9_1 = L0_1
    L8_1, L9_1, L10_1, L11_1 = L8_1(L9_1)
    for L12_1, L13_1 in L8_1, L9_1, L10_1, L11_1 do
      L14_1 = config
      L14_1 = L14_1.entries
      L14_1 = L14_1[L12_1]
      if L14_1 then
        L14_1 = L7_1[L12_1]
        if L14_1 then
          L14_1 = L7_1[L12_1]
          L0_1[L12_1] = L14_1
        end
      end
    end
  end
end
function L8_1(A0_2, A1_2)
  local L2_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2.updater
  L2_2 = L2_2 == A1_2
  return L2_2
end
IsAllowedToUpdate = L8_1
function L8_1(A0_2, A1_2)
  local L2_2
  L2_2 = L2_1
  L2_2 = L2_2[A1_2]
  L2_2 = L2_2 == A0_2
  return L2_2
end
IsAllowedToControl = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.controller
  if L1_2 then
    L1_2 = GetPlayerEndpoint
    L2_2 = L3_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2.controller
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = TriggerClientEvent
      L2_2 = "cs-hall:controller"
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.controller
      L4_2 = A0_2
      L5_2 = false
      L1_2(L2_2, L3_2, L4_2, L5_2)
    end
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2.controller = nil
end
ClearController = L8_1
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L2_2.controller = A1_2
  L2_2 = TriggerClientEvent
  L3_2 = "cs-hall:controller"
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  L4_2 = L4_2.controller
  L5_2 = A0_2
  L6_2 = true
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
SetController = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.updater
  if L1_2 then
    L1_2 = GetPlayerEndpoint
    L2_2 = L3_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2.updater
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = TriggerClientEvent
      L2_2 = "cs-hall:updater"
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.updater
      L4_2 = A0_2
      L5_2 = false
      L1_2(L2_2, L3_2, L4_2, L5_2)
    end
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2.updater = nil
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.controller
  if L1_2 then
    L1_2 = L3_1
    L1_2 = L1_2[A0_2]
    L2_2 = L1_2.controller
    L1_2 = L1_1
    L1_2 = L1_2[L2_2]
    if L1_2 == A0_2 then
      L1_2 = L3_1
      L1_2 = L1_2[A0_2]
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.controller
      L1_2.updater = L2_2
  end
  else
    L1_2 = pairs
    L2_2 = L1_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L1_1
      L7_2 = L7_2[L5_2]
      if L7_2 == A0_2 then
        L7_2 = L3_1
        L7_2 = L7_2[A0_2]
        L7_2.updater = L5_2
        break
      end
    end
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.updater
  if L1_2 then
    L1_2 = TriggerClientEvent
    L2_2 = "cs-hall:updater"
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.updater
    L4_2 = A0_2
    L5_2 = true
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
end
RefreshCurrentUpdater = L8_1
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if A1_2 then
    L2_2 = TriggerClientEvent
    L3_2 = "cs-hall:queue"
    L4_2 = A1_2
    L5_2 = A0_2
    L6_2 = L0_1
    L6_2 = L6_2[A0_2]
    L2_2(L3_2, L4_2, L5_2, L6_2)
  else
    L2_2 = true
    L5_1 = L2_2
    L2_2 = pairs
    L3_2 = L1_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L1_1
      L8_2 = L8_2[L6_2]
      if L8_2 == A0_2 then
        L8_2 = TriggerClientEvent
        L9_2 = "cs-hall:queue"
        L10_2 = L6_2
        L11_2 = A0_2
        L12_2 = L0_1
        L12_2 = L12_2[A0_2]
        L8_2(L9_2, L10_2, L11_2, L12_2)
      end
    end
  end
end
SyncQueue = L8_1
function L8_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if A1_2 then
    L3_2 = TriggerClientEvent
    L4_2 = "cs-hall:sync"
    L5_2 = A1_2
    L6_2 = A0_2
    L7_2 = L3_1
    L7_2 = L7_2[A0_2]
    L8_2 = A2_2 or L8_2
    if not A2_2 then
      L8_2 = {}
    end
    L9_2 = GetGameTimer
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L9_2()
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  else
    if A2_2 then
      L3_2 = A2_2.adjust
      if L3_2 then
        goto lbl_24
      end
    end
    L3_2 = true
    L5_1 = L3_2
    ::lbl_24::
    L3_2 = pairs
    L4_2 = L1_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L1_1
      L9_2 = L9_2[L7_2]
      if L9_2 == A0_2 then
        L9_2 = TriggerClientEvent
        L10_2 = "cs-hall:sync"
        L11_2 = L7_2
        L12_2 = A0_2
        L13_2 = L3_1
        L13_2 = L13_2[A0_2]
        L14_2 = A2_2 or L14_2
        if not A2_2 then
          L14_2 = {}
        end
        L15_2 = GetGameTimer
        L15_2 = L15_2()
        L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      end
    end
  end
end
SyncData = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = pairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L1_1
    L7_2 = L7_2[L5_2]
    if L7_2 == A0_2 then
      L7_2 = TriggerClientEvent
      L8_2 = "cs-hall:adjust"
      L9_2 = L5_2
      L10_2 = L3_1
      L10_2 = L10_2[A0_2]
      L10_2 = L10_2.time
      L7_2(L8_2, L9_2, L10_2)
    end
  end
end
AdjustTime = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.screens
  if not L1_2 then
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.screens
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L1_2.advancingAt = L2_2
  L1_2 = 0
  L2_2 = 1
  L3_2 = config
  L3_2 = L3_2.entries
  L3_2 = L3_2[A0_2]
  L3_2 = L3_2.screens
  L3_2 = #L3_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = config
    L6_2 = L6_2.entries
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.screens
    L6_2 = L6_2[L5_2]
    L6_2 = L6_2.advance
    L6_2 = L6_2.durationMs
    if L1_2 < L6_2 then
      L6_2 = config
      L6_2 = L6_2.entries
      L6_2 = L6_2[A0_2]
      L6_2 = L6_2.screens
      L6_2 = L6_2[L5_2]
      L6_2 = L6_2.advance
      L1_2 = L6_2.durationMs
    end
  end
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2.screens
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L3_2 = L3_2 + L1_2
  L2_2.advancedAt = L3_2
  L2_2 = SyncData
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = config
  L2_2 = L2_2.debug
  if L2_2 then
    L2_2 = print
    L3_2 = "[debug] AdvanceScreens"
    L4_2 = L1_2
    L5_2 = GetGameTimer
    L5_2 = L5_2()
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.screens
    L6_2 = L6_2.advancedAt
    L7_2 = type
    L8_2 = L3_1
    L8_2 = L8_2[A0_2]
    L8_2 = L8_2.screens
    L8_2 = L8_2.advancedAt
    L7_2 = L7_2(L8_2)
    L8_2 = tonumber
    L9_2 = L3_1
    L9_2 = L9_2[A0_2]
    L9_2 = L9_2.screens
    L9_2 = L9_2.advancedAt
    L8_2, L9_2 = L8_2(L9_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
end
AdvanceScreens = L8_1
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.screens
  if not L1_2 then
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.screens
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L1_2.retractingAt = L2_2
  L1_2 = 0
  L2_2 = 1
  L3_2 = config
  L3_2 = L3_2.entries
  L3_2 = L3_2[A0_2]
  L3_2 = L3_2.screens
  L3_2 = #L3_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = config
    L6_2 = L6_2.entries
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.screens
    L6_2 = L6_2[L5_2]
    L6_2 = L6_2.advance
    L1_2 = L6_2.durationMs
  end
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2.screens
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L3_2 = L3_2 + L1_2
  L2_2.retractedAt = L3_2
  L2_2 = SyncData
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = config
  L2_2 = L2_2.debug
  if L2_2 then
    L2_2 = print
    L3_2 = "[debug] RetractScreens"
    L4_2 = L1_2
    L5_2 = GetGameTimer
    L5_2 = L5_2()
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.screens
    L6_2 = L6_2.retractedAt
    L7_2 = type
    L8_2 = L3_1
    L8_2 = L8_2[A0_2]
    L8_2 = L8_2.screens
    L8_2 = L8_2.retractedAt
    L7_2 = L7_2(L8_2)
    L8_2 = tonumber
    L9_2 = L3_1
    L9_2 = L9_2[A0_2]
    L9_2 = L9_2.screens
    L9_2 = L9_2.retractedAt
    L8_2, L9_2 = L8_2(L9_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
end
RetractScreens = L8_1
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:play"
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = source
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L4_2 = IsAllowedToControl
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = SetController
      L5_2 = A0_2
      L6_2 = L3_2
      L4_2(L5_2, L6_2)
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.updater
      L5_2 = L3_1
      L5_2 = L5_2[A0_2]
      L5_2 = L5_2.controller
      if L4_2 ~= L5_2 then
        L4_2 = RefreshCurrentUpdater
        L5_2 = A0_2
        L4_2(L5_2)
      end
      if A1_2 then
        L4_2 = TriggerClientEvent
        L5_2 = "cs-hall:interfacelessFeatureUsed"
        L6_2 = L3_2
        L7_2 = A0_2
        L8_2 = "play"
        L4_2(L5_2, L6_2, L7_2, L8_2)
        if not A2_2 then
          L4_2 = type
          L5_2 = config
          L5_2 = L5_2.entries
          L5_2 = L5_2[A0_2]
          L6_2 = "featureDelayWithControllerInterfaceClosedMs"
          L5_2 = L5_2[L6_2]
          L4_2 = L4_2(L5_2)
          if "nil" ~= L4_2 then
            L4_2 = Wait
            L5_2 = config
            L5_2 = L5_2.entries
            L5_2 = L5_2[A0_2]
            L6_2 = "featureDelayWithControllerInterfaceClosedMs"
            L5_2 = L5_2[L6_2]
            L4_2(L5_2)
          else
            L4_2 = Wait
            L5_2 = L4_1
            L4_2(L5_2)
          end
        end
      end
      L4_2 = false
      L5_2 = L0_1
      L5_2 = L5_2[A0_2]
      L5_2 = #L5_2
      if L5_2 > 0 then
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L5_2 = L5_2.url
        if not L5_2 then
          L5_2 = L0_1
          L5_2 = L5_2[A0_2]
          L5_2 = L5_2[1]
          L6_2 = table
          L6_2 = L6_2.remove
          L7_2 = L0_1
          L7_2 = L7_2[A0_2]
          L8_2 = 1
          L6_2(L7_2, L8_2)
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L6_2 = L6_2.url
          L7_2 = L5_2.url
          if L6_2 ~= L7_2 then
            L6_2 = L3_1
            L6_2 = L6_2[A0_2]
            L6_2 = L6_2.media
            L7_2 = L5_2.duration
            L6_2.duration = L7_2
          end
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L7_2 = L5_2.url
          L6_2.url = L7_2
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L7_2 = L5_2.thumbnailUrl
          L6_2.thumbnailUrl = L7_2
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L7_2 = L5_2.thumbnailTitle
          L6_2.thumbnailTitle = L7_2
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L7_2 = L5_2.title
          L6_2.title = L7_2
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L7_2 = L5_2.icon
          L6_2.icon = L7_2
          L6_2 = L3_1
          L6_2 = L6_2[A0_2]
          L6_2 = L6_2.media
          L6_2.time = 0
          L4_2 = true
        end
      end
      L5_2 = L3_1
      L5_2 = L5_2[A0_2]
      L5_2 = L5_2.media
      L5_2 = L5_2.url
      if L5_2 then
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L5_2 = L5_2.playing
        if not L5_2 then
          L5_2 = L3_1
          L5_2 = L5_2[A0_2]
          L5_2 = L5_2.media
          L5_2.playing = true
          L5_2 = L3_1
          L5_2 = L5_2[A0_2]
          L5_2 = L5_2.media
          L5_2.stopped = false
        end
      end
      L5_2 = TriggerEvent
      L6_2 = "cs-hall:onPlay"
      L7_2 = A0_2
      L8_2 = L3_2
      L9_2 = {}
      L10_2 = L3_1
      L10_2 = L10_2[A0_2]
      L10_2 = L10_2.media
      L10_2 = L10_2.url
      L9_2.url = L10_2
      L10_2 = L3_1
      L10_2 = L10_2[A0_2]
      L10_2 = L10_2.media
      L10_2 = L10_2.thumbnailUrl
      L9_2.thumbnailUrl = L10_2
      L10_2 = L3_1
      L10_2 = L10_2[A0_2]
      L10_2 = L10_2.media
      L10_2 = L10_2.thumbnailTitle
      L9_2.thumbnailTitle = L10_2
      L10_2 = L3_1
      L10_2 = L10_2[A0_2]
      L10_2 = L10_2.media
      L10_2 = L10_2.title
      L9_2.title = L10_2
      L10_2 = L3_1
      L10_2 = L10_2[A0_2]
      L10_2 = L10_2.media
      L10_2 = L10_2.icon
      L9_2.icon = L10_2
      L5_2(L6_2, L7_2, L8_2, L9_2)
      L5_2 = SyncQueue
      L6_2 = A0_2
      L5_2(L6_2)
      L5_2 = SyncData
      L6_2 = A0_2
      L7_2 = nil
      L8_2 = {}
      L8_2.force = L4_2
      L5_2(L6_2, L7_2, L8_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:pause"
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = source
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L4_2 = IsAllowedToControl
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = SetController
      L5_2 = A0_2
      L6_2 = L3_2
      L4_2(L5_2, L6_2)
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.updater
      L5_2 = L3_1
      L5_2 = L5_2[A0_2]
      L5_2 = L5_2.controller
      if L4_2 ~= L5_2 then
        L4_2 = RefreshCurrentUpdater
        L5_2 = A0_2
        L4_2(L5_2)
      end
      if A1_2 then
        L4_2 = TriggerClientEvent
        L5_2 = "cs-hall:interfacelessFeatureUsed"
        L6_2 = L3_2
        L7_2 = A0_2
        L8_2 = "pause"
        L4_2(L5_2, L6_2, L7_2, L8_2)
        if not A2_2 then
          L4_2 = type
          L5_2 = config
          L5_2 = L5_2.entries
          L5_2 = L5_2[A0_2]
          L6_2 = "featureDelayWithControllerInterfaceClosedMs"
          L5_2 = L5_2[L6_2]
          L4_2 = L4_2(L5_2)
          if "nil" ~= L4_2 then
            L4_2 = Wait
            L5_2 = config
            L5_2 = L5_2.entries
            L5_2 = L5_2[A0_2]
            L6_2 = "featureDelayWithControllerInterfaceClosedMs"
            L5_2 = L5_2[L6_2]
            L4_2(L5_2)
          else
            L4_2 = Wait
            L5_2 = L4_1
            L4_2(L5_2)
          end
        end
      end
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2 = L4_2.playing
      if L4_2 then
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.playing = false
      end
      L4_2 = TriggerEvent
      L5_2 = "cs-hall:onPause"
      L6_2 = A0_2
      L7_2 = L3_2
      L8_2 = {}
      L9_2 = L3_1
      L9_2 = L9_2[A0_2]
      L9_2 = L9_2.media
      L9_2 = L9_2.url
      L8_2.url = L9_2
      L9_2 = L3_1
      L9_2 = L9_2[A0_2]
      L9_2 = L9_2.media
      L9_2 = L9_2.thumbnailUrl
      L8_2.thumbnailUrl = L9_2
      L9_2 = L3_1
      L9_2 = L9_2[A0_2]
      L9_2 = L9_2.media
      L9_2 = L9_2.thumbnailTitle
      L8_2.thumbnailTitle = L9_2
      L9_2 = L3_1
      L9_2 = L9_2[A0_2]
      L9_2 = L9_2.media
      L9_2 = L9_2.title
      L8_2.title = L9_2
      L9_2 = L3_1
      L9_2 = L9_2[A0_2]
      L9_2 = L9_2.media
      L9_2 = L9_2.icon
      L8_2.icon = L9_2
      L4_2(L5_2, L6_2, L7_2, L8_2)
      L4_2 = SyncData
      L5_2 = A0_2
      L4_2(L5_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:stop"
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = source
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L4_2 = IsAllowedToControl
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = SetController
      L5_2 = A0_2
      L6_2 = L3_2
      L4_2(L5_2, L6_2)
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.updater
      L5_2 = L3_1
      L5_2 = L5_2[A0_2]
      L5_2 = L5_2.controller
      if L4_2 ~= L5_2 then
        L4_2 = RefreshCurrentUpdater
        L5_2 = A0_2
        L4_2(L5_2)
      end
      if A1_2 then
        L4_2 = TriggerClientEvent
        L5_2 = "cs-hall:interfacelessFeatureUsed"
        L6_2 = L3_2
        L7_2 = A0_2
        L8_2 = "stop"
        L4_2(L5_2, L6_2, L7_2, L8_2)
        if not A2_2 then
          L4_2 = type
          L5_2 = config
          L5_2 = L5_2.entries
          L5_2 = L5_2[A0_2]
          L6_2 = "featureDelayWithControllerInterfaceClosedMs"
          L5_2 = L5_2[L6_2]
          L4_2 = L4_2(L5_2)
          if "nil" ~= L4_2 then
            L4_2 = Wait
            L5_2 = config
            L5_2 = L5_2.entries
            L5_2 = L5_2[A0_2]
            L6_2 = "featureDelayWithControllerInterfaceClosedMs"
            L5_2 = L5_2[L6_2]
            L4_2(L5_2)
          else
            L4_2 = Wait
            L5_2 = L4_1
            L4_2(L5_2)
          end
        end
      end
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2 = L4_2.playing
      if L4_2 then
        L4_2 = TriggerEvent
        L5_2 = "cs-hall:onStop"
        L6_2 = A0_2
        L7_2 = L3_2
        L8_2 = {}
        L9_2 = L3_1
        L9_2 = L9_2[A0_2]
        L9_2 = L9_2.media
        L9_2 = L9_2.url
        L8_2.url = L9_2
        L9_2 = L3_1
        L9_2 = L9_2[A0_2]
        L9_2 = L9_2.media
        L9_2 = L9_2.thumbnailUrl
        L8_2.thumbnailUrl = L9_2
        L9_2 = L3_1
        L9_2 = L9_2[A0_2]
        L9_2 = L9_2.media
        L9_2 = L9_2.thumbnailTitle
        L8_2.thumbnailTitle = L9_2
        L9_2 = L3_1
        L9_2 = L9_2[A0_2]
        L9_2 = L9_2.media
        L9_2 = L9_2.title
        L8_2.title = L9_2
        L9_2 = L3_1
        L9_2 = L9_2[A0_2]
        L9_2 = L9_2.media
        L9_2 = L9_2.icon
        L8_2.icon = L9_2
        L4_2(L5_2, L6_2, L7_2, L8_2)
      end
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2.playing = false
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2.stopped = true
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2.time = 0
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2.duration = nil
      L4_2 = SyncData
      L5_2 = A0_2
      L6_2 = nil
      L7_2 = {}
      L7_2.force = true
      L4_2(L5_2, L6_2, L7_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:seek"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToControl
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L3_2 = L3_2.duration
      if L3_2 then
        L3_2 = L3_1
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.media
        L3_2 = L3_2.duration
        if L3_2 > 0 then
          L3_2 = SetController
          L4_2 = A0_2
          L5_2 = L2_2
          L3_2(L4_2, L5_2)
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.updater
          L4_2 = L3_1
          L4_2 = L4_2[A0_2]
          L4_2 = L4_2.controller
          if L3_2 ~= L4_2 then
            L3_2 = RefreshCurrentUpdater
            L4_2 = A0_2
            L3_2(L4_2)
          end
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L3_2 = L3_2.url
          if L3_2 then
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L3_2.time = A1_2
            L3_2 = SyncData
            L4_2 = A0_2
            L5_2 = nil
            L6_2 = {}
            L7_2 = {}
            L7_2.seek = true
            L6_2.media = L7_2
            L3_2(L4_2, L5_2, L6_2)
            return
          end
        end
      end
      L3_2 = SyncData
      L4_2 = A0_2
      L3_2(L4_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:changeVolume"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToControl
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = SetController
      L4_2 = A0_2
      L5_2 = L2_2
      L3_2(L4_2, L5_2)
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.updater
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.controller
      if L3_2 ~= L4_2 then
        L3_2 = RefreshCurrentUpdater
        L4_2 = A0_2
        L3_2(L4_2)
      end
      L3_2 = config
      L3_2 = L3_2.entries
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.maxVolumePercent
      if L3_2 then
        L3_2 = config
        L3_2 = L3_2.entries
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.maxVolumePercent
        if not (A1_2 <= L3_2) then
          goto lbl_46
        end
      end
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = A1_2 / 100
      L3_2.volume = L4_2
      goto lbl_56
      ::lbl_46::
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = config
      L4_2 = L4_2.entries
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.maxVolumePercent
      L4_2 = L4_2 / 100
      L3_2.volume = L4_2
      ::lbl_56::
      L3_2 = SyncData
      L4_2 = A0_2
      L3_2(L4_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:toggleLoop"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = source
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = IsAllowedToControl
    L3_2 = A0_2
    L4_2 = L1_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L2_2 = SetController
      L3_2 = A0_2
      L4_2 = L1_2
      L2_2(L3_2, L4_2)
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.updater
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.controller
      if L2_2 ~= L3_2 then
        L2_2 = RefreshCurrentUpdater
        L3_2 = A0_2
        L2_2(L3_2)
      end
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.media
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L3_2 = L3_2.loop
      L3_2 = not L3_2
      L2_2.loop = L3_2
      L2_2 = SyncData
      L3_2 = A0_2
      L2_2(L3_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:addToQueue"
function L10_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L6_2 = source
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  if L7_2 then
    L7_2 = IsAllowedToControl
    L8_2 = A0_2
    L9_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      L7_2 = config
      L7_2 = L7_2.entries
      L7_2 = L7_2[A0_2]
      L7_2 = L7_2.allowAllSources
      if not L7_2 then
        L7_2 = StartsWith
        L8_2 = A1_2
        L9_2 = "https://www.youtube.com/"
        L7_2 = L7_2(L8_2, L9_2)
        if not L7_2 then
          L7_2 = StartsWith
          L8_2 = A1_2
          L9_2 = "https://www.twitch.tv/"
          L7_2 = L7_2(L8_2, L9_2)
          if not L7_2 then
            L7_2 = StartsWith
            L8_2 = A1_2
            L9_2 = "https://clips.twitch.tv/"
            L7_2 = L7_2(L8_2, L9_2)
            if not L7_2 then
              return
            end
          end
        end
      else
        L7_2 = StartsWith
        L8_2 = A1_2
        L9_2 = "http://"
        L7_2 = L7_2(L8_2, L9_2)
        if not L7_2 then
          L7_2 = StartsWith
          L8_2 = A1_2
          L9_2 = "https://"
          L7_2 = L7_2(L8_2, L9_2)
          if not L7_2 then
            return
          end
        end
      end
      L7_2 = SetController
      L8_2 = A0_2
      L9_2 = L6_2
      L7_2(L8_2, L9_2)
      L7_2 = L3_1
      L7_2 = L7_2[A0_2]
      L7_2 = L7_2.updater
      L8_2 = L3_1
      L8_2 = L8_2[A0_2]
      L8_2 = L8_2.controller
      if L7_2 ~= L8_2 then
        L7_2 = RefreshCurrentUpdater
        L8_2 = A0_2
        L7_2(L8_2)
      end
      L7_2 = table
      L7_2 = L7_2.insert
      L8_2 = L0_1
      L8_2 = L8_2[A0_2]
      L9_2 = {}
      L9_2.url = A1_2
      L9_2.thumbnailUrl = A2_2
      L9_2.thumbnailTitle = A3_2
      L9_2.title = A4_2
      L9_2.icon = A5_2
      L9_2.duration = nil
      L9_2.manual = true
      L7_2(L8_2, L9_2)
      L7_2 = TriggerEvent
      L8_2 = "cs-hall:onEntryQueued"
      L9_2 = A0_2
      L10_2 = L6_2
      L11_2 = {}
      L11_2.url = A1_2
      L11_2.thumbnailUrl = A2_2
      L11_2.thumbnailTitle = A3_2
      L11_2.title = A4_2
      L11_2.icon = A5_2
      L12_2 = L0_1
      L12_2 = L12_2[A0_2]
      L12_2 = #L12_2
      L11_2.position = L12_2
      L11_2.duration = nil
      L11_2.manual = true
      L7_2(L8_2, L9_2, L10_2, L11_2)
      L7_2 = SyncQueue
      L8_2 = A0_2
      L7_2(L8_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:nextQueueSong"
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = source
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L4_2 = IsAllowedToControl
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = SetController
      L5_2 = A0_2
      L6_2 = L3_2
      L4_2(L5_2, L6_2)
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.updater
      L5_2 = L3_1
      L5_2 = L5_2[A0_2]
      L5_2 = L5_2.controller
      if L4_2 ~= L5_2 then
        L4_2 = RefreshCurrentUpdater
        L5_2 = A0_2
        L4_2(L5_2)
      end
      if A1_2 then
        L4_2 = TriggerClientEvent
        L5_2 = "cs-hall:interfacelessFeatureUsed"
        L6_2 = L3_2
        L7_2 = A0_2
        L8_2 = "skip"
        L4_2(L5_2, L6_2, L7_2, L8_2)
        if not A2_2 then
          L4_2 = type
          L5_2 = config
          L5_2 = L5_2.entries
          L5_2 = L5_2[A0_2]
          L6_2 = "featureDelayWithControllerInterfaceClosedMs"
          L5_2 = L5_2[L6_2]
          L4_2 = L4_2(L5_2)
          if "nil" ~= L4_2 then
            L4_2 = Wait
            L5_2 = config
            L5_2 = L5_2.entries
            L5_2 = L5_2[A0_2]
            L6_2 = "featureDelayWithControllerInterfaceClosedMs"
            L5_2 = L5_2[L6_2]
            L4_2(L5_2)
          else
            L4_2 = Wait
            L5_2 = L4_1
            L4_2(L5_2)
          end
        end
      end
      L4_2 = L0_1
      L4_2 = L4_2[A0_2]
      L4_2 = #L4_2
      if L4_2 > 0 then
        L4_2 = L0_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2[1]
        L5_2 = table
        L5_2 = L5_2.remove
        L6_2 = L0_1
        L6_2 = L6_2[A0_2]
        L7_2 = 1
        L5_2(L6_2, L7_2)
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L5_2 = L5_2.url
        L6_2 = L4_2.url
        if L5_2 ~= L6_2 then
          L5_2 = L3_1
          L5_2 = L5_2[A0_2]
          L5_2 = L5_2.media
          L6_2 = L4_2.duration
          L5_2.duration = L6_2
        end
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L6_2 = L4_2.url
        L5_2.url = L6_2
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L6_2 = L4_2.thumbnailUrl
        L5_2.thumbnailUrl = L6_2
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L6_2 = L4_2.thumbnailTitle
        L5_2.thumbnailTitle = L6_2
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L6_2 = L4_2.title
        L5_2.title = L6_2
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L6_2 = L4_2.icon
        L5_2.icon = L6_2
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.media
        L5_2.time = 0
        L5_2 = TriggerEvent
        L6_2 = "cs-hall:onPlay"
        L7_2 = A0_2
        L8_2 = L3_2
        L9_2 = {}
        L10_2 = L3_1
        L10_2 = L10_2[A0_2]
        L10_2 = L10_2.media
        L10_2 = L10_2.url
        L9_2.url = L10_2
        L10_2 = L3_1
        L10_2 = L10_2[A0_2]
        L10_2 = L10_2.media
        L10_2 = L10_2.thumbnailUrl
        L9_2.thumbnailUrl = L10_2
        L10_2 = L3_1
        L10_2 = L10_2[A0_2]
        L10_2 = L10_2.media
        L10_2 = L10_2.thumbnailTitle
        L9_2.thumbnailTitle = L10_2
        L10_2 = L3_1
        L10_2 = L10_2[A0_2]
        L10_2 = L10_2.media
        L10_2 = L10_2.title
        L9_2.title = L10_2
        L10_2 = L3_1
        L10_2 = L10_2[A0_2]
        L10_2 = L10_2.media
        L10_2 = L10_2.icon
        L9_2.icon = L10_2
        L5_2(L6_2, L7_2, L8_2, L9_2)
      else
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2 = L4_2.playing
        if L4_2 then
          L4_2 = TriggerEvent
          L5_2 = "cs-hall:onStop"
          L6_2 = A0_2
          L7_2 = L3_2
          L8_2 = {}
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.url
          L8_2.url = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.thumbnailUrl
          L8_2.thumbnailUrl = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.thumbnailTitle
          L8_2.thumbnailTitle = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.title
          L8_2.title = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.icon
          L8_2.icon = L9_2
          L4_2(L5_2, L6_2, L7_2, L8_2)
        end
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.url = nil
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.thumbnailUrl = nil
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.thumbnailTitle = nil
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.title = nil
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.icon = nil
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.playing = false
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.stopped = true
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.time = 0
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.duration = nil
      end
      L4_2 = SyncQueue
      L5_2 = A0_2
      L4_2(L5_2)
      L4_2 = SyncData
      L5_2 = A0_2
      L6_2 = nil
      L7_2 = {}
      L7_2.force = true
      L4_2(L5_2, L6_2, L7_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:queueNow"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToControl
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = SetController
      L4_2 = A0_2
      L5_2 = L2_2
      L3_2(L4_2, L5_2)
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.updater
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.controller
      if L3_2 ~= L4_2 then
        L3_2 = RefreshCurrentUpdater
        L4_2 = A0_2
        L3_2(L4_2)
      end
      L3_2 = L0_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2[A1_2]
      if L3_2 then
        L3_2 = L0_1
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2[A1_2]
        L4_2 = table
        L4_2 = L4_2.remove
        L5_2 = L0_1
        L5_2 = L5_2[A0_2]
        L6_2 = A1_2
        L4_2(L5_2, L6_2)
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2 = L4_2.url
        L5_2 = L3_2.url
        if L4_2 ~= L5_2 then
          L4_2 = L3_1
          L4_2 = L4_2[A0_2]
          L4_2 = L4_2.media
          L5_2 = L3_2.duration
          L4_2.duration = L5_2
        end
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L5_2 = L3_2.url
        L4_2.url = L5_2
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L5_2 = L3_2.thumbnailUrl
        L4_2.thumbnailUrl = L5_2
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L5_2 = L3_2.thumbnailTitle
        L4_2.thumbnailTitle = L5_2
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L5_2 = L3_2.title
        L4_2.title = L5_2
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L5_2 = L3_2.icon
        L4_2.icon = L5_2
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.time = 0
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2 = L4_2.playing
        if L4_2 then
          L4_2 = TriggerEvent
          L5_2 = "cs-hall:onPlay"
          L6_2 = A0_2
          L7_2 = L2_2
          L8_2 = {}
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.url
          L8_2.url = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.thumbnailUrl
          L8_2.thumbnailUrl = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.thumbnailTitle
          L8_2.thumbnailTitle = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.title
          L8_2.title = L9_2
          L9_2 = L3_1
          L9_2 = L9_2[A0_2]
          L9_2 = L9_2.media
          L9_2 = L9_2.icon
          L8_2.icon = L9_2
          L4_2(L5_2, L6_2, L7_2, L8_2)
        end
      end
      L3_2 = SyncQueue
      L4_2 = A0_2
      L3_2(L4_2)
      L3_2 = SyncData
      L4_2 = A0_2
      L5_2 = nil
      L6_2 = {}
      L6_2.force = true
      L3_2(L4_2, L5_2, L6_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:queueNext"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToControl
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = SetController
      L4_2 = A0_2
      L5_2 = L2_2
      L3_2(L4_2, L5_2)
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.updater
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.controller
      if L3_2 ~= L4_2 then
        L3_2 = RefreshCurrentUpdater
        L4_2 = A0_2
        L3_2(L4_2)
      end
      L3_2 = L0_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2[A1_2]
      if L3_2 then
        L3_2 = L0_1
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2[A1_2]
        L4_2 = table
        L4_2 = L4_2.remove
        L5_2 = L0_1
        L5_2 = L5_2[A0_2]
        L6_2 = A1_2
        L4_2(L5_2, L6_2)
        L4_2 = table
        L4_2 = L4_2.insert
        L5_2 = L0_1
        L5_2 = L5_2[A0_2]
        L6_2 = 1
        L7_2 = L3_2
        L4_2(L5_2, L6_2, L7_2)
      end
      L3_2 = SyncQueue
      L4_2 = A0_2
      L3_2(L4_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:queueRemove"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToControl
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = SetController
      L4_2 = A0_2
      L5_2 = L2_2
      L3_2(L4_2, L5_2)
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.updater
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.controller
      if L3_2 ~= L4_2 then
        L3_2 = RefreshCurrentUpdater
        L4_2 = A0_2
        L3_2(L4_2)
      end
      L3_2 = L0_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2[A1_2]
      if L3_2 then
        L3_2 = TriggerEvent
        L4_2 = "cs-hall:onEntryRemoved"
        L5_2 = A0_2
        L6_2 = L2_2
        L7_2 = {}
        L8_2 = L0_1
        L8_2 = L8_2[A0_2]
        L8_2 = L8_2[A1_2]
        L8_2 = L8_2.url
        L7_2.url = L8_2
        L8_2 = L0_1
        L8_2 = L8_2[A0_2]
        L8_2 = L8_2[A1_2]
        L8_2 = L8_2.thumbnailUrl
        L7_2.thumbnailUrl = L8_2
        L8_2 = L0_1
        L8_2 = L8_2[A0_2]
        L8_2 = L8_2[A1_2]
        L8_2 = L8_2.thumbnailTitle
        L7_2.thumbnailTitle = L8_2
        L8_2 = L0_1
        L8_2 = L8_2[A0_2]
        L8_2 = L8_2[A1_2]
        L8_2 = L8_2.title
        L7_2.title = L8_2
        L8_2 = L0_1
        L8_2 = L8_2[A0_2]
        L8_2 = L8_2[A1_2]
        L8_2 = L8_2.icon
        L7_2.icon = L8_2
        L7_2.position = A1_2
        L8_2 = L0_1
        L8_2 = L8_2[A0_2]
        L8_2 = L8_2[A1_2]
        L8_2 = L8_2.manual
        L7_2.manual = L8_2
        L3_2(L4_2, L5_2, L6_2, L7_2)
        L3_2 = table
        L3_2 = L3_2.remove
        L4_2 = L0_1
        L4_2 = L4_2[A0_2]
        L5_2 = A1_2
        L3_2(L4_2, L5_2)
      end
      L3_2 = SyncQueue
      L4_2 = A0_2
      L3_2(L4_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:toggleSetting"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToControl
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = SetController
      L4_2 = A0_2
      L5_2 = L2_2
      L3_2(L4_2, L5_2)
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.updater
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.controller
      if L3_2 ~= L4_2 then
        L3_2 = RefreshCurrentUpdater
        L4_2 = A0_2
        L3_2(L4_2)
      end
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.settings
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.settings
      L4_2 = L4_2[A1_2]
      L4_2 = not L4_2
      L3_2[A1_2] = L4_2
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.settings
      L3_2 = L3_2.whiteSpotlights
      if L3_2 then
        L3_2 = L3_1
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.settings
        L3_2 = L3_2.dynamicSpotlights
        if L3_2 then
          if "whiteSpotlights" == A1_2 then
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.settings
            L3_2.dynamicSpotlights = false
          elseif "dynamicSpotlights" == A1_2 then
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.settings
            L3_2.whiteSpotlights = false
          end
        end
      end
      L3_2 = SyncData
      L4_2 = A0_2
      L3_2(L4_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:triggerSetting"
function L10_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = source
  L5_2 = L3_1
  L5_2 = L5_2[A0_2]
  if L5_2 then
    L5_2 = IsAllowedToControl
    L6_2 = A0_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      L5_2 = SetController
      L6_2 = A0_2
      L7_2 = L4_2
      L5_2(L6_2, L7_2)
      L5_2 = L3_1
      L5_2 = L5_2[A0_2]
      L5_2 = L5_2.updater
      L6_2 = L3_1
      L6_2 = L6_2[A0_2]
      L6_2 = L6_2.controller
      if L5_2 ~= L6_2 then
        L5_2 = RefreshCurrentUpdater
        L6_2 = A0_2
        L5_2(L6_2)
      end
      if A2_2 then
        L5_2 = TriggerClientEvent
        L6_2 = "cs-hall:interfacelessFeatureUsed"
        L7_2 = L4_2
        L8_2 = A0_2
        L9_2 = A1_2
        L5_2(L6_2, L7_2, L8_2, L9_2)
        if not A3_2 then
          L5_2 = type
          L6_2 = config
          L6_2 = L6_2.entries
          L6_2 = L6_2[A0_2]
          L7_2 = "featureDelayWithControllerInterfaceClosedMs"
          L6_2 = L6_2[L7_2]
          L5_2 = L5_2(L6_2)
          if "nil" ~= L5_2 then
            L5_2 = Wait
            L6_2 = config
            L6_2 = L6_2.entries
            L6_2 = L6_2[A0_2]
            L7_2 = "featureDelayWithControllerInterfaceClosedMs"
            L6_2 = L6_2[L7_2]
            L5_2(L6_2)
          else
            L5_2 = Wait
            L6_2 = L4_1
            L5_2(L6_2)
          end
        end
      end
      if "triggerSmoke" == A1_2 then
        L5_2 = pairs
        L6_2 = L1_1
        L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
        for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
          L11_2 = L1_1
          L11_2 = L11_2[L9_2]
          if L11_2 == A0_2 then
            L11_2 = TriggerClientEvent
            L12_2 = "cs-hall:smoke"
            L13_2 = L9_2
            L14_2 = A0_2
            L15_2 = nil
            L11_2(L12_2, L13_2, L14_2, L15_2)
          end
        end
      elseif "triggerSparklers" == A1_2 then
        L5_2 = pairs
        L6_2 = L1_1
        L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
        for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
          L11_2 = L1_1
          L11_2 = L11_2[L9_2]
          if L11_2 == A0_2 then
            L11_2 = TriggerClientEvent
            L12_2 = "cs-hall:sparklers"
            L13_2 = L9_2
            L14_2 = A0_2
            L15_2 = nil
            L11_2(L12_2, L13_2, L14_2, L15_2)
          end
        end
      elseif "screenControl" == A1_2 then
        L5_2 = config
        L5_2 = L5_2.debug
        if L5_2 then
          L5_2 = print
          L6_2 = "[debug] triggered setting screenControl"
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.screens
          L5_2(L6_2, L7_2)
        end
        L5_2 = L3_1
        L5_2 = L5_2[A0_2]
        L5_2 = L5_2.screens
        if L5_2 then
          L5_2 = config
          L5_2 = L5_2.debug
          if L5_2 then
            L5_2 = print
            L6_2 = "[debug] screens exist"
            L7_2 = L3_1
            L7_2 = L7_2[A0_2]
            L7_2 = L7_2.screens
            L7_2 = L7_2.advancingAt
            L8_2 = L3_1
            L8_2 = L8_2[A0_2]
            L8_2 = L8_2.screens
            L8_2 = L8_2.retractingAt
            L5_2(L6_2, L7_2, L8_2)
          end
          L5_2 = L3_1
          L5_2 = L5_2[A0_2]
          L5_2 = L5_2.screens
          L5_2 = L5_2.advancingAt
          if L5_2 then
            L5_2 = L3_1
            L5_2 = L5_2[A0_2]
            L5_2 = L5_2.screens
            L5_2 = L5_2.retractingAt
            if not L5_2 then
              goto lbl_155
            end
            L5_2 = L3_1
            L5_2 = L5_2[A0_2]
            L5_2 = L5_2.screens
            L5_2 = L5_2.advancingAt
            L6_2 = L3_1
            L6_2 = L6_2[A0_2]
            L6_2 = L6_2.screens
            L6_2 = L6_2.retractingAt
            if not (L5_2 < L6_2) then
              goto lbl_155
            end
          end
          L5_2 = AdvanceScreens
          L6_2 = A0_2
          L5_2(L6_2)
          goto lbl_158
          ::lbl_155::
          L5_2 = RetractScreens
          L6_2 = A0_2
          L5_2(L6_2)
        end
      end
    end
  end
  ::lbl_158::
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:duration"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToUpdate
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L3_2 = L3_2.playing
      if L3_2 then
        L3_2 = L3_1
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.media
        L3_2.duration = A1_2
        L3_2 = TriggerEvent
        L4_2 = "cs-hall:onDuration"
        L5_2 = A0_2
        L6_2 = L2_2
        L7_2 = A1_2
        L3_2(L4_2, L5_2, L6_2, L7_2)
      end
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:time"
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = source
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  if L4_2 and A1_2 then
    L4_2 = IsAllowedToUpdate
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = L3_1
      L4_2 = L4_2[A0_2]
      L4_2 = L4_2.media
      L4_2 = L4_2.playing
      if L4_2 or A2_2 then
        L4_2 = L3_1
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.media
        L4_2.time = A1_2
        L4_2 = config
        L4_2 = L4_2.entries
        L4_2 = L4_2[A0_2]
        L4_2 = L4_2.autoAdjustTime
        if L4_2 then
          L4_2 = L3_1
          L4_2 = L4_2[A0_2]
          L4_2 = L4_2.media
          L4_2 = L4_2.duration
          if L4_2 then
            L4_2 = L3_1
            L4_2 = L4_2[A0_2]
            L4_2 = L4_2.media
            L4_2 = L4_2.duration
            if L4_2 > 0 then
              L4_2 = AdjustTime
              L5_2 = A0_2
              L4_2(L5_2)
            end
          end
        end
      end
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:smoke"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToUpdate
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = config
      L3_2 = L3_2.entries
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.bass
      if L3_2 then
        L3_2 = config
        L3_2 = L3_2.entries
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.bass
        L3_2 = L3_2.smoke
        if L3_2 then
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.smoke
          L3_2 = L3_2.lastTriggeredAt
          if L3_2 then
            L3_2 = GetGameTimer
            L3_2 = L3_2()
            L4_2 = L3_1
            L4_2 = L4_2[A0_2]
            L4_2 = L4_2.smoke
            L4_2 = L4_2.lastTriggeredAt
            L3_2 = L3_2 - L4_2
            L4_2 = config
            L4_2 = L4_2.entries
            L4_2 = L4_2[A0_2]
            L4_2 = L4_2.bass
            L4_2 = L4_2.smoke
            L4_2 = L4_2.cooldownMs
            if not (L3_2 > L4_2) then
              goto lbl_70
            end
          end
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.smoke
          L4_2 = GetGameTimer
          L4_2 = L4_2()
          L3_2.lastTriggeredAt = L4_2
          L3_2 = pairs
          L4_2 = L1_1
          L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
          for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
            L9_2 = L1_1
            L9_2 = L9_2[L7_2]
            if L9_2 == A0_2 then
              L9_2 = TriggerClientEvent
              L10_2 = "cs-hall:smoke"
              L11_2 = L7_2
              L12_2 = A0_2
              L13_2 = A1_2
              L9_2(L10_2, L11_2, L12_2, L13_2)
            end
          end
        end
      end
    end
  end
  ::lbl_70::
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:sparklers"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = IsAllowedToUpdate
    L4_2 = A0_2
    L5_2 = L2_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = config
      L3_2 = L3_2.entries
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.bass
      if L3_2 then
        L3_2 = config
        L3_2 = L3_2.entries
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.bass
        L3_2 = L3_2.sparklers
        if L3_2 then
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.sparklers
          L3_2 = L3_2.lastTriggeredAt
          if L3_2 then
            L3_2 = GetGameTimer
            L3_2 = L3_2()
            L4_2 = L3_1
            L4_2 = L4_2[A0_2]
            L4_2 = L4_2.sparklers
            L4_2 = L4_2.lastTriggeredAt
            L3_2 = L3_2 - L4_2
            L4_2 = config
            L4_2 = L4_2.entries
            L4_2 = L4_2[A0_2]
            L4_2 = L4_2.bass
            L4_2 = L4_2.sparklers
            L4_2 = L4_2.cooldownMs
            if not (L3_2 > L4_2) then
              goto lbl_70
            end
          end
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.sparklers
          L4_2 = GetGameTimer
          L4_2 = L4_2()
          L3_2.lastTriggeredAt = L4_2
          L3_2 = pairs
          L4_2 = L1_1
          L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
          for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
            L9_2 = L1_1
            L9_2 = L9_2[L7_2]
            if L9_2 == A0_2 then
              L9_2 = TriggerClientEvent
              L10_2 = "cs-hall:sparklers"
              L11_2 = L7_2
              L12_2 = A0_2
              L13_2 = A1_2
              L9_2(L10_2, L11_2, L12_2, L13_2)
            end
          end
        end
      end
    end
  end
  ::lbl_70::
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:controllerEnded"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = source
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = IsAllowedToUpdate
    L3_2 = A0_2
    L4_2 = L1_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.media
      L2_2 = L2_2.playing
      if L2_2 then
        L2_2 = L3_1
        L2_2 = L2_2[A0_2]
        L2_2 = L2_2.media
        L2_2 = L2_2.loop
        if L2_2 then
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.time = 0
          L2_2 = TriggerEvent
          L3_2 = "cs-hall:onPlay"
          L4_2 = A0_2
          L5_2 = nil
          L6_2 = {}
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.url
          L6_2.url = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.thumbnailUrl
          L6_2.thumbnailUrl = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.thumbnailTitle
          L6_2.thumbnailTitle = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.title
          L6_2.title = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.icon
          L6_2.icon = L7_2
          L2_2(L3_2, L4_2, L5_2, L6_2)
        else
          L2_2 = L0_1
          L2_2 = L2_2[A0_2]
          L2_2 = #L2_2
          if L2_2 > 0 then
            L2_2 = L0_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2[1]
            L3_2 = table
            L3_2 = L3_2.remove
            L4_2 = L0_1
            L4_2 = L4_2[A0_2]
            L5_2 = 1
            L3_2(L4_2, L5_2)
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L3_2 = L3_2.url
            L4_2 = L2_2.url
            if L3_2 ~= L4_2 then
              L3_2 = L3_1
              L3_2 = L3_2[A0_2]
              L3_2 = L3_2.media
              L4_2 = L2_2.duration
              L3_2.duration = L4_2
            end
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L4_2 = L2_2.url
            L3_2.url = L4_2
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L4_2 = L2_2.thumbnailUrl
            L3_2.thumbnailUrl = L4_2
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L4_2 = L2_2.thumbnailTitle
            L3_2.thumbnailTitle = L4_2
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L4_2 = L2_2.title
            L3_2.title = L4_2
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L4_2 = L2_2.icon
            L3_2.icon = L4_2
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L3_2.time = 0
            L3_2 = TriggerEvent
            L4_2 = "cs-hall:onPlay"
            L5_2 = A0_2
            L6_2 = nil
            L7_2 = {}
            L8_2 = L3_1
            L8_2 = L8_2[A0_2]
            L8_2 = L8_2.media
            L8_2 = L8_2.url
            L7_2.url = L8_2
            L8_2 = L3_1
            L8_2 = L8_2[A0_2]
            L8_2 = L8_2.media
            L8_2 = L8_2.thumbnailUrl
            L7_2.thumbnailUrl = L8_2
            L8_2 = L3_1
            L8_2 = L8_2[A0_2]
            L8_2 = L8_2.media
            L8_2 = L8_2.thumbnailTitle
            L7_2.thumbnailTitle = L8_2
            L8_2 = L3_1
            L8_2 = L8_2[A0_2]
            L8_2 = L8_2.media
            L8_2 = L8_2.title
            L7_2.title = L8_2
            L8_2 = L3_1
            L8_2 = L8_2[A0_2]
            L8_2 = L8_2.media
            L8_2 = L8_2.icon
            L7_2.icon = L8_2
            L3_2(L4_2, L5_2, L6_2, L7_2)
            L3_2 = SyncQueue
            L4_2 = A0_2
            L3_2(L4_2)
          else
            L2_2 = TriggerEvent
            L3_2 = "cs-hall:onStop"
            L4_2 = A0_2
            L5_2 = nil
            L6_2 = {}
            L7_2 = L3_1
            L7_2 = L7_2[A0_2]
            L7_2 = L7_2.media
            L7_2 = L7_2.url
            L6_2.url = L7_2
            L7_2 = L3_1
            L7_2 = L7_2[A0_2]
            L7_2 = L7_2.media
            L7_2 = L7_2.thumbnailUrl
            L6_2.thumbnailUrl = L7_2
            L7_2 = L3_1
            L7_2 = L7_2[A0_2]
            L7_2 = L7_2.media
            L7_2 = L7_2.thumbnailTitle
            L6_2.thumbnailTitle = L7_2
            L7_2 = L3_1
            L7_2 = L7_2[A0_2]
            L7_2 = L7_2.media
            L7_2 = L7_2.title
            L6_2.title = L7_2
            L7_2 = L3_1
            L7_2 = L7_2[A0_2]
            L7_2 = L7_2.media
            L7_2 = L7_2.icon
            L6_2.icon = L7_2
            L2_2(L3_2, L4_2, L5_2, L6_2)
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.url = nil
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.thumbnailUrl = nil
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.thumbnailTitle = nil
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.title = nil
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.icon = nil
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.playing = false
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.stopped = true
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.time = 0
            L2_2 = L3_1
            L2_2 = L2_2[A0_2]
            L2_2 = L2_2.media
            L2_2.duration = nil
          end
        end
        L2_2 = SyncData
        L3_2 = A0_2
        L4_2 = nil
        L5_2 = {}
        L5_2.force = true
        L2_2(L3_2, L4_2, L5_2)
      end
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:controllerError"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = source
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = IsAllowedToUpdate
    L3_2 = A0_2
    L4_2 = L1_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.media
      L2_2 = L2_2.playing
      if L2_2 then
        L2_2 = L0_1
        L2_2 = L2_2[A0_2]
        L2_2 = #L2_2
        if L2_2 > 0 then
          L2_2 = L0_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2[1]
          L3_2 = table
          L3_2 = L3_2.remove
          L4_2 = L0_1
          L4_2 = L4_2[A0_2]
          L5_2 = 1
          L3_2(L4_2, L5_2)
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L3_2 = L3_2.url
          L4_2 = L2_2.url
          if L3_2 ~= L4_2 then
            L3_2 = L3_1
            L3_2 = L3_2[A0_2]
            L3_2 = L3_2.media
            L4_2 = L2_2.duration
            L3_2.duration = L4_2
          end
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L4_2 = L2_2.url
          L3_2.url = L4_2
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L4_2 = L2_2.thumbnailUrl
          L3_2.thumbnailUrl = L4_2
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L4_2 = L2_2.thumbnailTitle
          L3_2.thumbnailTitle = L4_2
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L4_2 = L2_2.title
          L3_2.title = L4_2
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L4_2 = L2_2.icon
          L3_2.icon = L4_2
          L3_2 = L3_1
          L3_2 = L3_2[A0_2]
          L3_2 = L3_2.media
          L3_2.time = 0
          L3_2 = TriggerEvent
          L4_2 = "cs-hall:onPlay"
          L5_2 = A0_2
          L6_2 = nil
          L7_2 = {}
          L8_2 = L3_1
          L8_2 = L8_2[A0_2]
          L8_2 = L8_2.media
          L8_2 = L8_2.url
          L7_2.url = L8_2
          L8_2 = L3_1
          L8_2 = L8_2[A0_2]
          L8_2 = L8_2.media
          L8_2 = L8_2.thumbnailUrl
          L7_2.thumbnailUrl = L8_2
          L8_2 = L3_1
          L8_2 = L8_2[A0_2]
          L8_2 = L8_2.media
          L8_2 = L8_2.thumbnailTitle
          L7_2.thumbnailTitle = L8_2
          L8_2 = L3_1
          L8_2 = L8_2[A0_2]
          L8_2 = L8_2.media
          L8_2 = L8_2.title
          L7_2.title = L8_2
          L8_2 = L3_1
          L8_2 = L8_2[A0_2]
          L8_2 = L8_2.media
          L8_2 = L8_2.icon
          L7_2.icon = L8_2
          L3_2(L4_2, L5_2, L6_2, L7_2)
          L3_2 = SyncQueue
          L4_2 = A0_2
          L3_2(L4_2)
        else
          L2_2 = TriggerEvent
          L3_2 = "cs-hall:onStop"
          L4_2 = A0_2
          L5_2 = nil
          L6_2 = {}
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.url
          L6_2.url = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.thumbnailUrl
          L6_2.thumbnailUrl = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.thumbnailTitle
          L6_2.thumbnailTitle = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.title
          L6_2.title = L7_2
          L7_2 = L3_1
          L7_2 = L7_2[A0_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.icon
          L6_2.icon = L7_2
          L2_2(L3_2, L4_2, L5_2, L6_2)
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.url = nil
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.thumbnailUrl = nil
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.thumbnailTitle = nil
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.title = nil
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.icon = nil
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.playing = false
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.stopped = true
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.time = 0
          L2_2 = L3_1
          L2_2 = L2_2[A0_2]
          L2_2 = L2_2.media
          L2_2.duration = nil
        end
      end
      L2_2 = SyncData
      L3_2 = A0_2
      L4_2 = nil
      L5_2 = {}
      L5_2.force = true
      L2_2(L3_2, L4_2, L5_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:enteredSyncArea"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = source
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = L1_1
    L2_2 = L2_2[L1_2]
    if not L2_2 then
      L2_2 = L1_1
      L2_2[L1_2] = A0_2
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.updater
      if not L2_2 then
        L2_2 = RefreshCurrentUpdater
        L3_2 = A0_2
        L2_2(L3_2)
      end
      L2_2 = SyncQueue
      L3_2 = A0_2
      L4_2 = L1_2
      L2_2(L3_2, L4_2)
      L2_2 = SyncData
      L3_2 = A0_2
      L4_2 = L1_2
      L5_2 = {}
      L5_2.force = true
      L5_2.entered = true
      L2_2(L3_2, L4_2, L5_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:leftSyncArea"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = source
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = L1_1
    L2_2 = L2_2[L1_2]
    if L2_2 == A0_2 then
      L2_2 = L1_1
      L2_2[L1_2] = nil
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.controller
      if L2_2 == L1_2 then
        L2_2 = ClearController
        L3_2 = A0_2
        L2_2(L3_2)
      end
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.updater
      if L2_2 == L1_2 then
        L2_2 = RefreshCurrentUpdater
        L3_2 = A0_2
        L2_2(L3_2)
      end
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:resync"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = source
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = L1_1
    L3_2 = L3_2[L2_2]
    if L3_2 == A0_2 then
      L3_2 = SyncData
      L4_2 = A0_2
      L5_2 = L2_2
      L6_2 = {}
      L6_2.force = A1_2
      L3_2(L4_2, L5_2, L6_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:server"
function L10_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = source
  L1_2 = TriggerClientEvent
  L2_2 = "cs-hall:client"
  L3_2 = L0_2
  L1_2(L2_2, L3_2)
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "cs-hall:fetch"
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = source
  L1_2 = TriggerClientEvent
  L2_2 = "cs-hall:params"
  L3_2 = L0_2
  L4_2 = config
  L4_2 = L4_2.duiUrl
  L5_2 = GetResourceMetadata
  L6_2 = GetCurrentResourceName
  L6_2 = L6_2()
  L7_2 = "version"
  L8_2 = 0
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
end
L8_1(L9_1, L10_1)
L8_1 = AddEventHandler
L9_1 = "cs-hall:toggleControllerInterface"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L1_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L2_2 = L2_1
  L2_2[A0_2] = A1_2
  L2_2 = TriggerClientEvent
  L3_2 = "cs-hall:cui"
  L4_2 = A0_2
  L5_2 = false
  L2_2(L3_2, L4_2, L5_2)
end
L8_1(L9_1, L10_1)
L8_1 = AddEventHandler
L9_1 = "cs-hall:disallowControllerInterface"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L1_2 = L2_1
  L1_2[A0_2] = nil
  L1_2 = TriggerClientEvent
  L2_2 = "cs-hall:cui"
  L3_2 = A0_2
  L4_2 = true
  L1_2(L2_2, L3_2, L4_2)
end
L8_1(L9_1, L10_1)
L8_1 = AddEventHandler
L9_1 = "playerDropped"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = source
  L1_2 = L2_1
  L1_2[L2_2] = nil
  L2_2 = source
  L1_2 = L1_1
  L1_2[L2_2] = nil
  L1_2 = pairs
  L2_2 = L3_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L3_1
    L7_2 = L7_2[L5_2]
    L7_2 = L7_2.controller
    L8_2 = source
    if L7_2 == L8_2 then
      L7_2 = ClearController
      L8_2 = L5_2
      L7_2(L8_2)
    end
    L7_2 = L3_1
    L7_2 = L7_2[L5_2]
    L7_2 = L7_2.updater
    L8_2 = source
    if L7_2 == L8_2 then
      L7_2 = RefreshCurrentUpdater
      L8_2 = L5_2
      L7_2(L8_2)
    end
  end
end
L8_1(L9_1, L10_1)
L8_1 = AddEventHandler
L9_1 = "onResourceStop"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L5_1
  if L1_2 then
    L1_2 = SetResourceKvp
    L2_2 = "data"
    L3_2 = json
    L3_2 = L3_2.encode
    L4_2 = L3_1
    L3_2, L4_2 = L3_2(L4_2)
    L1_2(L2_2, L3_2, L4_2)
    L1_2 = SetResourceKvp
    L2_2 = "queue"
    L3_2 = json
    L3_2 = L3_2.encode
    L4_2 = L0_1
    L3_2, L4_2 = L3_2(L4_2)
    L1_2(L2_2, L3_2, L4_2)
  end
end
L8_1(L9_1, L10_1)
L8_1 = CreateThread
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  while true do
    L0_2 = pairs
    L1_2 = L3_1
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
      L6_2 = L3_1
      L6_2 = L6_2[L4_2]
      if L6_2 then
        L6_2 = L3_1
        L6_2 = L6_2[L4_2]
        L6_2 = L6_2.media
        L6_2 = L6_2.playing
        if L6_2 then
          L6_2 = L3_1
          L6_2 = L6_2[L4_2]
          L6_2 = L6_2.media
          L7_2 = L3_1
          L7_2 = L7_2[L4_2]
          L7_2 = L7_2.media
          L7_2 = L7_2.time
          L7_2 = L7_2 + 1
          L6_2.time = L7_2
          L6_2 = L3_1
          L6_2 = L6_2[L4_2]
          L6_2 = L6_2.media
          L6_2 = L6_2.duration
          if L6_2 then
            L6_2 = L3_1
            L6_2 = L6_2[L4_2]
            L6_2 = L6_2.media
            L6_2 = L6_2.duration
            if L6_2 > 0 then
              L6_2 = L3_1
              L6_2 = L6_2[L4_2]
              L6_2 = L6_2.media
              L6_2 = L6_2.time
              L7_2 = L3_1
              L7_2 = L7_2[L4_2]
              L7_2 = L7_2.media
              L7_2 = L7_2.duration
              L7_2 = L7_2 + 15
              if L6_2 > L7_2 then
                L6_2 = L3_1
                L6_2 = L6_2[L4_2]
                L6_2 = L6_2.media
                L6_2.playing = false
                L6_2 = L3_1
                L6_2 = L6_2[L4_2]
                L6_2 = L6_2.media
                L6_2.stopped = true
                L6_2 = L3_1
                L6_2 = L6_2[L4_2]
                L6_2 = L6_2.media
                L6_2.time = 0
                L6_2 = L0_1
                L6_2 = L6_2[L4_2]
                L6_2 = #L6_2
                if L6_2 > 0 then
                  L6_2 = L0_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2[1]
                  L7_2 = table
                  L7_2 = L7_2.remove
                  L8_2 = L0_1
                  L8_2 = L8_2[L4_2]
                  L9_2 = 1
                  L7_2(L8_2, L9_2)
                  L7_2 = L3_1
                  L7_2 = L7_2[L4_2]
                  L7_2 = L7_2.media
                  L7_2 = L7_2.url
                  L8_2 = L6_2.url
                  if L7_2 ~= L8_2 then
                    L7_2 = L3_1
                    L7_2 = L7_2[L4_2]
                    L7_2 = L7_2.media
                    L8_2 = L6_2.duration
                    L7_2.duration = L8_2
                  end
                  L7_2 = L3_1
                  L7_2 = L7_2[L4_2]
                  L7_2 = L7_2.media
                  L8_2 = L6_2.url
                  L7_2.url = L8_2
                  L7_2 = L3_1
                  L7_2 = L7_2[L4_2]
                  L7_2 = L7_2.media
                  L8_2 = L6_2.thumbnailUrl
                  L7_2.thumbnailUrl = L8_2
                  L7_2 = L3_1
                  L7_2 = L7_2[L4_2]
                  L7_2 = L7_2.media
                  L8_2 = L6_2.thumbnailTitle
                  L7_2.thumbnailTitle = L8_2
                  L7_2 = L3_1
                  L7_2 = L7_2[L4_2]
                  L7_2 = L7_2.media
                  L8_2 = L6_2.title
                  L7_2.title = L8_2
                  L7_2 = L3_1
                  L7_2 = L7_2[L4_2]
                  L7_2 = L7_2.media
                  L8_2 = L6_2.icon
                  L7_2.icon = L8_2
                  L7_2 = TriggerEvent
                  L8_2 = "cs-hall:onPlay"
                  L9_2 = L4_2
                  L10_2 = nil
                  L11_2 = {}
                  L12_2 = L3_1
                  L12_2 = L12_2[L4_2]
                  L12_2 = L12_2.media
                  L12_2 = L12_2.url
                  L11_2.url = L12_2
                  L12_2 = L3_1
                  L12_2 = L12_2[L4_2]
                  L12_2 = L12_2.media
                  L12_2 = L12_2.thumbnailUrl
                  L11_2.thumbnailUrl = L12_2
                  L12_2 = L3_1
                  L12_2 = L12_2[L4_2]
                  L12_2 = L12_2.media
                  L12_2 = L12_2.thumbnailTitle
                  L11_2.thumbnailTitle = L12_2
                  L12_2 = L3_1
                  L12_2 = L12_2[L4_2]
                  L12_2 = L12_2.media
                  L12_2 = L12_2.title
                  L11_2.title = L12_2
                  L12_2 = L3_1
                  L12_2 = L12_2[L4_2]
                  L12_2 = L12_2.media
                  L12_2 = L12_2.icon
                  L11_2.icon = L12_2
                  L7_2(L8_2, L9_2, L10_2, L11_2)
                else
                  L6_2 = TriggerEvent
                  L7_2 = "cs-hall:onStop"
                  L8_2 = L4_2
                  L9_2 = nil
                  L10_2 = {}
                  L11_2 = L3_1
                  L11_2 = L11_2[L4_2]
                  L11_2 = L11_2.media
                  L11_2 = L11_2.url
                  L10_2.url = L11_2
                  L11_2 = L3_1
                  L11_2 = L11_2[L4_2]
                  L11_2 = L11_2.media
                  L11_2 = L11_2.thumbnailUrl
                  L10_2.thumbnailUrl = L11_2
                  L11_2 = L3_1
                  L11_2 = L11_2[L4_2]
                  L11_2 = L11_2.media
                  L11_2 = L11_2.thumbnailTitle
                  L10_2.thumbnailTitle = L11_2
                  L11_2 = L3_1
                  L11_2 = L11_2[L4_2]
                  L11_2 = L11_2.media
                  L11_2 = L11_2.title
                  L10_2.title = L11_2
                  L11_2 = L3_1
                  L11_2 = L11_2[L4_2]
                  L11_2 = L11_2.media
                  L11_2 = L11_2.icon
                  L10_2.icon = L11_2
                  L6_2(L7_2, L8_2, L9_2, L10_2)
                  L6_2 = L3_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2.media
                  L6_2.url = nil
                  L6_2 = L3_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2.media
                  L6_2.thumbnailUrl = nil
                  L6_2 = L3_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2.media
                  L6_2.thumbnailTitle = nil
                  L6_2 = L3_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2.media
                  L6_2.title = nil
                  L6_2 = L3_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2.media
                  L6_2.icon = nil
                  L6_2 = L3_1
                  L6_2 = L6_2[L4_2]
                  L6_2 = L6_2.media
                  L6_2.duration = nil
                end
                L6_2 = SyncQueue
                L7_2 = L4_2
                L6_2(L7_2)
                L6_2 = SyncData
                L7_2 = L4_2
                L8_2 = nil
                L9_2 = {}
                L9_2.force = true
                L6_2(L7_2, L8_2, L9_2)
              end
            end
          end
        end
      end
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
end
L8_1(L9_1)
L8_1 = CreateThread
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  while true do
    L0_2 = pairs
    L1_2 = L3_1
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
      L6_2 = L3_1
      L6_2 = L6_2[L4_2]
      if L6_2 then
        L6_2 = L3_1
        L6_2 = L6_2[L4_2]
        L6_2 = L6_2.media
        L6_2 = L6_2.duration
        if L6_2 then
          L6_2 = L3_1
          L6_2 = L6_2[L4_2]
          L6_2 = L6_2.media
          L6_2 = L6_2.duration
          if L6_2 > 0 then
            L6_2 = config
            L6_2 = L6_2.entries
            L6_2 = L6_2[L4_2]
            L6_2 = L6_2.autoAdjustTime
            if L6_2 then
              L6_2 = L3_1
              L6_2 = L6_2[L4_2]
              L6_2 = L6_2.media
              L6_2 = L6_2.playing
              if L6_2 then
                L6_2 = AdjustTime
                L7_2 = L4_2
                L6_2(L7_2)
              end
            end
          end
        end
      end
    end
    L0_2 = Wait
    L1_2 = 3000
    L0_2(L1_2)
  end
end
L8_1(L9_1)
L8_1 = CreateThread
function L9_1()
  local L0_2, L1_2, L2_2, L3_2
  while true do
    L0_2 = L5_1
    if L0_2 then
      L0_2 = false
      L5_1 = L0_2
      L0_2 = SetResourceKvpNoSync
      L1_2 = "data"
      L2_2 = json
      L2_2 = L2_2.encode
      L3_2 = L3_1
      L2_2, L3_2 = L2_2(L3_2)
      L0_2(L1_2, L2_2, L3_2)
      L0_2 = SetResourceKvpNoSync
      L1_2 = "queue"
      L2_2 = json
      L2_2 = L2_2.encode
      L3_2 = L0_1
      L2_2, L3_2 = L2_2(L3_2)
      L0_2(L1_2, L2_2, L3_2)
    end
    L0_2 = Wait
    L1_2 = 15000
    L0_2(L1_2)
  end
end
L8_1(L9_1)
L8_1 = TriggerClientEvent
L9_1 = "cs-hall:client"
L10_1 = -1
L8_1(L9_1, L10_1)
L8_1 = TriggerClientEvent
L9_1 = "cs-hall:params"
L10_1 = -1
L11_1 = config
L11_1 = L11_1.duiUrl
L12_1 = GetResourceMetadata
L13_1 = GetCurrentResourceName
L13_1 = L13_1()
L14_1 = "version"
L15_1 = 0
L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1 = L12_1(L13_1, L14_1, L15_1)
L8_1(L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1)
L8_1 = exports
L9_1 = "Play"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = error
    L2_2 = "[cs-hall] export Play: Unknown area provided."
    L1_2(L2_2)
    return
  end
  L1_2 = false
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  L2_2 = #L2_2
  if L2_2 > 0 then
    L2_2 = L3_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2.media
    L2_2 = L2_2.url
    if not L2_2 then
      L3_2 = k
      L2_2 = L0_1
      L2_2 = L2_2[L3_2]
      L2_2 = L2_2[1]
      L3_2 = table
      L3_2 = L3_2.remove
      L5_2 = k
      L4_2 = L0_1
      L4_2 = L4_2[L5_2]
      L5_2 = 1
      L3_2(L4_2, L5_2)
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L3_2 = L3_2.url
      L4_2 = L2_2.url
      if L3_2 ~= L4_2 then
        L3_2 = L3_1
        L3_2 = L3_2[A0_2]
        L3_2 = L3_2.media
        L4_2 = L2_2.duration
        L3_2.duration = L4_2
      end
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = L2_2.url
      L3_2.url = L4_2
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = L2_2.thumbnailUrl
      L3_2.thumbnailUrl = L4_2
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = L2_2.thumbnailTitle
      L3_2.thumbnailTitle = L4_2
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = L2_2.title
      L3_2.title = L4_2
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = L2_2.icon
      L3_2.icon = L4_2
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L3_2.time = 0
      L1_2 = true
    end
  end
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2.media
  L2_2 = L2_2.url
  if L2_2 then
    L2_2 = L3_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2.media
    L2_2 = L2_2.playing
    if not L2_2 then
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.media
      L2_2.playing = true
      L2_2 = L3_1
      L2_2 = L2_2[A0_2]
      L2_2 = L2_2.media
      L2_2.stopped = false
    end
  end
  L2_2 = TriggerEvent
  L3_2 = "cs-hall:onPlay"
  L4_2 = A0_2
  L5_2 = nil
  L6_2 = {}
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  L7_2 = L7_2.media
  L7_2 = L7_2.url
  L6_2.url = L7_2
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  L7_2 = L7_2.media
  L7_2 = L7_2.thumbnailUrl
  L6_2.thumbnailUrl = L7_2
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  L7_2 = L7_2.media
  L7_2 = L7_2.thumbnailTitle
  L6_2.thumbnailTitle = L7_2
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  L7_2 = L7_2.media
  L7_2 = L7_2.title
  L6_2.title = L7_2
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  L7_2 = L7_2.media
  L7_2 = L7_2.icon
  L6_2.icon = L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = SyncQueue
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = SyncData
  L3_2 = A0_2
  L4_2 = nil
  L5_2 = {}
  L5_2.force = L1_2
  L2_2(L3_2, L4_2, L5_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "Pause"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = error
    L2_2 = "[cs-hall] export Pause: Unknown area provided."
    L1_2(L2_2)
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2 = L1_2.playing
  if L1_2 then
    L1_2 = L3_1
    L1_2 = L1_2[A0_2]
    L1_2 = L1_2.media
    L1_2.playing = false
  end
  L1_2 = TriggerEvent
  L2_2 = "cs-hall:onPause"
  L3_2 = A0_2
  L4_2 = source
  L5_2 = {}
  L6_2 = L3_1
  L6_2 = L6_2[A0_2]
  L6_2 = L6_2.media
  L6_2 = L6_2.url
  L5_2.url = L6_2
  L6_2 = L3_1
  L6_2 = L6_2[A0_2]
  L6_2 = L6_2.media
  L6_2 = L6_2.thumbnailUrl
  L5_2.thumbnailUrl = L6_2
  L6_2 = L3_1
  L6_2 = L6_2[A0_2]
  L6_2 = L6_2.media
  L6_2 = L6_2.thumbnailTitle
  L5_2.thumbnailTitle = L6_2
  L6_2 = L3_1
  L6_2 = L6_2[A0_2]
  L6_2 = L6_2.media
  L6_2 = L6_2.title
  L5_2.title = L6_2
  L6_2 = L3_1
  L6_2 = L6_2[A0_2]
  L6_2 = L6_2.media
  L6_2 = L6_2.icon
  L5_2.icon = L6_2
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = SyncData
  L2_2 = A0_2
  L1_2(L2_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "Stop"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = error
    L2_2 = "[cs-hall] export Stop: Unknown area provided."
    L1_2(L2_2)
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2 = L1_2.playing
  if L1_2 then
    L1_2 = TriggerEvent
    L2_2 = "cs-hall:onStop"
    L3_2 = A0_2
    L4_2 = source
    L5_2 = {}
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.media
    L6_2 = L6_2.url
    L5_2.url = L6_2
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.media
    L6_2 = L6_2.thumbnailUrl
    L5_2.thumbnailUrl = L6_2
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.media
    L6_2 = L6_2.thumbnailTitle
    L5_2.thumbnailTitle = L6_2
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.media
    L6_2 = L6_2.title
    L5_2.title = L6_2
    L6_2 = L3_1
    L6_2 = L6_2[A0_2]
    L6_2 = L6_2.media
    L6_2 = L6_2.icon
    L5_2.icon = L6_2
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2.playing = false
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2.stopped = true
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2.time = 0
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2.duration = nil
  L1_2 = SyncData
  L2_2 = A0_2
  L3_2 = nil
  L4_2 = {}
  L4_2.force = true
  L1_2(L2_2, L3_2, L4_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "IsPlaying"
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = error
    L2_2 = "[cs-hall] export IsPlaying: Unknown area provided."
    L1_2(L2_2)
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  L1_2 = L1_2.playing
  return L1_2
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "SetLoop"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = error
    L3_2 = "[cs-hall] export SetLoop: Unknown area provided."
    L2_2(L3_2)
    return
  end
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2.media
  L2_2.loop = A1_2
  L2_2 = SyncData
  L3_2 = A0_2
  L2_2(L3_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "AddToQueue"
function L10_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L7_2 = table
  L7_2 = L7_2.insert
  L8_2 = L0_1
  L8_2 = L8_2[A0_2]
  L9_2 = {}
  L9_2.url = A1_2
  L9_2.thumbnailUrl = A2_2
  L9_2.thumbnailTitle = A3_2
  L9_2.title = A4_2
  L9_2.icon = A5_2
  L9_2.duration = A6_2
  L9_2.manual = false
  L7_2(L8_2, L9_2)
  L7_2 = TriggerEvent
  L8_2 = "cs-hall:onEntryQueued"
  L9_2 = A0_2
  L10_2 = source
  L11_2 = {}
  L11_2.url = A1_2
  L11_2.thumbnailUrl = A2_2
  L11_2.thumbnailTitle = A3_2
  L11_2.title = A4_2
  L11_2.icon = A5_2
  L12_2 = L0_1
  L12_2 = L12_2[A0_2]
  L12_2 = #L12_2
  L11_2.position = L12_2
  L11_2.duration = A6_2
  L11_2.manual = false
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = SyncQueue
  L8_2 = A0_2
  L7_2(L8_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "QueueNow"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = error
    L3_2 = "[cs-hall] export QueueNow: Unknown area provided."
    L2_2(L3_2)
    return
  end
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2[A1_2]
  if L2_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2[A1_2]
    L3_2 = table
    L3_2 = L3_2.remove
    L4_2 = L0_1
    L4_2 = L4_2[A0_2]
    L5_2 = A1_2
    L3_2(L4_2, L5_2)
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L3_2 = L3_2.url
    L4_2 = L2_2.url
    if L3_2 ~= L4_2 then
      L3_2 = L3_1
      L3_2 = L3_2[A0_2]
      L3_2 = L3_2.media
      L4_2 = L2_2.duration
      L3_2.duration = L4_2
    end
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L4_2 = L2_2.url
    L3_2.url = L4_2
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L4_2 = L2_2.thumbnailUrl
    L3_2.thumbnailUrl = L4_2
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L4_2 = L2_2.thumbnailTitle
    L3_2.thumbnailTitle = L4_2
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L4_2 = L2_2.title
    L3_2.title = L4_2
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L4_2 = L2_2.icon
    L3_2.icon = L4_2
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L3_2.time = 0
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.media
    L3_2 = L3_2.playing
    if L3_2 then
      L3_2 = TriggerEvent
      L4_2 = "cs-hall:onPlay"
      L5_2 = A0_2
      L6_2 = source
      L7_2 = {}
      L8_2 = L3_1
      L8_2 = L8_2[A0_2]
      L8_2 = L8_2.media
      L8_2 = L8_2.url
      L7_2.url = L8_2
      L8_2 = L3_1
      L8_2 = L8_2[A0_2]
      L8_2 = L8_2.media
      L8_2 = L8_2.thumbnailUrl
      L7_2.thumbnailUrl = L8_2
      L8_2 = L3_1
      L8_2 = L8_2[A0_2]
      L8_2 = L8_2.media
      L8_2 = L8_2.thumbnailTitle
      L7_2.thumbnailTitle = L8_2
      L8_2 = L3_1
      L8_2 = L8_2[A0_2]
      L8_2 = L8_2.media
      L8_2 = L8_2.title
      L7_2.title = L8_2
      L8_2 = L3_1
      L8_2 = L8_2[A0_2]
      L8_2 = L8_2.media
      L8_2 = L8_2.icon
      L7_2.icon = L8_2
      L3_2(L4_2, L5_2, L6_2, L7_2)
    end
  end
  L2_2 = SyncQueue
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = SyncData
  L3_2 = A0_2
  L4_2 = nil
  L5_2 = {}
  L5_2.force = true
  L2_2(L3_2, L4_2, L5_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "RemoveFromQueue"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = error
    L3_2 = "[cs-hall] export RemoveFromQueue: Unknown area provided."
    L2_2(L3_2)
    return
  end
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2[A1_2]
  if L2_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2[A1_2]
    L3_2 = TriggerEvent
    L4_2 = "cs-hall:onEntryRemoved"
    L5_2 = A0_2
    L6_2 = source
    L7_2 = {}
    L8_2 = L2_2.url
    L7_2.url = L8_2
    L8_2 = L2_2.thumbnailUrl
    L7_2.thumbnailUrl = L8_2
    L8_2 = L2_2.thumbnailTitle
    L7_2.thumbnailTitle = L8_2
    L8_2 = L2_2.title
    L7_2.title = L8_2
    L8_2 = L2_2.icon
    L7_2.icon = L8_2
    L7_2.position = A1_2
    L8_2 = L2_2.manual
    L7_2.manual = L8_2
    L3_2(L4_2, L5_2, L6_2, L7_2)
    L3_2 = table
    L3_2 = L3_2.remove
    L4_2 = L0_1
    L4_2 = L4_2[A0_2]
    L5_2 = A1_2
    L3_2(L4_2, L5_2)
  end
  L2_2 = SyncQueue
  L3_2 = A0_2
  L2_2(L3_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "GetPlayer"
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = error
    L2_2 = "[cs-hall] export GetPlayer: Unknown area provided."
    L1_2(L2_2)
    return
  end
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.media
  return L1_2
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "GetQueue"
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = L3_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = error
    L2_2 = "[cs-hall] export GetQueue: Unknown area provided."
    L1_2(L2_2)
    return
  end
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
L8_1(L9_1, L10_1)
