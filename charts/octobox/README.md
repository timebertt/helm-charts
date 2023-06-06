# octobox

Helm Chart for deploying an [Octobox](https://github.com/octobox/octobox) instance, including

- postgresql
- redis
- nginx (for serving static assets)

## Quick Start

### Cloud Installation

Install this [helm](https://helm.sh) chart on a cloud cluster by running:

```bash
helm repo add timebertt https://timebertt.github.io/helm-charts
# checkout values.yaml and fill in all the required secret values (e.g. `clientID` and `clientSecret`)
vi values.secret.yaml
helm install octobox -f values.secret.yaml timebertt/octobox
```

See https://github.com/octobox/octobox/blob/master/docs/INSTALLATION.md for more information on
configuration options for Octobox.

### Local Installation

You can also try out this chart on a local [kind](https://kind.sigs.k8s.io) cluster for quickly getting started.

1. Prepare the local cluster
    ```bash
    export KUBECONFIG=$HOME/.kube/config
    kind create cluster
    ```

2. Fetch the chart's helm dependencies
    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm dependency build
    ```

3. Generate some random secret values
    ```bash
    touch values.secret.yaml
    yq -i \
      ".config.octoboxAttributeEncryptionKey = \"$(cat /dev/urandom | base64 | head -c 32)\" |
      .config.secretKeyBase = \"$(cat /dev/urandom | base64 | head -c 32)\"" \
      values.secret.yaml
    ```

4. Serve static assets from octobox server pods instead of external nginx
    ```bash
    yq -i \
      ".config.serveStaticAssets = true |
      .nginx.enabled = false" \
      values.secret.yaml
    ```

5. Register a new OAuth app under https://github.com/settings/applications/new (homepage: http://localhost:3000, callback URL: http://localhost:3000/auth/github/callback)
    ```bash
    github_oauth_client_id="<your client id here>"
    github_oauth_client_secret="<your client secret here>"
    
    yq -i \
      ".config.github.oauth.clientID = \"$github_oauth_client_id\" |
      .config.github.oauth.clientSecret = \"$github_oauth_client_secret\"" \
      values.secret.yaml
    ```

6. Add your own GitHub user as an Octobox admin
    ```bash
    github_user="<your github user here>"
    yq -i \
      ".config.github.adminIDs[0] = \"$(curl -sS "https://api.github.com/users/$github_user" | jq -r '.id')\"" \
      values.secret.yaml
    ```

7. Install the helm chart using the prepared values
    ```bash
    helm install octobox -n octobox --create-namespace -f values.secret.yaml .
    ```

8. Forward the octobox server to http://localhost:3000
    ```bash
    k -n octobox port-forward svc/octobox 3000:80
    ```

## Parameters

TODO, please consult [`values.yaml`](./values.yaml) for the time being.
