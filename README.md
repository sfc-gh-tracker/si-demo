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
si-demo https://company.com
```

**That's it.** Wait ~2 minutes, then open Snowflake Intelligence.

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
si-demo https://acme.com
```

Creates:
- `TEMP.ACME` schema
- `TEMP.ACME.ACME_ANALYTICS` semantic view
- `TEMP.ACME.ACME_AGENT` in Snowflake Intelligence

---

## Demo Queries

Once ready, try these in Snowflake Intelligence:

1. "What is our total revenue?"
2. "Who are our top 10 customers?"
3. "Show me the monthly trend"
4. "Which region has the most sales?"

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
