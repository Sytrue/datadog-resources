# BCKC Datadog Monitors

This module manages BCKC TrueCost monitoring in Datadog.

## Features
- HTTP Check Monitor with combined Check and Cluster alerts
- Teams notifications integration
- Environment-specific configurations

## Usage
```hcl
module "bckc_monitors" {
  source = "../../modules/datadog"

  environment    = "uat"
  bckc_url      = "bckc-uat.claimlogiq.com"
  teams_channel = "@teams-BCKC-Outages"
  teams_email   = "@29e0b7c6.apixio.com@amer.teams.ms"
}
```

## Variables
| Name | Description | Type | Default |
|------|-------------|------|---------|
| environment | Environment name (uat/prod) | string | - |
| bckc_url | BCKC TrueCost URL | string | bckc-uat.claimlogiq.com |
| teams_channel | Teams channel for notifications | string | @teams-BCKC-Outages |
| teams_email | Teams email for notifications | string | @29e0b7c6.apixio.com@amer.teams.ms |

## Alert Configuration
- Check Alert:
  - Warning: 2 consecutive failures
  - Critical: 3 consecutive failures
- Cluster Alert:
  - Warning: 40% failure rate
  - Critical: 50% failure rate
