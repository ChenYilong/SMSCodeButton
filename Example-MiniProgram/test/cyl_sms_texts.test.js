/**
 * [EN] Tests of the SMSCodeButton mini program example: the texts, and the page wired to the component copied by
 *      `npm run setup` (the commit of ../CYL_COMMIT): the page's wxml attributes drive the real component through a small fake of
 *      the mini program runtime. Run: `npm run setup && npm test`.
 * [CN] SMSCodeButton 小程序示例的测试：文本，以及页面与 `npm run setup` 复制的组件（../CYL_COMMIT 的 commit）的连接：页面 wxml 中的属性
 *      通过小型模拟的小程序运行时驱动真实组件。运行：`npm run setup && npm test`。
 */
const test = require('node:test')
const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { CYL_SMS_TEXTS, cylSmsTexts } = require('../miniprogram/utils/cyl_sms_texts')

const root = path.join(__dirname, '..', 'miniprogram')
// [EN] A text with its seconds, as the component writes it. [CN] 带秒数的文本，与组件写出的相同。
const cylSeconds = (format, seconds) => format.replace('%d', String(seconds))

test('both tables have the same keys, and the language picks the table', () => {
  assert.deepEqual(Object.keys(CYL_SMS_TEXTS.en).sort(), Object.keys(CYL_SMS_TEXTS.zh).sort())
  assert.equal(cylSmsTexts('zh_CN'), CYL_SMS_TEXTS.zh)
  assert.equal(cylSmsTexts('zh_TW'), CYL_SMS_TEXTS.zh)
  assert.equal(cylSmsTexts('en'), CYL_SMS_TEXTS.en)
  assert.equal(cylSmsTexts(undefined), CYL_SMS_TEXTS.en)
  assert.equal(CYL_SMS_TEXTS.en.secondsLeft, '%d s left')
})

test('every file the page names exists (after npm run setup)', () => {
  const config = JSON.parse(fs.readFileSync(path.join(root, 'pages/index/index.json'), 'utf8'))
  const component = path.join(root, 'pages/index', config.usingComponents['cyl-animated-item'])
  for (const extension of ['.js', '.json', '.wxml', '.wxss']) {
    assert.ok(fs.existsSync(component + extension), `${component}${extension} is missing: run npm run setup`)
  }
  const wxml = fs.readFileSync(path.join(root, 'pages/index/index.wxml'), 'utf8')
  for (const image of wxml.match(/\/images\/[a-z_]+\.png/g)) {
    assert.ok(fs.existsSync(path.join(root, image)), `${image} is missing`)
  }
})

function cylMount(properties, clock, storage) {
  let definition
  global.Component = (d) => { definition = d }
  const file = path.join(root, 'cyl/cyl-animated-item/index.js')
  delete require.cache[file]
  require(file)
  delete global.Component
  const data = { ...definition.data }
  Object.entries(definition.properties).forEach(([key, value]) => { data[key] = value.value })
  const observers = Object.entries(definition.observers).map(([keys, fn]) => ({ keys: keys.split(',').map((k) => k.trim()), fn }))
  const item = {
    data,
    events: [],
    setData(patch, callback) {
      Object.entries(patch).forEach(([key, value]) => {
        if (key.startsWith('m.')) this.data.m = { ...this.data.m, [key.slice(2)]: value }
        else this.data[key] = value
      })
      if (callback) callback()
    },
    selectComponent: () => null,
    triggerEvent(name, detail) { this.events.push([name, detail]) },
    set(patch) {
      this.setData(patch)
      observers.filter((o) => o.keys.some((k) => k in patch)).forEach((o) => o.fn.apply(this, o.keys.map((k) => this.data[k])))
    },
  }
  Object.assign(item, definition.methods)
  const listeners = []
  global.wx = {
    onAppShow: (f) => listeners.push(f),
    offAppShow: () => {},
    getStorageSync: (n) => storage.get(n),
    setStorageSync: (n, v) => storage.set(n, v),
    removeStorageSync: (n) => storage.delete(n),
    getAppBaseInfo: () => ({ theme: 'light' }),
  }
  const realNow = Date.now
  Date.now = clock.now
  item.set(properties)
  definition.lifetimes.attached.call(item)
  return { item, showApp: () => listeners.forEach((f) => f()), detach: () => { definition.lifetimes.detached.call(item); Date.now = realNow; delete global.wx } }
}

// [EN] The attributes of pages/index/index.wxml, as the component receives them. [CN] pages/index/index.wxml 中的属性，即组件收到的属性。
function cylPageProperties(texts) {
  return {
    itemStyle: 'countdown',
    image: '/images/cyl_sms_envelope.png',
    countdownImage: '/images/cyl_sms_clock.png',
    countdownIdleTitle: texts.getCode,
    countdownRunningTitleFormat: texts.secondsLeft,
    countdownFinishedTitle: texts.resend,
    countdownRunningTitleColor: '#000000',
    titleColor: '#000000',
    countdownDuration: 60,
    startsCountdownOnTap: true,
    countdownCacheKey: 'cyl-sms-code',
  }
}

test('the page: a tap starts the countdown, 46 s in the background leave 14 s (issue #1), a restart continues', () => {
  const clock = { ms: 1_000_000, now: () => clock.ms }
  const storage = new Map()
  const texts = cylSmsTexts('zh_CN')
  const first = cylMount(cylPageProperties(texts), clock, storage)
  assert.equal(first.item.data.m.title, texts.getCode)
  first.item.cyl_onTap()
  assert.equal(first.item.data.m.title, cylSeconds(texts.secondsLeft, 60))
  assert.equal(first.item.data.m.fallbackImage, '/images/cyl_sms_clock.png')
  assert.equal(first.item.data.m.ariaDisabled, true)

  clock.ms += 46_000
  first.showApp()
  assert.equal(first.item.data.m.title, cylSeconds(texts.secondsLeft, 14))
  first.detach()

  // [EN] The mini program was ended in the background and started again 4 s later. [CN] 小程序在后台被结束，4 秒后再次启动。
  clock.ms += 4_000
  const second = cylMount(cylPageProperties(texts), clock, storage)
  assert.equal(second.item.data.m.title, cylSeconds(texts.secondsLeft, 10))

  clock.ms += 10_000
  second.showApp()
  assert.equal(second.item.data.m.title, texts.resend)
  assert.equal(second.item.data.m.ariaDisabled, false)
  assert.equal(second.item.events.at(-1)[0], 'countdownfinish')
  second.detach()
})
