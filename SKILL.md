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
si-demo https://prospect-company.com
```

Then: **Snowflake Intelligence** → Select **`<COMPANY>_AGENT`** → Demo!

## How It Works

```
si-demo https://acme-corp.com

  1. Scrapes site → detects industry
  2. Creates TEMP.<COMPANY> schema
  3. Generates mock data (50K-200K rows)
  4. Creates Semantic View
  5. Creates Cortex Agent
  6. Adds to Snowflake Intelligence
  7. Opens browser automatically

  → Ready to demo!
```

## Industry Templates

| Industry | Tables | Best For |
|----------|--------|----------|
| **saas** | subscriptions, customers, usage, invoices | Software, B2B |
| **retail** | orders, customers, products, inventory | E-commerce |
| **healthcare** | patients, visits, staff, referrals | Health tech |
| **financial** | members, loans, accounts, transactions, credit_cards | Fintech, Credit Unions |
| **manufacturing** | orders, inventory, suppliers, shipments | Industrial |

## Demo Assets

| Asset | Location |
|-------|----------|
| Schema | `TEMP.<COMPANY_SLUG>` |
| Semantic View | `TEMP.<COMPANY_SLUG>.<NAME>_ANALYTICS` |
| Agent | `TEMP.<COMPANY_SLUG>.<COMPANY_SLUG>_AGENT` |

## Live Demo Tips

**Golden queries (always work):**
1. "What's our revenue trend?"
2. "Who are our top customers?"
3. "Which products/regions are growing?"
4. "Show me month-over-month growth"
