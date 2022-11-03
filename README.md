[![CircleCI](https://circleci.com/gh/giantswarm/cloudflared-app.svg?style=shield)](https://circleci.com/gh/giantswarm/cloudflared-app)

# Cloudflared chart

Giant Swarm offers a Cloudflared App which can be installed in workload clusters.
Here we define the Cloudflared chart with its templates and default configuration.

## What is this app?
This app allows you to launch [Cloudflare Tunnels](https://www.cloudflare.com/en-gb/products/tunnel/)
and then route directly to services inside of your cluster. This approach
bypasses any external ingress paths and can also be configured to bypass
Kubernetes Ingress.

## Why did we add it?
This approach makes it a lot easier for customers who might be constrained in
regards to ingress options (such as limited external load balancer services or
for security reasons). It is especially useful for clusters that are OnPrem and
not running in a Public Cloud provider, as it allows those users to route
traffic from a public interface (Cloudflare) to private services running in Kubernetes.

## Who can use it?
Anyone that has a Cloudflare account can use this App.

---

## Index
- [Installing](#installing)
- [Configuring](#configuring)
- [Testing](#testing)
- [Compatibility](#compatibility)
- [Limitations](#limitations)
- [Release Process](#release-process)
- [Contributing & Reporting Bugs](#contributing--reporting-bugs)
- [Credit](#credit)

## Installing

There are 3 ways to install this app onto a workload cluster.

1. [Using our web interface](https://docs.giantswarm.io/ui-api/web/app-platform/#installing-an-app)
2. [Using our API](https://docs.giantswarm.io/api/#operation/createClusterAppV5)
3. Directly creating the [App custom resource](https://docs.giantswarm.io/ui-api/management-api/crd/apps.application.giantswarm.io/) on the management cluster.

(Note: It is possible to use the chart in this repository directly)

## Configuring
This app can be used in 2 ways:

1) Use existing tunnels -> This is the recommended Cloudflare way of running Cloudflared Tunnels
2) App Managed -> The App manages to create and delete the tunnels for you

### 1) Use existing Tunnels

Create Cloudflared Tunnel(s) from an existing device (It is recommended to at least create two tunnels for resilience). You can run `cloudflared` command:

```bash
$ cloudflared tunnel create <NAME>
```
It creates the tunnel and generates the credentials file in the default cloudflared directory. Also, it creates a subdomain of .cfargotunnel.com.

__Note__: You can map your (sub)domain now to the tunnel one `<TUNNEL_ID>.cfargotunnel.com.`. More info in the [official guide](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide).

Once the tunnels are created, the credentials JSON file(s) can be found in `~/.cloudflared/`. These need to be saved in a Kubernetes secret:

```bash
kubectl create secret generic -n cloudflared-namespace cloudflared-credentials --from-file=credentials.json=~/.cloudflared/<TUNNEL_ID-1>.json
```

At the same time, it is required to set `useExistingTunnels.enabled` to true and complete the keys within `useExistingTunnels` (An example is presented [below](#use-existing-tunnels)).

### 2) App Managed Cloudflared Tunnels
In order to use this you will need to ensure you have the following:

- Email address to login to Cloudflare API
- Cloudflare Account ID

![Cloudflare Account ID](https://raw.githubusercontent.com/giantswarm/cloudflared-app/main/accountid.png)
- Cloudflare API token with `Account:MyAccount Tunnel:Edit` capability

![Cloudflare API Token](https://raw.githubusercontent.com/giantswarm/cloudflared-app/main/apitoken.png)

#### Optional

The Tunnel requires a secret to launch, if one is not supplied the App can
create one for you. But as this secret is essential for launching the tunnel it
must be saved securely to ensure that you can launch the tunnel elsewhere if
needed.

You can supply your own secret:

```bash
 uuidgen | base64 | kubectl create secret -n my-tunnel generic my-tunnel-secret --from-file=/dev/stdin
```

The tunnel secret needs to be 32 bytes or more and needs to be stored base64 encoded. You can later supply the Kubernetes secret name.

####⚠️ *WARNING* When using Cloudflared tunnels managed by the app, the tunnel will be deleted upon
removal of the app. A pre delete hook will be executed that cleans the tunnel connection and then deletes the tunnel.

### Values configuration (values.yaml)

|Value                        |Description|Default|
|-----------------------------|-----------|-------|
|`namespace`                  | Namespace in which to launch the App        | `kube-system` |
|`serviceType`                | Giant Swarm service definition              | `managed` |
|`replicas`                   | Number of replicas to use for a deployment  | `2`       |
|`initImage.registry`         | Registry used for the init container image  | `quay.io` |
|`initImage.name`             | Image name used for the init container      | `giantswarm/debug` |
|`initImage.tag`              | Tag of init container image                 | `master` |
|`initImage.pullPolicy`       | Init container image Pull Policy            | `IfNotPresent` |
|`image.registry`             | Registry used for cloudflared               | `quay.io` |
|`image.name`                 | Image name for cloudflared                  | `giantswarm/cloudflared` |
|`image.tag`                  | Tag used for cloudflared image              | `2022.8.4-amd64` |
|`image.pullPolicy`           | Pull policy for cloudflared image           | `IfNotPresent` |
|`accountEmail`               | Account Email to use for the API (required) | `""` |
|`accountId`                  | Account ID (see above, required)            | `""` |
|`apiKey`                     | API key used for the API (see above, required or `apiKeySecretName` needs to be set) | `""` |
|`apiKeySecretName`           | Name of existing secret that containers the API Key, the API key needs to be stored in a key in the secret called `apiKey` (required or `apiKey` needs to be set) | `""` |
|`tunnelSecretBase64`         | Base64 encoded Tunnel Secret (see below, required or `tunnelSecretName` needs to be set | `""` |
|`tunnelSecretName`           | Name of existing secret container Tunnel Secret, the tunnel secret needs to be stored in a key in the secret called `tunnelSecret` (required or `tunnelSecretBase64` needs to be set) | `""` |
|`config`                     | Config file used for cloudflared. See [online documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/config) | see `values.yaml` |
|`useExistingTunnels.enabled` | Whether to use an existing Tunnel           | `false` |
|`useExistingTunnels.credentialsSecretName` | Secret name that contains the credential files | `""` |
|`useExistingTunnels.tunnel`  | Either the tunnel name or tunnel ID as found in credentials file| `""` |


### Examples

#### App Managed Tunnels

```
# values.yaml
accountEmail: "xxxx@xxxxx.com"
accountId: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
tunnelSecretBase64: "ZUY0xjNhZTgtNWI4MCx0ZjcvLTkxMOEt4zEyOWQyZDQpN8Y0Cg=="

config:
  no-tls-verify: false
  loglevel: "info"
  transport-loglevel: "info"
  ingress:
    - hostname: echo.xxxxxx.com
      service: http://echo-echo-server.default.svc.cluster.local
    - service: http_status:404

```

#### Use existing Tunnels
```
useExistingTunnels:
  enabled: true
  credentialsSecretName: my-tunnel-credentials
  tunnel: "f8c06a8a-1880-4e6e-8502-deb8f1d1253b"

config:
  no-tls-verify: false
  loglevel: "info"
  transport-loglevel: "info"
  ingress:
    - hostname: echo.xxxxxxxxxx.com
      service: http://echo-echo-server.default.svc.cluster.local
    - service: http_status:404
```

## Testing

Cloudflare offers the possibility of setting [Quick Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/do-more-with-tunnels/trycloudflare/) up for testing purposes. 
Quick Tunnels do not require registration or credentials and they offer a random URL under the `trycloudflare.com` domain. The URL is provided by the cloudflared application in its logs.

### Quick Tunnel example

```
useQuickTunnel: true

config:
  ingress:
    - service: http://echo-echo-server.default.svc.cluster.local
```

## Compatibility

This app has been tested to work with the following workload cluster release versions:

* KVM `v16.2.0`

## Limitations

Some apps have restrictions on how they can be deployed.
Not following these limitations will most likely result in a broken deployment.

## Release Process

* Ensure CHANGELOG.md is up to date.
* Create a new branch to trigger the release workflow e.g. to release `v0.1.0`,
  create a branch from main called `main#release#v0.1.0` and push it.
* This will push a new git tag and trigger a new tarball to be pushed to the
  `default-catalog` and the `giantswarm-catalog`


## Contributing & Reporting Bugs
If you have suggestions for how `cloudflared` could be improved, or want to report a bug, open an issue! We'd love all and any contributions.

Check out the [Contributing Guide](https://github.com/giantswarm/cloudflared-app/blob/main/CONTRIBUTING.md) for details on the contribution workflow, submitting patches, and reporting bugs.

## Credit

* https://github.com/giantswarm/cloudflared-app
