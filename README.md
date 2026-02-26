# SI Demo

Generate personalized Snowflake Intelligence demos from any company URL - zero clicks.

## Install

```bash
curl -sSL https://raw.githubusercontent.com/sfc-gh-tracker/si-demo/main/install.sh | bash
```

Or manually:
```bash
cortex skill add https://github.com/sfc-gh-tracker/si-demo
```

## Usage

```bash
si-demo https://company.com
```

That's it. The script will:
1. Scrape the company website
2. Generate mock data in TEMP database
3. Create a Semantic View
4. Create a Cortex Agent
5. Add to Snowflake Intelligence
6. Open your browser

## Examples

```bash
si-demo https://acme.com
si-demo https://snapfinance.com
si-demo https://gwcu.org
```

## Requirements

- Cortex CLI installed
- Snowflake connection configured
