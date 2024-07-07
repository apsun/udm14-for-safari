#!/usr/bin/env python3

import copy
import json
import os
import urllib.request

scriptdir = os.path.dirname(os.path.realpath(__file__))
extdir = scriptdir + "/../../Extension/Resources"

with open(scriptdir + "/supported_domains.txt") as f:
    tlds = f.read().splitlines()

# manifest.json
with open(scriptdir + "/manifest.json") as f:
    manifest = json.load(f)
newdomains = []
for tld in tlds:
    for domain in manifest["host_permissions"]:
        newdomains.append(domain.replace(".google.com", tld))
manifest["host_permissions"] = newdomains
with open(extdir + "/manifest.json", "w") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")

# redirect-rules.json
with open(scriptdir + "/redirect-rules.json") as f:
    rules = json.load(f)
newrules = []
for tld in tlds:
    for rule in rules:
        newrule = copy.deepcopy(rule)
        newrule["id"] = len(newrules) + 1
        newrule["condition"]["regexFilter"] = newrule["condition"]["regexFilter"].replace(".google.com", tld)
        newrules.append(newrule)
with open(extdir + "/redirect-rules.json", "w") as f:
    json.dump(newrules, f, indent=2)
    f.write("\n")
