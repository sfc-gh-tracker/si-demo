# SI Demo

**Generate personalized Snowflake Intelligence demos in one command.**

---

## Prerequisites

1. **Cortex CLI** installed (`~/.local/bin/cortex`)
2. **Snowflake account** with ACCOUNTADMIN access
3. **DEMO_WH** warehouse available

---

## Install (one-time)

```bash
curl -sSL https://raw.githubusercontent.com/sfc-gh-tracker/si-demo/main/install.sh | bash
```

---

## Usage

```bash
# Auto-detect use case from website
/si-demo https://company.com

# Specify a use case
/si-demo https://company.com "Customer 360"
/si-demo https://company.com "Supply Chain"
/si-demo https://company.com "Marketing Analytics"
```

**That's it.** Wait ~2 minutes, then open Snowflake Intelligence.

---

## Supported Use Cases

| Use Case | Best For |
|----------|----------|
| **Customer 360** | Unified customer view, segmentation, LTV |
| **Marketing Analytics** | Attribution, campaigns, ROAS |
| **Product Analytics** | Web/app events, funnels, DAU |
| **Financial Reporting** | P&L, budget vs actual, margin |
| **Supply Chain** | Inventory, forecasting, delivery |
| **Risk & Fraud** | AML, fraud detection, alerts |
| **Contact Center** | Agent performance, CSAT, handle time |
| **IoT & Telemetry** | Sensors, devices, uptime |
| **Embedded Analytics** | Multi-tenant dashboards, API usage |

---

## What It Creates

| Asset | Location |
|-------|----------|
| Schema | `TEMP.<COMPANY>` |
| Tables | 4-5 tables, ~100K rows |
| Semantic View | `TEMP.<COMPANY>.<COMPANY>_ANALYTICS` |
| Agent | `TEMP.<COMPANY>.<COMPANY>_AGENT` |

---

## Example

```bash
si-demo https://acme.com "Customer 360"
```

Creates:
- `TEMP.ACME` schema with Customer 360 tables
- `TEMP.ACME.ACME_ANALYTICS` semantic view
- `TEMP.ACME.ACME_AGENT` in Snowflake Intelligence

Golden queries will be tailored to Customer 360:
- "Who are our top customers by LTV?"
- "What is retention by segment?"

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Agent not in SI | Run: `ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT ADD AGENT TEMP.<COMPANY>.<COMPANY>_AGENT` |
| Auth prompt | Log in once, session stays alive |
| Command not found | Re-run the install command |

---

## Clean Up

```sql
DROP SCHEMA TEMP.<COMPANY> CASCADE;
```
