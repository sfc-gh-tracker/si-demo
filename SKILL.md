---
name: si-demo
description: "Snowflake Intelligence demo toolkit. Generates personalized demos from prospect URLs with zero-click SI setup. Triggers: si demo, intelligence demo, sales demo, prep demo."
tools: ["snowflake_sql_execute", "web_fetch", "write", "reflect_semantic_model", "call_cortex_analyst", "bash", "open_browser"]
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
✅ CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML  → RUN IMMEDIATELY
✅ CREATE OR REPLACE AGENT TEMP.*              → RUN IMMEDIATELY
✅ ALTER SNOWFLAKE INTELLIGENCE ... ADD AGENT  → RUN IMMEDIATELY
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
  5. Creates Semantic View with tailored metrics
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
