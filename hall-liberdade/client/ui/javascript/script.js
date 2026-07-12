'use strict'

const $ = id => document.getElementById(id)
const resource = () => GetParentResourceName()

let lang = {}
let pendingSync = false
let pendingSeek = false
let pendingQueue = false
let playing = false
let stopped = false
let seekHiding = false
let lastUrl = null
let allowAllSources = false

const DEFAULT_THUMB = '/client/ui/images/thumbnail-default.png'

const urlCheck = document.createElement('input')
urlCheck.type = 'url'

const els = {}

function nui(event, data = {}) {
    return fetch(`https://${resource()}/${event}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    }).catch(() => {})
}

function toast(text, type = 'error') {
    const container = $('toast-container')
    const node = document.createElement('div')
    node.className = `toast ${type}`
    node.textContent = text
    container.appendChild(node)
    setTimeout(() => node.remove(), 3200)
}

function escapeHtml(str) {
    const d = document.createElement('div')
    d.textContent = str
    return d.innerHTML
}

function formatTime(seconds) {
    const m = Math.floor(seconds / 60)
    const s = seconds - m * 60
    return `${m > 9 ? m : '0' + m}:${s > 9 ? s : '0' + s}`
}

function setCtrlVisibility(id, visible, autoOnly = false) {
    const el = els[id]
    if (!el) return
    if (!visible) {
        el.classList.add('hidden-ctrl')
    } else {
        el.classList.remove('hidden-ctrl')
        if (autoOnly) el.style.opacity = '1'
    }
}

const CONTROL_BUTTONS = {
    scenesEnabled: { el: 'scenes-enabled', tip: 'scenes', label: 'scenesShort' },
    bassSmoke: { el: 'bass-smoke', tip: 'bassSmoke', label: 'bassSmokeShort' },
    bassSparklers: { el: 'bass-sparklers', tip: 'bassSparklers', label: 'bassSparklersShort' },
    triggerSmoke: { el: 'trigger-smoke', tip: 'triggerSmoke', label: 'triggerSmokeShort' },
    triggerSparklers: { el: 'trigger-sparklers', tip: 'triggerSparklers', label: 'triggerSparklersShort' },
    whiteSpotlights: { el: 'white-spotlights', tip: 'whiteSpotlights', label: 'whiteSpotlightsShort' },
    dynamicSpotlights: { el: 'dynamic-spotlights', tip: 'dynamicSpotlights', label: 'dynamicSpotlightsShort' },
    photorythmicSpotlights: { el: 'photorythmic-spotlights', tip: 'photorythmicSpotlights', label: 'photorythmicSpotlightsShort' },
    videoToggle: { el: 'video-toggle', tip: 'videoToggle', label: 'videoToggleShort' },
    screenControl: { el: 'screen-control', tip: 'screenControl', label: 'screenControlShort' },
    remoteControl: { el: 'remote-control', tip: 'remoteControl', label: 'remoteControlShort' }
}

function t(key, fallback = '') {
    return lang[key] || fallback
}

function applyLanguage() {
    $('brand-title').textContent = t('brandTitle', 'Hall Liberdade')
    $('brand-sub').textContent = t('brandSub', 'Controle de Palco')
    $('queue-title').innerHTML = `<i class="fas fa-list-ul"></i> ${t('queueTitle', 'Fila de Reprodução')}`
    $('effects-title').innerHTML = `<i class="fas fa-sliders-h"></i> ${t('effectsTitle', 'Efeitos')}`
    $('now-label').textContent = t('nowPlaying', 'Tocando agora')
    $('close').title = t('close', 'Fechar (ESC)')
    els.addButton.title = t('addToQueue', 'Adicionar à fila')
    els.addInput.placeholder = allowAllSources ? t('allUrlPlaceholder') : t('urlPlaceholder')
    els.queueEmpty.querySelector('p').textContent = t('emptyQueue')
    els.queueEmpty.querySelector('small').textContent = t('emptyQueueHint')
    els.playButton.title = t('play')
    els.stopButton.title = t('stop')
    els.skipButton.title = t('skip')
    els.loopButton.title = t('loop')
    els.volumeControl.title = t('volume')
    els.volume.setAttribute('aria-label', t('volume'))

    for (const cfg of Object.values(CONTROL_BUTTONS)) {
        const btn = $(cfg.el)
        if (!btn) continue
        btn.title = t(cfg.tip)
        const span = btn.querySelector('[data-label]')
        if (span) span.textContent = t(cfg.label)
    }
}

function updatePlayButtonTitle(isPlaying) {
    els.playButton.title = isPlaying ? t('pause') : t('play')
}

function setEnabled(el, state) {
    el.classList.remove('enabled', 'disabled')
    if (state === true) el.classList.add('enabled')
    else if (state === false) el.classList.add('disabled')
}

function updateQueueEmpty(count) {
    els.queueEmpty.classList.toggle('hidden', count > 0)
    els.queueCount.textContent = count
}

function parseMediaUrl(url) {
    const yt = url.match(/(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/i)
    const twitchCh = url.match(/^(?:https?:\/\/)?(?:www\.|go\.)?twitch\.tv\/([A-z0-9_]+)($|\?)/i)
    const twitchVid = url.match(/^(?:https?:\/\/)?(?:www\.|go\.)?twitch\.tv\/videos\/([0-9]+)($|\?)/i)
    const twitchClip = url.match(/^(?:(?:^(?:https?:\/\/)?clips\.twitch\.tv\/([A-z0-9_-]+)(?:$|\?))|(?:^(?:https?:\/\/)?(?:www\.|go\.)?twitch\.tv\/(?:[A-z0-9_-]+)\/clip\/([A-z0-9_-]+)($|\?)))/i)
    return { yt, twitchCh, twitchVid, twitchClip }
}

function getSceneIdentifier(url) {
    const p = parseMediaUrl(url)
    if (p.yt?.[1]) return `YouTube:${p.yt[1]}`
    if (p.twitchCh?.[1]) return `TwitchChannel:${p.twitchCh[1]}`
    if (p.twitchVid?.[1]) return `TwitchVideo:${p.twitchVid[1]}`
    if (p.twitchClip?.[1]) return `TwitchClip:${p.twitchClip[1]}`
    return ''
}

async function addToQueue() {
    if (pendingQueue) return

    const url = els.addInput.value.trim()
    if (!url) return

    if (els.queue.children.length >= 50)
        return toast(lang.queueLimitReached || 'Fila cheia.')

    urlCheck.value = url
    const p = parseMediaUrl(url)

    if (p.yt?.[1]) {
        const spin = document.createElement('div')
        spin.className = 'queue-element fetching'
        spin.innerHTML = '<i class="fas fa-spinner fa-spin"></i>'
        els.queue.appendChild(spin)
        updateQueueEmpty(els.queue.children.length)

        try {
            const res = await fetch(`https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=${p.yt[1]}`)
            const data = await res.json()
            if (data.provider_name === 'YouTube') {
                pendingQueue = true
                await nui('urlAdded', {
                    thumbnailUrl: data.thumbnail_url,
                    thumbnailTitle: data.author_name,
                    title: data.title,
                    icon: 'fab fa-youtube icon',
                    url: `https://www.youtube.com/watch?v=${p.yt[1]}`
                })
            }
        } catch {
            spin.remove()
            toast(lang.invalidYouTubeUrl || lang.invalidUrl)
        }
    } else if (p.twitchCh?.[1]) {
        const spin = document.createElement('div')
        spin.className = 'queue-element fetching'
        spin.innerHTML = '<i class="fas fa-spinner fa-spin"></i>'
        els.queue.appendChild(spin)

        try {
            const res = await fetch(`https://m.twitch.tv/${p.twitchCh[1]}`)
            const html = await res.text()
            const doc = new DOMParser().parseFromString(html, 'text/html')
            const avatar = doc.querySelector('img.tw-image-avatar')
            const og = doc.querySelector('meta[property="og:image"]')
            const thumb = avatar
                ? avatar.getAttribute('src').replace('50x50.png', '300x300.png')
                : (og ? og.getAttribute('content') : DEFAULT_THUMB)

            pendingQueue = true
            await nui('urlAdded', {
                thumbnailUrl: thumb,
                thumbnailTitle: p.twitchCh[1],
                title: lang.liveFeed || 'Transmissão ao vivo',
                icon: 'fab fa-twitch icon',
                url: `https://www.twitch.tv/${p.twitchCh[1]}`
            })
        } catch {
            spin.remove()
            toast(lang.invalidTwitchUrl || lang.invalidUrl)
        }
    } else if (p.twitchVid?.[1]) {
        const spin = document.createElement('div')
        spin.className = 'queue-element fetching'
        spin.innerHTML = '<i class="fas fa-spinner fa-spin"></i>'
        els.queue.appendChild(spin)

        try {
            const res = await fetch(`https://www.twitch.tv/videos/${p.twitchVid[1]}`)
            const html = await res.text()
            const doc = new DOMParser().parseFromString(html, 'text/html')
            const avatar = doc.querySelector('img.tw-image-avatar')
            const og = doc.querySelector('meta[property="og:image"]')
            const thumb = avatar
                ? avatar.getAttribute('src').replace('50x50.png', '300x300.png')
                : (og ? og.getAttribute('content') : DEFAULT_THUMB)

            let title = doc.title.replace(/ - Twitch$/, '').replace(/ on Twitch$/, '')
            let channel = 'Twitch'
            const match = title.match(/- ([a-zA-Z0-9_]+)$/)
            if (match) {
                channel = match[1]
                title = title.replace(new RegExp(`- ${match[1]}$`), '')
            }

            const ld = doc.querySelector('script[type="application/ld+json"]')
            if (ld) {
                try {
                    const json = JSON.parse(ld.innerText)
                    channel = json[0].author.name
                    title = json[0].description
                } catch {}
            }

            pendingQueue = true
            await nui('urlAdded', {
                thumbnailUrl: thumb,
                thumbnailTitle: channel,
                title,
                icon: 'fab fa-twitch icon',
                url: `https://www.twitch.tv/videos/${p.twitchVid[1]}`
            })
        } catch {
            spin.remove()
            toast(lang.invalidTwitchUrl || lang.invalidUrl)
        }
    } else if (p.twitchClip && (p.twitchClip[1] || p.twitchClip[2])) {
        const clipId = p.twitchClip[1] || p.twitchClip[2]
        const spin = document.createElement('div')
        spin.className = 'queue-element fetching'
        spin.innerHTML = '<i class="fas fa-spinner fa-spin"></i>'
        els.queue.appendChild(spin)

        try {
            const res = await fetch(`https://clips.twitch.tv/embed?clip=${clipId}`)
            const html = await res.text()
            const doc = new DOMParser().parseFromString(html, 'text/html')
            const og = doc.querySelector('meta[property="og:image"]')

            pendingQueue = true
            await nui('urlAdded', {
                thumbnailUrl: og ? og.getAttribute('content') : DEFAULT_THUMB,
                thumbnailTitle: lang.twitchClip || 'Clip da Twitch',
                title: clipId,
                icon: 'fab fa-twitch icon',
                url: `https://clips.twitch.tv/embed?clip=${clipId}`
            })
        } catch {
            spin.remove()
            toast(lang.invalidTwitchUrl || lang.invalidUrl)
        }
    } else if (allowAllSources && urlCheck.validity.valid) {
        pendingQueue = true
        await nui('urlAdded', {
            thumbnailUrl: DEFAULT_THUMB,
            thumbnailTitle: lang.frame || 'Mídia',
            title: url,
            icon: 'fas fa-film icon',
            url
        })
    } else {
        toast(lang.invalidUrl || 'URL inválida.')
    }

    els.addInput.value = ''
}

function bindEvents() {
    els.close.addEventListener('click', () => nui('hideUi'))
    els.addButton.addEventListener('click', addToQueue)
    els.addInput.addEventListener('keydown', e => { if (e.key === 'Enter') addToQueue() })
    els.addInput.addEventListener('focus', () => nui('inputFocus'))
    els.addInput.addEventListener('blur', () => nui('inputBlur'))

    const toggles = {
        scenesEnabled: 'scenesEnabled',
        bassSmoke: 'bassSmoke',
        bassSparklers: 'bassSparklers',
        whiteSpotlights: 'whiteSpotlights',
        dynamicSpotlights: 'dynamicSpotlights',
        photorythmicSpotlights: 'photorythmicSpotlights',
        videoToggle: 'videoToggle'
    }

    for (const [elKey, settingKey] of Object.entries(toggles)) {
        els[elKey].addEventListener('click', () => {
            if (pendingSync) return
            pendingSync = true
            nui('toggleSetting', { key: settingKey })
        })
    }

    els.triggerSmoke.addEventListener('click', () => nui('triggerSetting', { key: 'triggerSmoke' }))
    els.triggerSparklers.addEventListener('click', () => nui('triggerSetting', { key: 'triggerSparklers' }))
    els.screenControl.addEventListener('click', () => nui('triggerSetting', { key: 'screenControl' }))
    els.remoteControl.addEventListener('click', () => nui('remoteControl'))

    els.playButton.addEventListener('click', () => {
        if (pendingSync) return
        pendingSync = true
        nui(playing ? 'playerPaused' : 'playerPlayed')
    })

    els.stopButton.addEventListener('click', () => {
        if (pendingSync) return
        pendingSync = true
        nui('playerStopped')
    })

    els.skipButton.addEventListener('click', () => {
        if (pendingQueue || pendingSync) return
        pendingQueue = true
        pendingSync = true
        nui('playerSkipped')
    })

    els.loopButton.addEventListener('click', () => {
        if (pendingSync) return
        pendingSync = true
        nui('playerLooped')
    })

    els.volume.addEventListener('input', () => {
        if (pendingSync) {
            els.volume.value = els.volume.dataset.lastValue || els.volume.value
            return
        }
        pendingSync = true
        els.volume.dataset.lastValue = els.volume.value
        els.volumeText.textContent = `${Math.round(els.volume.value)}%`
        nui('changeVolume', { value: parseInt(els.volume.value) })
    })

    els.seek.addEventListener('input', () => {
        if (pendingSync || pendingSeek) {
            els.seek.value = els.seek.dataset.lastValue || els.seek.value
            return
        }
        els.seek.disabled = true
        pendingSeek = true
        pendingSync = true
        els.seek.dataset.lastValue = els.seek.value
        els.startSeekText.textContent = formatTime(parseInt(els.seek.value))
        nui('seek', { value: parseInt(els.seek.value) })
    })

    els.queue.addEventListener('click', e => {
        const btn = e.target.closest('.queue-button')
        if (!btn) return
        const index = parseInt(btn.closest('.queue-element')?.dataset.index)
        if (!index) return

        const action = btn.dataset.action
        if ((action === 'queue-now' || action === 'queue-remove') && pendingQueue) return
        if (action === 'queue-now') { pendingQueue = true; pendingSync = true }
        if (action === 'queue-next' || action === 'queue-remove') pendingQueue = true

        const map = { 'queue-now': 'queueNow', 'queue-next': 'queueNext', 'queue-remove': 'queueRemove' }
        nui(map[action], { index })
    })

    window.addEventListener('keyup', e => {
        if (e.key === 'Escape') nui('hideUi')
        if (e.key === 'Backspace' && document.activeElement.tagName !== 'INPUT') nui('hideUi')
    })

    window.addEventListener('keydown', e => {
        if (['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(e.key)) e.preventDefault()
    })
}

function initElements() {
    els.queue = $('queue')
    els.queueEmpty = $('queue-empty')
    els.queueCount = $('queue-count')
    els.addInput = $('add-input')
    els.addButton = $('add-button')
    els.close = $('close')
    els.scenesEnabled = $('scenes-enabled')
    els.bassSmoke = $('bass-smoke')
    els.bassSparklers = $('bass-sparklers')
    els.triggerSmoke = $('trigger-smoke')
    els.triggerSparklers = $('trigger-sparklers')
    els.whiteSpotlights = $('white-spotlights')
    els.dynamicSpotlights = $('dynamic-spotlights')
    els.photorythmicSpotlights = $('photorythmic-spotlights')
    els.videoToggle = $('video-toggle')
    els.screenControl = $('screen-control')
    els.remoteControl = $('remote-control')
    els.playButton = $('play-button')
    els.stopButton = $('stop-button')
    els.skipButton = $('skip-button')
    els.loopButton = $('loop-button')
    els.volume = $('volume')
    els.volumeText = $('volume-text')
    els.volumeControl = $('volume-control')
    els.seekControl = $('seek-control')
    els.seek = $('seek')
    els.startSeekText = $('start-seek-text')
    els.endSeekText = $('end-seek-text')
    els.mediaInfo = $('media-info')
    els.mediaTitle = $('media-title')
    els.mediaImage = $('media-image')
}

function handleSync(data) {
    playing = data.media.playing
    stopped = data.media.stopped

    document.querySelectorAll('.enabled, .disabled').forEach(el => el.classList.remove('enabled', 'disabled'))

    els.playButton.innerHTML = playing ? '<i class="fas fa-pause"></i>' : '<i class="fas fa-play"></i>'
    updatePlayButtonTitle(playing)
    if (playing) els.playButton.classList.add('enabled')

    els.volume.value = Math.round(data.media.volume * 100)
    els.volume.dataset.lastValue = els.volume.value
    els.volumeText.textContent = `${Math.round(els.volume.value)}%`

    setEnabled(els.loopButton, data.media.loop)
    setEnabled(els.scenesEnabled, data.settings.scenesEnabled)
    setEnabled(els.bassSmoke, data.settings.bassSmoke)
    setEnabled(els.bassSparklers, data.settings.bassSparklers)
    setEnabled(els.whiteSpotlights, data.settings.whiteSpotlights)
    setEnabled(els.dynamicSpotlights, data.settings.dynamicSpotlights)
    setEnabled(els.photorythmicSpotlights, data.settings.photorythmicSpotlights)
    setEnabled(els.videoToggle, data.settings.videoToggle)
    setEnabled(els.remoteControl, data.remoteControl)

    if (!data.media.url) {
        els.mediaTitle.textContent = ''
        els.mediaImage.innerHTML = ''
    } else {
        els.mediaTitle.textContent = data.media.title || ''
        els.mediaImage.innerHTML = `<img src="${escapeHtml(data.media.thumbnailUrl)}" alt="" />`

        const id = getSceneIdentifier(data.media.url)
        if (id) nui('setSceneIdentifier', { identifier: id })
    }

    if (!data.media.url || data.media.stopped || data.media.url !== lastUrl) {
        pendingSeek = false
        if (!seekHiding) {
            seekHiding = true
            els.seek.disabled = true
            els.seekControl.classList.add('hidden')
            els.seek.max = 0
            els.seek.value = 0
            els.startSeekText.textContent = '00:00'
            els.endSeekText.textContent = '00:00'
            seekHiding = false
        }
    }

    lastUrl = data.media.url

    const show = (el, v) => { el.classList.toggle('hidden-ctrl', !v) }

    show(els.screenControl, data.hasScreens)
    show(els.bassSmoke, data.hasSmokers && data.hasAutoSmokers)
    show(els.triggerSmoke, data.hasSmokers)
    show(els.bassSparklers, data.hasSparklers && data.hasAutoSparklers)
    show(els.triggerSparklers, data.hasSparklers)
    show(els.whiteSpotlights, data.hasSpotlights)
    show(els.dynamicSpotlights, data.hasSpotlights)
    show(els.photorythmicSpotlights, data.hasSpotlights)
    show(els.volumeControl, data.hasSpeakers)

    pendingSync = false
}

function handleInfo(data) {
    if (pendingSeek || seekHiding) return

    if (!data.duration || data.duration === -1 || stopped) {
        els.seekControl.classList.add('hidden')
        els.seek.disabled = true
        els.seek.max = 0
        els.seek.value = 0
        els.startSeekText.textContent = '00:00'
        els.endSeekText.textContent = '00:00'
    } else {
        const time = Math.round(data.time)
        const duration = Math.round(data.duration)
        els.seek.max = duration
        els.seek.value = time
        els.seek.dataset.lastValue = time
        els.startSeekText.textContent = formatTime(time)
        els.endSeekText.textContent = formatTime(duration)
        els.seek.disabled = false
        els.seekControl.classList.remove('hidden')
    }
}

function handleQueue(queue) {
    els.queue.innerHTML = ''
    updateQueueEmpty(queue.length)

    queue.forEach((item, i) => {
        const el = document.createElement('div')
        el.className = 'queue-element'
        el.dataset.index = i + 1
        el.innerHTML = `
            <div class="queue-image" style="background-image:url('${escapeHtml(item.thumbnailUrl)}')"></div>
            <div class="queue-actions">
                <div class="queue-title">${escapeHtml(item.title)}</div>
                <div class="queue-buttons">
                    <span class="queue-button" data-action="queue-now"><i class="fas fa-play"></i> ${lang.queueNow}</span>
                    <span class="queue-button" data-action="queue-next"><i class="fas fa-step-forward"></i> ${lang.queueNext}</span>
                    <span class="queue-button" data-action="queue-remove"><i class="fas fa-times"></i> ${lang.remove}</span>
                </div>
            </div>`
        els.queue.appendChild(el)
    })

    pendingQueue = false
}

function ready(l) {
    lang = l
    applyLanguage()
    bindEvents()
}

window.addEventListener('message', e => {
    const { type } = e.data

    switch (type) {
        case 'cs-hall:ready':
            ready(e.data.lang)
            break

        case 'cs-hall:show':
            document.body.classList.remove('hidden')
            allowAllSources = e.data.allowAllSources
            if (Object.keys(lang).length) applyLanguage()
            break

        case 'cs-hall:hide':
            document.body.classList.add('hidden')
            break

        case 'cs-hall:sync':
            handleSync(e.data)
            break

        case 'cs-hall:info':
            handleInfo(e.data)
            break

        case 'cs-hall:seeked':
            pendingSeek = false
            els.seek.disabled = false
            break

        case 'cs-hall:queue':
            handleQueue(e.data.queue)
            break

        case 'cs-hall:error':
            toast(e.data.error, 'error')
            break
    }
})

initElements()
nui('nuiReady')
