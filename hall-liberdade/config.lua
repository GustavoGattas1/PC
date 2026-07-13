config = {
    ['updatesCheck'] = false,
    ['debug'] = false,

    ['duiUrl'] = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/client/dui/index.html',

    ['lang'] = {
        -- Interface do tablet
        ['brandTitle'] = 'Gustavo DJ Produções',
        ['brandSub'] = 'Hall Liberdade',
        ['queueTitle'] = 'Fila de Reprodução',
        ['effectsTitle'] = 'Efeitos',
        ['nowPlaying'] = 'Tocando agora',
        ['close'] = 'Fechar (ESC)',
        ['addToQueue'] = 'Adicionar à fila',
        ['loading'] = 'Carregando...',

        -- Botões de efeitos
        ['scenes'] = 'Cenas',
        ['bassSmoke'] = 'Fumaça automática no grave',
        ['bassSparklers'] = 'Faíscas automáticas no grave',
        ['triggerSmoke'] = 'Ativar fumaça agora',
        ['triggerSparklers'] = 'Ativar faíscas agora',
        ['whiteSpotlights'] = 'Holofotes brancos',
        ['dynamicSpotlights'] = 'Holofotes dinâmicos',
        ['photorythmicSpotlights'] = 'Holofotes fotorítmicos',
        ['whiteVehicles'] = 'Veículos brancos',
        ['dynamicVehicles'] = 'Veículos dinâmicos',
        ['photorythmicVehicles'] = 'Veículos fotorítmicos',
        ['videoToggle'] = 'Alternar exibição de vídeo',
        ['screenControl'] = 'Controle de tela',
        ['remoteControl'] = 'Controle remoto',

        -- Labels curtas dos botões
        ['scenesShort'] = 'Cenas',
        ['bassSmokeShort'] = 'Fumaça Auto',
        ['bassSparklersShort'] = 'Faíscas Auto',
        ['triggerSmokeShort'] = 'Fumaça',
        ['triggerSparklersShort'] = 'Faíscas',
        ['whiteSpotlightsShort'] = 'Branco',
        ['dynamicSpotlightsShort'] = 'Dinâmico',
        ['photorythmicSpotlightsShort'] = 'Rítmico',
        ['videoToggleShort'] = 'Vídeo',
        ['screenControlShort'] = 'Tela',
        ['remoteControlShort'] = 'Remoto',

        -- Player
        ['play'] = 'Reproduzir',
        ['pause'] = 'Pausar',
        ['stop'] = 'Parar',
        ['skip'] = 'Pular faixa',
        ['loop'] = 'Repetir',
        ['volume'] = 'Volume',

        -- Fila
        ['queueNow'] = 'Tocar agora',
        ['queueNext'] = 'Colocar como próximo',
        ['remove'] = 'Remover',
        ['emptyQueue'] = 'Nenhuma mídia na fila',
        ['emptyQueueHint'] = 'Cole um link do YouTube ou Twitch acima',

        -- URLs e placeholders
        ['allUrlPlaceholder'] = 'Cole a URL (YouTube, Twitch...)',
        ['urlPlaceholder'] = 'Link do YouTube ou Twitch',
        ['frame'] = 'Mídia',
        ['liveFeed'] = 'Transmissão ao vivo',
        ['twitchClip'] = 'Clip da Twitch',

        -- Erros e avisos
        ['invalidUrl'] = 'URL inválida.',
        ['invalidYouTubeUrl'] = 'URL do YouTube inválida.',
        ['invalidTwitchUrl'] = 'URL da Twitch inválida.',
        ['sourceError'] = 'Erro ao reproduzir a mídia.',
        ['sourceNotFound'] = 'Mídia não encontrada.',
        ['queueLimitReached'] = 'A fila atingiu o limite máximo.',
        ['youtubeError'] = 'Erro ao reproduzir vídeo do YouTube.',
        ['twitchError'] = 'Erro ao reproduzir conteúdo da Twitch.',
        ['twitchChannelOffline'] = 'Canal da Twitch offline no momento.',
        ['twitchVodSubOnly'] = 'Este vídeo está disponível apenas para assinantes.'
    },

    ['timeouts'] = {
        ['scaleformRequestMs'] = 30000,
        ['assetLoadMs'] = 30000,
        ['syncAssetLoadMs'] = 3000
    },

    ['entries'] = {
        ['liberdade'] = {
            ['enabled'] = true,
            ['autoAdjustTime'] = false,
            ['idleWallpaperUrl'] = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/client/dui/images/wallpaper.png',
            ['maxVolumePercent'] = 100,
            ['smokeFxMultiplier'] = 4,
            ['smokeTimeoutMs'] = 3000,
            ['sparklerFxMultiplier'] = 5,
            ['sparklerTimeoutMs'] = 1500,
            ['delayBetweenSmokeChainMs'] = 1500,
            ['delayToTriggerBassEffectsAfterPlayingMs'] = 2500,
            ['featureDelayWithControllerInterfaceClosedMs'] = 500,

            ['bass'] = {
                ['smoke'] = {
                    ['cooldownMs'] = 30000,
                    ['colorWithDynamicSpotlights'] = true
                },
                ['sparklers'] = {
                    ['cooldownMs'] = 30000,
                    ['colorWithDynamicSpotlights'] = true
                }
            },

            ['area'] = {
                ['range'] = 200.0,
                ['center'] = vector3(-1431.57, -1542.69, 1.97),
                ['height'] = nil,
                ['polygons'] = {
                    ['applyLowPassFilterOutside'] = true,
                    ['invertLowPassApplication'] = false,
                    ['hideReplacersOutside'] = true,
                    ['entries'] = {
                        {
                            ['height'] = {
                                ['min'] = -5.0,
                                ['max'] = 30.0
                            },
                            ['points'] = {
                                vector2(-1445.0, -1555.0),
                                vector2(-1418.0, -1555.0),
                                vector2(-1418.0, -1530.0),
                                vector2(-1445.0, -1530.0)
                            }
                        }
                    }
                }
            },

            ['disableEmitters'] = nil,
            ['scaleform'] = nil,

            ['replacers'] = {
                ['h4_prop_battle_club_projector'] = 'script_rt_club_projector',
                ['prop_tv_flat_01'] = 'script_rt_tvscreen',
                ['big_screens'] = 'script_rt_big_disp'
            },

            ['monitors'] = {
                {
                    ['hash'] = 'h4_prop_battle_club_screen',
                    ['position'] = vector3(-1431.57, -1542.69, 1.97),
                    ['rotation'] = vector3(0.0, 0.0, 88.26),
                    ['heading'] = nil,
                    ['lodDistance'] = 128
                }
            },

            ['screens'] = {
                {
                    ['hash'] = 'prop_huge_display_02',
                    ['position'] = vector3(-1431.57, -1542.69, 1.97),
                    ['rotation'] = vector3(0.0, 0.0, 0.0),
                    ['heading'] = nil,
                    ['lodDistance'] = 128,
                    ['advance'] = {
                        ['durationMs'] = 10000,
                        ['position'] = vector3(-1431.57, -1542.69, 1.97)
                    }
                }
            },

            ['spotlights'] = {
                {
                    ['soundSyncType'] = SOUND_SYNC_TYPE.BASS,
                    ['hash'] = 'cs_prop_hall_spotlight',
                    ['position'] = vector3(-1431.57, -1542.69, 4.97),
                    ['rotation'] = vector3(0.0, 0.0, 0.0),
                    ['lodDistance'] = nil,
                    ['color'] = {255, 1, 1}
                },
                {
                    ['soundSyncType'] = SOUND_SYNC_TYPE.MID,
                    ['hash'] = 'cs_prop_hall_spotlight',
                    ['position'] = vector3(-1428.57, -1542.69, 4.97),
                    ['rotation'] = vector3(0.0, 0.0, 45.0),
                    ['lodDistance'] = nil,
                    ['color'] = {255, 255, 0}
                },
                {
                    ['soundSyncType'] = SOUND_SYNC_TYPE.TREBLE,
                    ['hash'] = 'cs_prop_hall_spotlight',
                    ['position'] = vector3(-1434.57, -1542.69, 4.97),
                    ['rotation'] = vector3(0.0, 0.0, -45.0),
                    ['lodDistance'] = nil,
                    ['color'] = {3, 83, 255}
                }
            },

            ['smokers'] = {
                {
                    ['hash'] = 'ba_prop_club_smoke_machine',
                    ['visible'] = false,
                    ['fx'] = {
                        ['library'] = 'scr_ba_club',
                        ['effect'] = 'scr_ba_club_smoke_machine'
                    },
                    ['position'] = vector3(-1431.57, -1542.69, 6.97),
                    ['rotation'] = vector3(0.0, 0.0, 39.34),
                    ['color'] = {242, 223, 7}
                }
            },

            ['sparklers'] = {
                {
                    ['hash'] = 'prop_cs_pour_tube',
                    ['visible'] = true,
                    ['fx'] = {
                        ['library'] = 'scr_ih_club',
                        ['effect'] = 'scr_ih_club_sparkler'
                    },
                    ['position'] = vector3(-1431.57, -1542.69, 7.97),
                    ['rotation'] = vector3(0.0, 0.0, 0.0),
                    ['heading'] = nil,
                    ['lodDistance'] = nil,
                    ['color'] = {242, 7, 7}
                }
            },

            ['speakers'] = {
                {
                    ['hash'] = 'ba_prop_battle_club_speaker_large',
                    ['visible'] = false,
                    ['position'] = vector3(-1431.57, -1542.69, 1.97),
                    ['rotation'] = nil,
                    ['heading'] = 201.75,
                    ['lodDistance'] = nil,
                    ['soundOffset'] = vector3(0.0, 0.0, 1.4),
                    ['distanceOffset'] = nil,
                    ['maxDistance'] = 150.0,
                    ['refDistance'] = 16.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 15
                }
            }
        }
    }
}
