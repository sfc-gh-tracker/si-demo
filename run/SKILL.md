---
name: si-demo:run
description: "Run live demo with a prepped company. Load context and assist with queries."
tools: ["snowflake_sql_execute", "call_cortex_analyst"]
---

# Live Demo Execution

Load context for an existing demo and assist with live queries.

## Usage

```
/si-demo run <company_slug>
```

## Golden Queries (always work)

1. "What's our revenue trend?"
2. "Who are our top customers?"
3. "Which products/regions are growing?"
4. "Show me month-over-month growth"
5. "What's our delinquency/churn rate?"

## Demo Tips

**Opening:**
> "Let me show you Snowflake Intelligence with data modeled after YOUR business."

**While it works:**
> "Notice it uses your terminology - not generic 'orders' but YOUR language."

**If something breaks:**
- Rephrase the question
- Use a golden query
- "Let me show you a different angle..."

## Objection Handlers

**"How is this different from ChatGPT?"**
> "Connected to YOUR Snowflake, sees your schemas, runs real queries. Data never leaves."

**"Is it secure?"**
> "Runs in your account, respects RBAC, data stays in your VPC."

**"What if it makes mistakes?"**
> "You approve changes. Like a fast junior engineer - productive but supervised."
