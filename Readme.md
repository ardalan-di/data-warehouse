# DB2 Project: Data Warehouse Automation

This repository contains the course project for building and automating a multi-layer data warehouse around a **flight reservation and loyalty** domain.  All database objects are created and loaded using SQL Server scripts with Python orchestration.

## Overview
- **Source System** – OLTP style tables under the `Source` schema
- **Staging Area** – ETL/ELT integration scripts
- **Data Warehouse** – Star schema with dimensions and facts
- **Automation** – Python utilities to run and monitor the full pipeline

The solution can create the entire environment from scratch, populate sample data, load the warehouse and optionally clean everything again.  SSIS packages and design documents are included for reference.

## Repository Layout
```
.
├── DB2_Project_SSIS/    # SSIS solution files
├── Datawarehouse/       # Warehouse DDL and ETL scripts
│   ├── Dimensions/
│   └── Facts/
├── Diagrams/            # Data model diagrams
├── ETL Document/        # Project documentation
├── Files/               # Auxiliary files (e.g. CSVs)
├── Scripts/             # Python automation scripts
│   ├── main.py          # Interactive menu to run or clean the project
│   ├── makeDB.py        # Executes SQL and Python loaders
│   ├── populate_source.py
│   ├── config.json      # Defines the execution order of scripts
│   └── requirements.txt
├── Source/              # DDL for OLTP source schema
├── Staging Area/        # Staging schema ETL scripts
└── Test Scripts/        # Sample tests for SCD2 logic
```

## Prerequisites
- Python 3.8+
- Microsoft SQL Server with **ODBC Driver 18** installed
- `pyodbc`, `Faker` and `tqdm` Python packages (`pip install -r Scripts/requirements.txt`)
- Update connection details in `Scripts/makeDB.py` if your SQL Server instance differs from the defaults

## Getting Started
1. Install the Python dependencies:
   ```bash
   pip install -r Scripts/requirements.txt
   ```
2. Launch the interactive menu:
   ```bash
   python Scripts/main.py
   ```
3. Use the menu to build the source, staging and warehouse layers or to clean the database.  All steps executed are defined in `Scripts/config.json`.

Execution logs are written to `Scripts/makeDB.log` for troubleshooting.

## Sample Data
The script `Scripts/populate_source.py` can generate mock data for the source tables using the Faker library.  Run it manually or through the automation menu to load a dataset for testing the warehouse pipeline.

## Diagrams and Documentation
Detailed schema diagrams are available under `Diagrams/`.  An ETL description document is provided in `ETL Document/` for additional context on the design choices and load processes.

## License
This project is provided for educational purposes and does not include any production credentials.
