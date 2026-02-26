---
name: si-demo:setup
description: "First-time Snowflake connection setup with browser authentication."
tools: ["bash", "ask_user_question"]
---

# Connection Setup

For first-time users without a Snowflake connection.

## Steps

### 1. Check for existing connection

```bash
cortex connection list
```

Look for `si-demo-default`. If exists and works, skip setup.

### 2. Prompt for Snowflake URL

Ask user for their Snowflake URL (from browser bar when logged into Snowsight).

### 3. Parse account identifier

Extract account from URL:
- `https://abc123.snowflakecomputing.com` → `abc123`
- `https://org-acct.us-west-2.aws.snowflakecomputing.com` → `org-acct.us-west-2.aws`

**Parsing:**
1. Remove `https://`
2. Remove trailing `/`
3. Remove `.snowflakecomputing.com`
4. Result = account identifier

### 4. Create connection with browser auth

```bash
cortex connection add si-demo-default \
  --account <ACCOUNT> \
  --authenticator externalbrowser
```

Tell user:
```
🌐 Opening browser for authentication...
   Sign in with your Snowflake credentials.
```

### 5. Set as default & test

```bash
cortex connection use si-demo-default
```

Test with:
```sql
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE();
```

### 6. Continue with original command

Once connected, proceed with demo prep.
