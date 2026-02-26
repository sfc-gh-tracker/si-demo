---
name: si-demo:prep
description: "Prepare personalized demo for a prospect. Generates mock data, Semantic View, Cortex Agent, and adds to Snowflake Intelligence from company URL. Zero-click setup."
tools: ["web_fetch", "snowflake_sql_execute", "write", "reflect_semantic_model", "call_cortex_analyst", "open_browser"]
auto_approve_sql: true
---

# Demo Prep - Personalized Prospect Demo

## ⚠️ CRITICAL: FULLY AUTOMATED EXECUTION - NO PROMPTS

**SAFEGUARD: ALL operations are restricted to the TEMP database ONLY.**

### Execution Rules:
1. **NEVER** use `ask_user_question` for SQL approval
2. **NEVER** pause to ask "Should I run this?"
3. **ALWAYS** execute SQL immediately using `snowflake_sql_execute`
4. **ALL** operations MUST use `TEMP` database - this is the safeguard

### Auto-Execute These (NO PROMPTS):
| Operation | Action |
|-----------|--------|
| `CREATE DATABASE IF NOT EXISTS TEMP` | **EXECUTE IMMEDIATELY** |
| `CREATE SCHEMA IF NOT EXISTS TEMP.*` | **EXECUTE IMMEDIATELY** |
| `CREATE TABLE TEMP.*` | **EXECUTE IMMEDIATELY** |
| `INSERT INTO TEMP.*` | **EXECUTE IMMEDIATELY** |
| `CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(...)` | **EXECUTE IMMEDIATELY** |
| `CREATE AGENT TEMP.*` | **EXECUTE IMMEDIATELY** |
| `ALTER SNOWFLAKE INTELLIGENCE ... ADD AGENT` | **EXECUTE IMMEDIATELY** |

---

## Step 0: Ensure TEMP Database Exists

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE DATABASE IF NOT EXISTS TEMP;
```

---

## Step 1: Extract Company Intelligence

Fetch the URL and extract:
- Company name
- Industry (map to: saas, retail, healthcare, financial, manufacturing)
- Main products/services
- Business model (B2B, B2C, marketplace)

Use web_fetch to get the page, then analyze content.

---

## Step 2: Create Schema (AUTO-EXECUTE)

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE SCHEMA IF NOT EXISTS TEMP.<COMPANY_SLUG>;
```

---

## Step 3: Create Tables (AUTO-EXECUTE)

Select template based on industry:

- `saas` - subscriptions, customers, usage_events, invoices
- `retail` - orders, customers, products, inventory
- `healthcare` - patients, visits, claims, providers
- `financial` - members, loans, accounts, transactions, credit_cards
- `manufacturing` - orders, inventory, suppliers, shipments

```sql
CREATE OR REPLACE TABLE TEMP.<SLUG>.<TABLE_NAME> (...);
```

---

## Step 4: Generate Mock Data (AUTO-EXECUTE)

Generate realistic data:
- 10,000 - 75,000 rows per fact table
- 1,000 - 5,000 rows per dimension table

### ⚠️ CRITICAL: Use TRUE RANDOMIZATION

**DO NOT** use simple `MOD(SEQ4(), N)` patterns - this creates uniform/identical distributions!

**ALWAYS** use these Snowflake functions for realistic variance:

```sql
-- Random numbers with variance
UNIFORM(100, 5000, RANDOM())                    -- Random integer in range
UNIFORM(0.5, 2.5, RANDOM())                     -- Random decimal multiplier

-- Random selection from arrays (for states, cities, categories)
ARRAY_CONSTRUCT('CA','TX','NY','FL','WA','IL','PA','OH','GA','NC')[UNIFORM(0,9,RANDOM())::INT]

-- Random dates with spread
DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE())

-- Random amounts with realistic variance
ROUND(UNIFORM(100, 10000, RANDOM()) * UNIFORM(0.8, 1.5, RANDOM()), 2)

-- Weighted distributions (e.g., more orders from certain states)
CASE 
  WHEN RANDOM() < 0.3 THEN 'CA'   -- 30% California
  WHEN RANDOM() < 0.5 THEN 'TX'   -- 20% Texas  
  WHEN RANDOM() < 0.65 THEN 'NY'  -- 15% New York
  ELSE ARRAY_CONSTRUCT('FL','WA','IL','PA','OH')[UNIFORM(0,4,RANDOM())::INT]
END
```

### Example Pattern:
```sql
INSERT INTO TEMP.<SLUG>.ORDERS
SELECT 
    SEQ4() AS ORDER_ID,
    UNIFORM(1, 5000, RANDOM()) AS CUSTOMER_ID,
    DATEADD(DAY, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) AS ORDER_DATE,
    ROUND(UNIFORM(50, 2000, RANDOM()) * UNIFORM(0.7, 1.4, RANDOM()), 2) AS AMOUNT,
    CASE WHEN RANDOM() < 0.35 THEN 'CA' WHEN RANDOM() < 0.55 THEN 'TX' 
         WHEN RANDOM() < 0.70 THEN 'NY' ELSE ARRAY_CONSTRUCT('FL','WA','IL')[UNIFORM(0,2,RANDOM())::INT] END AS STATE
FROM TABLE(GENERATOR(ROWCOUNT => 50000));
```

**Goal:** When user asks "revenue by state" - each state should have DIFFERENT totals!

---

## Step 5: Create Semantic View (AUTO-EXECUTE)

**⚠️ DO NOT create a stage or upload a YAML file. Use the inline method ONLY.**

1. Generate YAML content inline (do NOT write to file or stage)

2. Validate with `reflect_semantic_model`

3. **EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(
  'TEMP.<COMPANY_SLUG>',
  $$
name: <COMPANY>_ANALYTICS
tables:
  - name: ...
    ...
$$,
  FALSE
);
```

**⛔ NEVER DO THIS:**
- `CREATE STAGE` - NO
- `PUT file` - NO  
- `@stage/file.yaml` - NO

**✅ ALWAYS DO THIS:**
- Pass YAML directly as string in `$$...$$` to `SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML`

---

## Step 6: Test Queries (AUTO-EXECUTE)

Test each verified query using `call_cortex_analyst`:
```
call_cortex_analyst(
  query="What's our trend?",
  semantic_view="TEMP.<SLUG>.<VIEW_NAME>"
)
```

---

## Step 7: Create Agent (AUTO-EXECUTE)

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE OR REPLACE AGENT TEMP.<SLUG>.<SLUG>_AGENT
  COMMENT = 'AI agent for <COMPANY_NAME> demo'
  FROM SPECIFICATION $$
  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "<Company>Analyst"
        description: "Queries <COMPANY_NAME> data using natural language"
  tool_resources:
    <Company>Analyst:
      semantic_view: "TEMP.<SLUG>.<VIEW_NAME>"
      execution_environment: {type: "warehouse", warehouse: "DEMO_WH"}
  $$;
```

---

## Step 8: Add to Snowflake Intelligence (CRITICAL - DO NOT SKIP)

**⚠️ THIS STEP IS MANDATORY - THE DEMO IS INCOMPLETE WITHOUT IT**

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT 
  ADD AGENT TEMP.<SLUG>.<SLUG>_AGENT;
```

**VERIFY:** If this step fails, retry. If agent already exists, that's OK - continue to Step 9.

---

## Step 9: Report Summary

Print summary:
```
🎉 Demo ready for <COMPANY>!

Schema: TEMP.<SLUG>
Semantic View: TEMP.<SLUG>.<VIEW_NAME>
Agent: TEMP.<SLUG>.<SLUG>_AGENT
Tables: X (list)
Rows: Y total

Golden Queries:
1. "..."
2. "..."
```

---

## Semantic View Requirements

### Column Types (use these exact types):
- `TEXT` (not VARCHAR)
- `NUMBER` (not DECIMAL, INTEGER)
- `DATE`
- `TIMESTAMP`
- `BOOLEAN`

### Structure:
- Use `facts` not `measures` (deprecated)
- Include 5 verified_queries named `vqr_*`

---

## Remember

1. **TEMP database ONLY** - this is the safeguard
2. **NO PROMPTS** - execute everything automatically
3. **Open browser** at the end automatically
