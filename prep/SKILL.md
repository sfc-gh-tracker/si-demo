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

## Input Format

```
/si-demo prep <URL> [USE_CASE]
```

- **URL** (required): Company website
- **USE_CASE** (optional): If not provided, auto-detect from website content

---

## Step 0: Ensure TEMP Database Exists

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE DATABASE IF NOT EXISTS TEMP;
```

---

## Step 1: Extract Company Intelligence & Determine Use Case

Fetch the URL and extract:
- Company name
- Industry
- Main products/services
- Business model (B2B, B2C, marketplace)

### Use Case Selection

**If USE_CASE is specified:** Use it directly.

**If USE_CASE is NOT specified:** Auto-detect based on company type:

| Company Type | Recommended Use Case |
|--------------|---------------------|
| Retail, E-commerce | **Customer 360** |
| Marketing/AdTech | **Marketing Analytics** |
| SaaS, Digital Product | **Product Analytics** |
| Bank, Insurance, FinTech | **Risk & Fraud** or **Financial Reporting** |
| Manufacturing, Logistics | **Supply Chain** |
| Healthcare | **Contact Center** or **Customer 360** |
| IoT, Industrial, Automotive | **IoT & Telemetry** |
| Data/Analytics Company | **Embedded Analytics** |
| Any B2B | **Customer 360** or **Financial Reporting** |

---

## Step 2: Create Schema (AUTO-EXECUTE)

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE SCHEMA IF NOT EXISTS TEMP.<COMPANY_SLUG>;
```

---

## Step 3: Create Use-Case-Specific Tables (AUTO-EXECUTE)

### Use Case Table Templates:

#### Customer 360
```
CUSTOMERS (customer_id, name, email, segment, ltv, acquisition_channel, signup_date, city, state, is_active)
ORDERS (order_id, customer_id, order_date, amount, status, channel)
INTERACTIONS (interaction_id, customer_id, interaction_date, channel, type, sentiment_score)
SUPPORT_TICKETS (ticket_id, customer_id, created_date, category, priority, resolution_time, csat_score)
```

#### Marketing Analytics
```
CAMPAIGNS (campaign_id, name, channel, start_date, budget, status)
AD_SPEND (spend_id, campaign_id, date, platform, spend, impressions, clicks)
CONVERSIONS (conversion_id, campaign_id, customer_id, conversion_date, attribution_model, revenue)
AUDIENCES (audience_id, name, size, segment_criteria)
```

#### Product Analytics
```
USERS (user_id, signup_date, plan, platform, country)
EVENTS (event_id, user_id, event_date, event_name, page, session_id, device)
SESSIONS (session_id, user_id, start_time, duration_seconds, pages_viewed, bounce)
FEATURE_USAGE (usage_id, user_id, feature, usage_date, count)
```

#### Financial Reporting
```
GL_TRANSACTIONS (txn_id, account_id, txn_date, amount, department, cost_center)
ACCOUNTS (account_id, account_name, account_type, parent_account)
BUDGET (budget_id, account_id, period, budget_amount, actual_amount)
REVENUE (revenue_id, customer_id, revenue_date, amount, product_line, region)
```

#### Supply Chain
```
ORDERS (order_id, customer_id, order_date, ship_date, delivery_date, status)
INVENTORY (sku_id, warehouse_id, quantity_on_hand, reorder_point, last_updated)
SUPPLIERS (supplier_id, name, lead_time_days, on_time_rate, quality_score)
SHIPMENTS (shipment_id, order_id, carrier, ship_date, delivery_date, cost)
DEMAND_FORECAST (forecast_id, sku_id, forecast_date, predicted_demand, actual_demand)
```

#### Risk & Fraud
```
TRANSACTIONS (txn_id, account_id, txn_date, amount, merchant, location, channel)
ACCOUNTS (account_id, customer_id, account_type, open_date, credit_limit, balance)
ALERTS (alert_id, txn_id, alert_date, rule_triggered, risk_score, disposition)
CUSTOMERS (customer_id, name, kyc_status, risk_tier, last_review_date)
```

#### Contact Center
```
CALLS (call_id, agent_id, customer_id, call_date, duration_seconds, wait_time, handle_time)
AGENTS (agent_id, name, team, hire_date, skills, is_active)
TICKETS (ticket_id, customer_id, created_date, channel, category, first_response_time, resolution_time)
CSAT_SURVEYS (survey_id, call_id, survey_date, csat_score, nps_score, comments)
```

#### IoT & Telemetry
```
DEVICES (device_id, device_type, location, install_date, firmware_version, status)
TELEMETRY (reading_id, device_id, timestamp, metric_name, metric_value, unit)
ALERTS (alert_id, device_id, alert_time, severity, alert_type, acknowledged)
MAINTENANCE (maintenance_id, device_id, maintenance_date, type, cost, technician)
```

#### Embedded Analytics
```
TENANTS (tenant_id, name, plan, signup_date, mrr, industry)
DASHBOARD_VIEWS (view_id, tenant_id, user_id, dashboard_id, view_date)
REPORTS (report_id, tenant_id, report_type, generated_date, row_count, export_format)
API_CALLS (call_id, tenant_id, endpoint, call_date, response_time_ms, status_code)
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
UNIFORM(100, 5000, RANDOM())                    -- Random integer in range
UNIFORM(0.5, 2.5, RANDOM())                     -- Random decimal multiplier
ARRAY_CONSTRUCT('CA','TX','NY','FL')[UNIFORM(0,3,RANDOM())::INT]  -- Random from array
DATEADD(DAY, -UNIFORM(1, 730, RANDOM()), CURRENT_DATE())  -- Random dates
ROUND(UNIFORM(100, 10000, RANDOM()) * UNIFORM(0.8, 1.5, RANDOM()), 2)  -- Varied amounts

-- Weighted distributions
CASE 
  WHEN RANDOM() < 0.3 THEN 'High'
  WHEN RANDOM() < 0.7 THEN 'Medium'
  ELSE 'Low'
END
```

**Goal:** Aggregations by dimension should show DIFFERENT values!

---

## Step 5: Create Semantic View (AUTO-EXECUTE)

**⚠️ DO NOT create a stage or upload a YAML file. Use the inline method ONLY.**

```sql
CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(
  'TEMP.<COMPANY_SLUG>',
  $$
name: <COMPANY>_ANALYTICS
tables:
  - name: ...
$$,
  FALSE
);
```

**⛔ NEVER:** `CREATE STAGE`, `PUT file`, `@stage/file.yaml`
**✅ ALWAYS:** Pass YAML inline in `$$...$$`

---

## Step 6: Test Queries (SKIP - Go directly to Step 7)

---

## Step 7: Create Agent (AUTO-EXECUTE)

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE OR REPLACE AGENT TEMP.<SLUG>.<SLUG>_AGENT
  COMMENT = 'AI agent for <COMPANY_NAME> <USE_CASE> demo'
  FROM SPECIFICATION $$
  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "<Company>Analyst"
        description: "Queries <COMPANY_NAME> <USE_CASE> data using natural language"
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

---

## Step 9: Report Summary with Use-Case-Specific Golden Queries

Print summary with **USE CASE SPECIFIC** golden queries:

### Golden Queries by Use Case:

#### Customer 360
1. "Who are our top 10 customers by lifetime value?"
2. "What is our customer retention rate by segment?"
3. "Which acquisition channels drive the highest LTV?"
4. "Show me customer churn trend by month"
5. "What is the average order value by customer segment?"

#### Marketing Analytics
1. "What is our total ad spend by channel?"
2. "Which campaigns have the best ROAS?"
3. "Show me conversion rate by attribution model"
4. "What is our cost per acquisition trend?"
5. "Which audiences have the highest conversion rate?"

#### Product Analytics
1. "What are the most used features?"
2. "What is our daily active user trend?"
3. "Show me the conversion funnel by step"
4. "Which pages have the highest bounce rate?"
5. "What is session duration by platform?"

#### Financial Reporting
1. "What is our total revenue by product line?"
2. "Show me budget vs actual by department"
3. "What is our gross margin trend?"
4. "Which cost centers are over budget?"
5. "What is revenue growth month over month?"

#### Supply Chain
1. "What is our current inventory level by warehouse?"
2. "Which suppliers have the best on-time delivery?"
3. "Show me demand forecast accuracy"
4. "What is our average delivery time by carrier?"
5. "Which SKUs are below reorder point?"

#### Risk & Fraud
1. "How many high-risk alerts this month?"
2. "What is our fraud detection rate by channel?"
3. "Show me transaction volume by risk tier"
4. "Which rules trigger the most alerts?"
5. "What is the false positive rate trend?"

#### Contact Center
1. "What is our average handle time by team?"
2. "Show me CSAT score trend by month"
3. "Which agents have the best resolution rate?"
4. "What is average wait time by hour?"
5. "What are the top ticket categories?"

#### IoT & Telemetry
1. "How many devices are currently offline?"
2. "What is average sensor reading by location?"
3. "Show me alert volume by severity"
4. "Which device types have the most maintenance?"
5. "What is uptime percentage by device type?"

#### Embedded Analytics
1. "Which tenants have the most dashboard views?"
2. "What is API call volume by endpoint?"
3. "Show me report generation by tenant tier"
4. "What is average response time trend?"
5. "Which features are most used by enterprise tenants?"

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
3. **Use case drives everything** - tables, data, and golden queries
