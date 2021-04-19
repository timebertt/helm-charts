# octobox

Helm Chart for deploying an [Octobox](https://github.com/octobox/octobox) instance, including

- postgres
- redis
- nginx (for serving static assets)

## Quick Start

Install this [helm](https://helm.sh) chart by running:

```bash
helm repo add timebertt https://timebertt.github.io/helm-charts
# checkout values.yaml and fill in all the required secret values (e.g. `clientID` and `clientSecret`)
vi values.secret.yaml
helm install octobox -f values.secret.yaml timebertt/octobox
```

See https://github.com/octobox/octobox/blob/master/docs/INSTALLATION.md for more information on
configuration options for Octobox.

## Parameters

TODO, please consult [`values.yaml`](./values.yaml) for the time being.
