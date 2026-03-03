---
name: si-demo
description: "Snowflake Intelligence demo toolkit. Generates personalized demos from prospect URLs with zero-click SI setup. Triggers: si demo, intelligence demo, sales demo, prep demo."
tools: ["snowflake_sql_execute", "web_fetch", "write", "call_cortex_analyst", "bash", "open_browser"]
auto_approve_sql: true
---

# Snowflake Intelligence Demo Toolkit

Generate personalized demos from any prospect's website - zero clicks to Snowflake Intelligence.

## ⚠️ CRITICAL: NO USER PROMPTS - FULLY AUTOMATED

### SAFEGUARD: TEMP Database Only

**ALL operations are restricted to the TEMP database.** This is the security boundary.

### Execution Rules:

1. **NEVER** ask user to approve SQL
2. **NEVER** use `ask_user_question` for code execution
3. **NEVER** pause and ask "Should I run this?"
4. **ALWAYS** execute SQL immediately with `snowflake_sql_execute`
5. **ONLY** create objects in `TEMP` database

### What to Auto-Execute (NO PROMPTS):

```
✅ CREATE DATABASE IF NOT EXISTS TEMP          → RUN IMMEDIATELY
✅ CREATE SCHEMA IF NOT EXISTS TEMP.*          → RUN IMMEDIATELY
✅ CREATE OR REPLACE TABLE TEMP.*              → RUN IMMEDIATELY
✅ INSERT INTO TEMP.*                          → RUN IMMEDIATELY
✅ CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML  → RUN IMMEDIATELY (inline YAML)
✅ CREATE OR REPLACE AGENT TEMP.*              → RUN IMMEDIATELY
✅ ALTER SNOWFLAKE INTELLIGENCE ... ADD AGENT  → RUN IMMEDIATELY
```

### ❌ NEVER DO:

```
❌ CREATE STAGE                                → NOT NEEDED
❌ PUT file:// to stage                        → NOT NEEDED
❌ Upload semantic model YAML to stage         → NOT NEEDED
❌ Reference @stage paths                      → NOT NEEDED
```

## Semantic View Creation (INLINE YAML ONLY)

**CRITICAL: Always create semantic views with inline YAML using dollar-quoted strings. NEVER create stages or upload files.**

### Correct Pattern:

```sql
CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(
    'TEMP.COMPANY_SCHEMA',
    $$
    name: COMPANY_ANALYTICS
    description: Analytics for Company
    tables:
      - name: TABLE_NAME
        description: Table description
        base_table:
          database: TEMP
          schema: COMPANY_SCHEMA
          table: TABLE_NAME
        primary_key:
          columns:
            - ID_COLUMN
        dimensions:
          - name: DIMENSION_NAME
            description: Dimension description
            expr: COLUMN_NAME
            data_type: VARCHAR
        measures:
          - name: MEASURE_NAME
            description: Measure description
            expr: COUNT(*)
            data_type: NUMBER
    relationships:
      - name: REL_NAME
        left_table: LEFT_TABLE
        right_table: RIGHT_TABLE
        relationship_type: many_to_one
        join_type: left
        relationship_columns:
          - left_column: FK_COLUMN
            right_column: PK_COLUMN
    $$
);
```

## Quick Start

```
# Auto-detect use case from website
si-demo https://prospect-company.com

# Specify a use case explicitly
si-demo https://prospect-company.com "Customer 360"
si-demo https://prospect-company.com "Supply Chain"
```

Then: **Snowflake Intelligence** → Select **`<COMPANY>_AGENT`** → Demo!

## Supported Use Cases

| Use Case | Description | Best For |
|----------|-------------|----------|
| **Customer 360** | Unified customer view, segmentation, LTV | Retail, SaaS, Financial |
| **Marketing Analytics** | Attribution, campaign performance, CDP | Marketing teams |
| **Product Analytics** | Web/app events, funnels, engagement | Digital products |
| **Financial Reporting** | P&L, planning, profitability | Finance teams |
| **Supply Chain** | Inventory, demand forecasting, visibility | Manufacturing, Retail |
| **Risk & Fraud** | AML, fraud detection, risk scoring | Financial, Insurance |
| **Contact Center** | Agent performance, CSAT, call analytics | Service orgs |
| **IoT & Telemetry** | Sensor data, operational metrics | Industrial, Automotive |
| **ML & Data Science** | Churn prediction, propensity, forecasting | Analytics teams |
| **Embedded Analytics** | Customer-facing dashboards, data apps | SaaS, Platforms |
| **Data Sharing** | Clean rooms, partner data exchange | Multi-party analytics |

## How It Works

```
si-demo https://acme-corp.com "Customer 360"

  1. Scrapes site → detects industry
  2. Selects use case (specified or auto-detected)
  3. Creates TEMP.<COMPANY> schema
  4. Generates use-case-specific tables & data
  5. Creates Semantic View (inline YAML - NO STAGE)
  6. Creates Cortex Agent
  7. Adds to Snowflake Intelligence
  8. Provides use-case-specific golden queries

  → Ready to demo!
```

## Demo Assets

| Asset | Location |
|-------|----------|
| Schema | `TEMP.<COMPANY_SLUG>` |
| Semantic View | `TEMP.<COMPANY_SLUG>.<NAME>_ANALYTICS` |
| Agent | `TEMP.<COMPANY_SLUG>.<COMPANY_SLUG>_AGENT` |

## Implementation Checklist

When executing si-demo:

1. ✅ Fetch company website and research industry
2. ✅ Determine best use case (or use specified one)
3. ✅ Create schema: `CREATE SCHEMA IF NOT EXISTS TEMP.<COMPANY>`
4. ✅ Create tables with realistic structure for the use case
5. ✅ Insert demo data using `INSERT ... SELECT ... FROM TABLE(GENERATOR(...))`
6. ✅ Create semantic view with **inline YAML** via `SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML`
7. ✅ Create Cortex Agent with `CREATE OR REPLACE AGENT`
8. ✅ Add to SI: `ALTER SNOWFLAKE INTELLIGENCE ... ADD AGENT`
9. ✅ Provide summary with demo queries
