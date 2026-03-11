---
name: si-demo
description: "Snowflake Intelligence demo toolkit. Generates personalized demos from prospect URLs with zero-click SI setup. Triggers: si demo, intelligence demo, sales demo, prep demo."
tools: ["snowflake_sql_execute", "web_fetch", "write", "call_cortex_analyst", "bash", "open_browser", "reflect_semantic_model"]
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

| Operation | Action |
|-----------|--------|
| `CREATE OR REPLACE SCHEMA TEMP.*` | **EXECUTE IMMEDIATELY** |
| `CREATE TABLE TEMP.*` | **EXECUTE IMMEDIATELY** |
| `INSERT INTO TEMP.*` | **EXECUTE IMMEDIATELY** |
| `CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(...)` | **EXECUTE IMMEDIATELY** |
| `CREATE AGENT TEMP.*` | **EXECUTE IMMEDIATELY** |

### ❌ NEVER DO:

```
❌ CREATE STAGE                                → NOT NEEDED
❌ PUT file:// to stage                        → NOT NEEDED
❌ Upload semantic model YAML to stage         → NOT NEEDED
❌ Reference @stage paths                      → NOT NEEDED
```

---

## Quick Start

```
# Auto-detect use case from website
si-demo https://prospect-company.com

# Specify a use case explicitly
si-demo https://prospect-company.com "Customer 360"
si-demo https://prospect-company.com "Supply Chain"
```

Then: **Snowflake Intelligence** → Select **`<COMPANY>_AGENT`** → Demo!

---

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

---

## Demo Assets

| Asset | Location |
|-------|----------|
| Schema | `TEMP.<COMPANY_SLUG>` |
| Semantic View | `TEMP.<COMPANY_SLUG>.<NAME>_ANALYTICS` |
| Agent | `TEMP.<COMPANY_SLUG>.<COMPANY_SLUG>_AGENT` |

---

## Implementation Steps

### Step 1: Extract Company Intelligence & Determine Use Case

Fetch the URL and extract:
- Company name
- Industry
- Main products/services
- Business model (B2B, B2C, marketplace)

**Then crawl deeper.** Follow links to product pages, "About Us", investor relations, or any page that reveals:
- Specific product names, brands, and SKUs
- Product categories and lines
- Geographic markets served
- Customer segments (e.g. hospitals, clinics, enterprises)
- Real pricing tiers if available

Fetch **at least 2-3 additional pages** beyond the homepage (e.g. `/products`, `/solutions`, `/about`, `/investors`) to build a rich picture. The more real detail you capture, the better the demo.

#### ⚠️ CRITICAL: USE REAL COMPANY DATA IN MOCK DATA

**ALL dimension values (product names, categories, regions, customer segments, etc.) MUST come from what you scraped from the company's website.** Do NOT use generic placeholders.

| Data Element | What To Do |
|-------------|------------|
| Product names | Use actual product/brand names from the website |
| Product lines/categories | Use the company's real product categories |
| Customer types | Use real customer segments the company serves (e.g. "Hospitals", "Ambulatory Surgery Centers") |
| Regions | Use regions where the company actually operates |
| Supplier component types | Map to the company's actual product components |
| Warehouse locations | Use the company's real facility locations if available |
| Channel names | Use the company's actual sales/distribution channels |
| Department names | Use realistic departments for that industry |

**Example - Medical Device Company (Merit Medical):**
- Products: "SplashWire Hydrophilic Guide Wire", "Temno Biopsy Needle", "HeRO Graft" (NOT "Product A", "Product B")
- Product Lines: "Cardiovascular", "Endoscopy", "Interventional Oncology" (NOT "Line 1", "Line 2")
- Locations: "South Jordan, UT", "Galway, Ireland", "Tijuana, Mexico" (NOT "Warehouse 1", "Warehouse 2")

**Example - SaaS Company (Datadog):**
- Products: "Infrastructure Monitoring", "APM", "Log Management", "Cloud SIEM" (NOT "Product A")
- Customer Segments: "Enterprise", "Mid-Market", "Startup" with real industry verticals
- Regions: Map to where the company has offices

**If the website doesn't provide enough detail for a dimension, make reasonable inferences based on the company's industry — but always prefer real data over generic labels.**

#### Use Case Selection

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

### Step 2: Create Schema (AUTO-EXECUTE)

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE OR REPLACE SCHEMA TEMP.<COMPANY_SLUG>;
```

---

### Step 3: Create Use-Case-Specific Tables (AUTO-EXECUTE)

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

### Step 4: Generate Mock Data (AUTO-EXECUTE)

Generate realistic data:
- 10,000 - 75,000 rows per fact table
- 1,000 - 5,000 rows per dimension table

#### ⚠️ MANDATORY: USE SCRAPED DATA FROM STEP 1

All CASE statements for dimension values **MUST** use the real product names, categories, locations, and other details extracted from the company's website in Step 1. Do NOT fall back to generic values. If you have 12 real product names, use all 12. If you found 5 real warehouse locations, use those exact locations.

Review your Step 1 extraction before writing any INSERT statements to ensure every dimension value traces back to something real about the company.

#### ⚠️ CRITICAL: DIMENSION-AWARE RANDOMIZATION

**THE PROBLEM:** Using `UNIFORM(100, 5000, RANDOM())` alone creates identical averages across all dimensions!

**THE SOLUTION:** Numeric values MUST vary based on dimension values using CASE statements.

#### Pattern 1: CASE-based multipliers (REQUIRED for all measures)

```sql
-- WRONG: Same average across all channels
UNIFORM(100, 1000, RANDOM()) AS AMOUNT

-- RIGHT: Different ranges per dimension value
CASE CHANNEL
    WHEN 'Branch' THEN UNIFORM(500, 15000, RANDOM())
    WHEN 'Online Banking' THEN UNIFORM(200, 5000, RANDOM())
    WHEN 'Credit Card' THEN UNIFORM(50, 800, RANDOM())
    WHEN 'Mobile App' THEN UNIFORM(10, 300, RANDOM())
    WHEN 'Debit Card' THEN UNIFORM(5, 150, RANDOM())
END * UNIFORM(0.7, 1.4, RANDOM()) AS AMOUNT
```

#### Pattern 2: Category multipliers for compound variance

```sql
-- Apply category-specific multipliers AFTER base amount
AMOUNT * CASE CATEGORY
    WHEN 'Enterprise' THEN UNIFORM(3.0, 5.0, RANDOM())
    WHEN 'Mid-Market' THEN UNIFORM(1.5, 2.5, RANDOM())
    WHEN 'SMB' THEN UNIFORM(0.5, 1.2, RANDOM())
END AS ADJUSTED_AMOUNT
```

#### Pattern 3: Correlated dimensions (risk scores, ratings)

```sql
-- High-risk rules should have higher scores
CASE RULE_TYPE
    WHEN 'Pattern Anomaly' THEN UNIFORM(75, 98, RANDOM())
    WHEN 'International' THEN UNIFORM(60, 90, RANDOM())
    WHEN 'Velocity' THEN UNIFORM(50, 80, RANDOM())
    WHEN 'Large Transaction' THEN UNIFORM(35, 65, RANDOM())
    ELSE UNIFORM(25, 50, RANDOM())
END AS RISK_SCORE
```

#### Pattern 4: Two-step INSERT + UPDATE (when needed)

If CASE references a column set in the same SELECT, use UPDATE:

```sql
-- Step 1: Insert with CHANNEL but NULL amount
INSERT INTO TABLE SELECT ..., CHANNEL, NULL AS AMOUNT ...

-- Step 2: Update amount based on CHANNEL
UPDATE TABLE SET AMOUNT = CASE CHANNEL
    WHEN 'Branch' THEN UNIFORM(500, 15000, RANDOM())
    ...
END;
```

#### Validation Check

After generating data, run:
```sql
SELECT DIMENSION_COL, ROUND(AVG(MEASURE), 2) AS AVG_VAL 
FROM TABLE GROUP BY DIMENSION_COL;
```

**If all averages are within 10% of each other, the data is TOO UNIFORM - regenerate!**

Expected variance example:
| Channel | Avg Amount |
|---------|------------|
| Branch | $12,720 |
| Online | $3,890 |
| Credit Card | $720 |
| Mobile | $223 |
| Debit | $105 |

---

### Step 5: Create Semantic View (AUTO-EXECUTE)

**⚠️ DO NOT create a stage or upload a YAML file. Use the inline method ONLY.**

```sql
CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(
  'TEMP.<COMPANY_SLUG>',
  $$
name: <COMPANY>_ANALYTICS
description: Analytics for <COMPANY>
tables:
  - name: TABLE_NAME
    description: Table description
    base_table:
      database: TEMP
      schema: <COMPANY_SLUG>
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
    relationship_columns:
      - left_column: FK_COLUMN
        right_column: PK_COLUMN
verified_queries:
  - name: vqr_example
    question: Example question?
    verified_at: 1709251200
    verified_by: demo
    sql: |
      SELECT ... FROM TEMP.<COMPANY_SLUG>.TABLE
$$
);
```

**⛔ NEVER:** `CREATE STAGE`, `PUT file`, `@stage/file.yaml`
**✅ ALWAYS:** Pass YAML inline in `$$...$$`

### Semantic View Column Types (use these exact types):
- `TEXT` (not VARCHAR)
- `NUMBER` (not DECIMAL, INTEGER)
- `DATE`
- `TIMESTAMP`
- `BOOLEAN`

### ⚠️ CRITICAL: Semantic View Relationships

**DO NOT include `join_type` or `relationship_type` in relationships!**

Semantic views auto-infer relationship types from the data. Including these fields causes errors:
```
Error: invalid value for enum field joinType: "left"
```

**WRONG:**
```yaml
relationships:
  - name: orders_to_customers
    left_table: orders
    right_table: customers
    relationship_type: many_to_one  # ❌ CAUSES ERROR
    join_type: left                  # ❌ CAUSES ERROR
    relationship_columns:
      - left_column: customer_id
        right_column: customer_id
```

**CORRECT:**
```yaml
relationships:
  - name: orders_to_customers
    left_table: orders
    right_table: customers
    relationship_columns:
      - left_column: customer_id
        right_column: customer_id
```

Also add `unique: true` to primary key dimensions for proper relationship inference.

---

### Step 6: Create Agent (AUTO-EXECUTE)

**EXECUTE IMMEDIATELY - NO PROMPT:**
```sql
CREATE OR REPLACE AGENT TEMP.<COMPANY_SLUG>.<COMPANY_SLUG>_AGENT
  COMMENT = 'AI agent for <COMPANY_NAME> <USE_CASE> demo'
  FROM SPECIFICATION $$
  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "<Company>Analyst"
        description: "Queries <COMPANY_NAME> <USE_CASE> data using natural language"
  tool_resources:
    <Company>Analyst:
      semantic_view: "TEMP.<COMPANY_SLUG>.<COMPANY_SLUG>_ANALYTICS"
  $$;
```

---

### Step 7: Report Summary with Use-Case-Specific Golden Queries

Print summary with **USE CASE SPECIFIC** golden queries:

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

## Remember

1. **TEMP database ONLY** - this is the safeguard
2. **NO PROMPTS** - execute everything automatically
3. **Use case drives everything** - tables, data, and golden queries
4. **Inline YAML only** - never create stages for semantic views
5. **No join_type in relationships** - semantic views auto-infer (legacy models required it, semantic views don't)
6. **Real company data ONLY** - product names, categories, locations, and dimensions MUST come from the scraped website. Crawl multiple pages. Never use generic placeholders
7. **Test before finishing** - use `call_cortex_analyst` to verify semantic view works with a sample query
