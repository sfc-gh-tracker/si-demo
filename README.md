# SI Demo

**Generate personalized Snowflake Intelligence demos in one command.**

---

## Prerequisites

1. **Cortex CLI** installed (`~/.local/bin/cortex`)
2. **Snowflake account** with the **AE** role (see [AE Role Setup](#ae-role-setup-account-owners) below)

> **Note:** The `SI_DEMO` warehouse is automatically created during execution.

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

## AE Role Setup (Account Owners)

If you need to grant non-ACCOUNTADMIN users (e.g. AEs) access to run SI demos, run the following as ACCOUNTADMIN:

```sql
-- Create AE Role
CREATE ROLE IF NOT EXISTS AE;

-- Create SI_DEMO Warehouse
CREATE WAREHOUSE IF NOT EXISTS SI_DEMO
    WAREHOUSE_SIZE = 'LARGE'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;
GRANT USAGE ON WAREHOUSE SI_DEMO TO ROLE AE;
GRANT OPERATE ON WAREHOUSE SI_DEMO TO ROLE AE;

-- Create TEMP Database (ACCOUNTADMIN owned)
CREATE DATABASE IF NOT EXISTS TEMP;

-- Grant database-level privileges (all except ownership)
GRANT ALL PRIVILEGES ON DATABASE TEMP TO ROLE AE;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE TEMP TO ROLE AE;
GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE TEMP TO ROLE AE;

-- Grant future object privileges in TEMP
GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE TEMP TO ROLE AE;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN DATABASE TEMP TO ROLE AE;
GRANT CREATE SCHEMA ON DATABASE TEMP TO ROLE AE;

-- Grant semantic view creation
GRANT CREATE SEMANTIC VIEW ON ALL SCHEMAS IN DATABASE TEMP TO ROLE AE;
GRANT CREATE SEMANTIC VIEW ON FUTURE SCHEMAS IN DATABASE TEMP TO ROLE AE;

-- Grant stored procedure usage
GRANT USAGE ON FUTURE PROCEDURES IN DATABASE TEMP TO ROLE AE;
GRANT USAGE ON ALL PROCEDURES IN DATABASE TEMP TO ROLE AE;

-- Grant account-level privileges for SI-DEMO
GRANT CREATE CORTEX AGENT ON ACCOUNT TO ROLE AE;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE AE;

-- Grant Snowflake Intelligence access
GRANT MODIFY ON SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT TO ROLE AE;

-- Grant AE role to ACCOUNTADMIN hierarchy
GRANT ROLE AE TO ROLE ACCOUNTADMIN;

-- Create AE user in Snowsight and add PAT (can also do via code if desired)

-- Grant AE role to user
GRANT ROLE AE TO USER <user_name>;
```

---

## Clean Up

```sql
DROP SCHEMA TEMP.<COMPANY> CASCADE;
```
