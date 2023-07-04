# PlausibleSwift

An implementation of [Plausible Analytics pageview and event tracking](https://plausible.io/docs/events-api) for Swift. Originally created for the [5 Calls](https://github.com/5calls/ios) companion app.

### Usage

Configure a site that is connected to Plausible, then track a pageview event:

```
let plausible = PlausibleSwift(domain: "example.site")
plausible.trackPageview(path: "/")
```

Or, track an arbitrary event:

```
trackEvent(event: "clicked-donate", path: "/donate")
```
