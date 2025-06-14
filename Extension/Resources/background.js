if (typeof browser === "undefined") {
  globalThis.browser = chrome;
}

async function reloadWebRequestRules() {
  const rulesUrl = browser.runtime.getURL("redirect-rules.json");
  const rulesResp = await fetch(rulesUrl);
  const rules = await rulesResp.json();

  const oldRules = await browser.declarativeNetRequest.getDynamicRules();
  await browser.declarativeNetRequest.updateDynamicRules({
    removeRuleIds: oldRules.map(rule => rule.id),
    addRules: rules,
  });
}

// iOS likes to wipe our DNR rules sometimes, so reload them as often as possible
browser.runtime.onStartup.addListener(reloadWebRequestRules);
browser.runtime.onInstalled.addListener(reloadWebRequestRules);
reloadWebRequestRules();
