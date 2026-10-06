# Tabs asking for permission before loading

Block "Access other devices on your local network":

edge://settings/privacy/sitePermissions/allPermissions

-> Local network -> Turn off "Ask before accessing"

# Some functionality broken in webpages

Popus not working on https://home-manager-options.extranix.com/:

1. The site loads jQuery from https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js to power the Bootstrap popup modal.
2. On this device, Zscaler (zcctun0) intercepts DNS and resolves ajax.googleapis.com to a CGNAT address (100.64.1.23).
3. Chromium has Local Network Access Checks enabled. Because a public website (extranix.com) is requesting a script on an internal/CGNAT IP, the browser blocks it:
corsError: LocalNetworkAccessPermissionDenied (net::ERR_FAILED)
4. As a result, jQuery fails to load, $ is undefined, and clicking an option silently fails with ReferenceError: $ is not defined.

How to Fix

1. Open edge://flags (or chrome://flags in Chrome).
2. Search for:
Local Network Access Checks
(flag id: #local-network-access-check)
3. Set it to Disabled.
