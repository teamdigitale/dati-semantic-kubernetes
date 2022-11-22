[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://github.com/teamdigitale/dati-semantic-kubernetes/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/teamdigitale/dati-semantic-kubernetes.svg)](https://github.com/teamdigitale/dati-semantic-kubernetes/issues)

# dati-semantic-kubernetes

This is the configuration repository for the [schema.gov.it](schema.gov.it).

We use branch based environments to manage the configuration. The branch name is the environments it applies to.

## Environments

- [dev](https://github.com/teamdigitale/dati-semantic-kubernetes/tree/dev)
- [test](https://github.com/teamdigitale/dati-semantic-kubernetes/tree/test)
- [prod](https://github.com/teamdigitale/dati-semantic-kubernetes/tree/prod)

## Deliverables

The deliverables' repositories are:

- The NDC application:
  - https://github.com/teamdigitale/dati-semantic-backend
  - https://github.com/teamdigitale/dati-semantic-frontend

- Semantic viewers:
  - https://github.com/teamdigitale/dati-semantic-lodview
  - https://github.com/teamdigitale/LODE
  - https://github.com/teamdigitale/dati-semantic-WebVOWL

## Automation (Only for the `dev` environment)

Deployment to dev is automatic whenever there is a change in BE or FE app.

```mermaid
flowchart

    classDef default stroke:white,color:#fff,clusterBkg:none,fill:#3344d0
    classDef cluster font-weight: bold,fill:none,color:darkgray,stroke:#3344d0,stroke-width:2px
    classDef subgraph_padding fill:none, stroke:none, opacity:0
    classDef bounded_context stroke-dasharray:5 5

dev((developers fa:fa-user))
BE["backend\nrepo fa:fa-code"]
FE["frontend\nrepo fa:fa-code"]
KUBE["kubernetes\nrepo (dev branch) fa:fa-code"]
Registry[(ghcr.io\nregistry)]

subgraph Applications
direction TB
FE
BE
end

Registry -.- |download images| INFRA
dev -->|push\n changes fa:fa-code-merge| Applications
Applications -->|CI triggers workflow\nusing an access token\n on| KUBE
Applications -->|CI pushes\nimages| Registry
click KUBE "https://github.com/teamdigitale/dati-semantic-frontend/blob/main/.github/workflows/node.js.yml#L137" "Github Action"
KUBE --> |github webhook triggers\ndeployment| INFRA([ISTAT dev\ninfrastructure fa:fa-server])


```

## Promoting to `test`

This is a partially automated. Developers are expected to manually promote the `dev` configuration to `test` branch.

Once developer pushed his config changes to `test` branch, ISTAT will recieve a webhook and will start the deployment
process.

## Promoting to `prod`

This is totally manual process. 
Developers are expected to manually promote the `test` configuration to `prod` branch.

Then they should request the deployment of the `prod` configuration to ISTAT over the email.
