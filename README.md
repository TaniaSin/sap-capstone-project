# Sap-Capstone-Project

# ZHR_EMPLOYEE_ALV_REPORT
## Custom SAP ALV Report — Employee Master Data

SAP ABAP Capstone Project | April 2026**

---

## Overview

This project implements a **Custom ALV (ABAP List Viewer) Report** in SAP using the `REUSE_ALV_GRID_DISPLAY` function module. The report fetches and displays **Employee Master Data** from the SAP HCM (Human Capital Management) module, specifically from table `PA0001` (HR Master Record: Infotype 0001 – Organizational Assignment).

---

## Problem Statement

HR managers and payroll administrators in large organizations frequently need to view and analyze employee master data across multiple personnel areas, cost centers, and departments. Standard SAP reports often lack the flexibility required for custom filtering, sorting, and export. This custom ALV report solves that by providing dynamic filters, an interactive grid, and export capabilities — all in one program.

---

## Features

- **Selection Screen** — Filter by Employee ID, Plant, Cost Center, and Date Range
- **Active Employee Toggle** — Checkbox to show only currently active employees
- **ALV Field Catalog** — 10 fields with labels, output lengths, and key flags
- **ALV Layout** — Zebra striping, auto column widths, detail popup
- **Default Sorting** — By Personnel Area, then Employee Name
- **Top-of-Page Header** — Report title, date, user ID, and total record count
- **Double-Click Drill-Down** — Shows employee detail in a popup
- **Variant Save/Load** — Save and reload display layouts per user
- **Excel/PDF Export** — Via native ALV toolbar
- **Performance Guard** — Max records limit via parameter

---

## Tech Stack

| Component | Details |
|-----------|---------|
| Language | ABAP (Advanced Business Application Programming) |
| SAP Module | HCM — Human Capital Management |
| Data Source | PA0001 — HR Infotype 0001 |
| ALV Function | REUSE_ALV_GRID_DISPLAY |
| Type Library | SLIS |
| IDE | SAP GUI + Transaction SE38 |
| Transport | SE10 / STMS |

---

## Project Structure

```
ZHR_EMPLOYEE_ALV_REPORT/
├── abap_code/
│   └── ZHR_EMPLOYEE_ALV_REPORT.abap   ← Main ABAP program
├── KIIT_SAP_Capstone_Report.pdf        ← PDF version of report
└── README.md                           ← This file
```

---

## How to Run in SAP

1. Open transaction **SE38** in SAP GUI
2. Enter program name: `ZHR_EMPLOYEE_ALV_REPORT`
3. Click **Create** → select type **Executable Program**
4. Paste the code from `abap_code/ZHR_EMPLOYEE_ALV_REPORT.abap`
5. Press **Ctrl+F3** to activate
6. Press **F8** to execute
7. Enter selection criteria and click **Execute**

---

## Program Flow

```
START
  └── Selection Screen (filters input)
        └── FETCH_EMPLOYEE_DATA (SELECT from PA0001)
              └── BUILD_FIELD_CATALOG (define columns)
                    └── SET_LAYOUT (zebra, auto-width)
                          └── SET_SORT (by WERKS, ENAME)
                                └── DISPLAY_ALV_REPORT
                                      ├── TOP_OF_PAGE (header)
                                      └── USER_COMMAND (double-click)
END
```


*KIIT University — SAP ABAP Training Program — Capstone Project 2026*
