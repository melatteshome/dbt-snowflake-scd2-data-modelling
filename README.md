# Retail Analytics — dbt + Snowflake

A data engineering project that transforms raw e-commerce data into analytics-ready datasets using **Snowflake** and **dbt**.

The project demonstrates dimensional data modeling, transformation workflows, and **Slowly Changing Dimension Type 2 (SCD2)** implementation for preserving historical changes in customer and product data.

## Architecture

<img src="docs/project_architecture.png" alt="project architecture" width="500">


## Key Features

- Built modular SQL transformations using **dbt**
- Used **Snowflake** as the cloud data warehouse
- Created staging models to clean and standardize raw data
- Implemented **SCD Type 2** to preserve historical dimension changes
- Built dimensional models using **fact and dimension tables**
- Used surrogate keys to maintain dimensional relationships
- Added dbt tests to validate data quality and model integrity

## Tech Stack

**Snowflake • dbt • SQL • Jinja • Git**

## Project Structure

```text
models/
├── staging/        # Raw data cleaning and standardization
├── intermediate/   # Business logic and transformations
└── marts/          # Dimension and fact models

macros/             # Reusable dbt/Jinja logic
tests/              # Data quality tests
```

## Running the Project

```bash
dbt deps
dbt run
dbt test
```

## Purpose

This project demonstrates how dbt and Snowflake can be used to build a maintainable analytics pipeline while handling historical dimensional changes using SCD Type 2.