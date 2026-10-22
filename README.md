# Travel Agency Database System

A relational database for a multi-branch travel agency, built in MySQL for the *Databases* course at the Department of Computer Engineering & Informatics (CEID), University of Patras (2025).

It models branches and their staff (administrators, drivers and tour guides), multi-stop trips with events, customers and seat reservations. Business rules are enforced inside the database with a stored procedure and a trigger.

## Highlights

- **15 normalised tables** with primary and foreign keys and `ON UPDATE/ON DELETE` rules
- **Specialisation (IS-A):** `admin`, `driver` and `guide` each extend `worker` and share its key
- **Self-referencing hierarchy:** a `destination` can point to a parent destination through `dst_location`
- **Many-to-many relations:** guides ↔ languages, trips ↔ destinations (with arrival, departure and visit order), admins ↔ branches
- **Stored procedure `proc_calculate_branch_stats`:** returns a branch's income (from reservations), expenses (staff salaries) and profit margin
- **Trigger `trg_check_salary_increase`:** blocks a salary raise if the branch is not profitable, and caps any raise at 2%
- **Sample data:** 6 branches, 26 workers, 14 trips, 20 customers and 24 reservations, all fictional

## Schema

| Area | Tables |
|---|---|
| Organisation | `branch`, `phones`, `manages` |
| Staff | `worker`, `admin`, `driver`, `guide`, `languages`, `language_ref` |
| Trips | `trip`, `destination`, `travel_to`, `event` |
| Customers | `customer`, `reservation` |

## Getting started

Requires MySQL 8+ or MariaDB 10.5+. Run the files in this order:

```bash
mysql -u root -p < create.sql                              # creates travel_agency_2025 and all tables
mysql -u root -p < insert.sql                              # loads the sample data
mysql -u root -p travel_agency_2025 < stored_procedure.sql
mysql -u root -p travel_agency_2025 < trigger.sql
```

## Try it

Branch statistics:
```sql
CALL proc_calculate_branch_stats(1, @income, @expenses, @margin);
SELECT @income, @expenses, @margin;
-- 3430.00 | 4800.00 | -0.29
```

The trigger in action. Branch 1 is running at a loss, so a raise is refused:
```sql
UPDATE worker SET wrk_salary = wrk_salary * 1.10 WHERE wrk_AT = 'AT00000001';
-- ERROR 1644 (45000): Error, salary increase denied. the branch is not operating profitably
```
On a profitable branch, a raise above 2% is refused with *"salary increase is denied because it exceeds the 2 percent cap"*.

## Files

| File | Contents |
|---|---|
| `create.sql` | Database and table definitions |
| `insert.sql` | Sample data |
| `stored_procedure.sql` | `proc_calculate_branch_stats` |
| `trigger.sql` | `trg_check_salary_increase` |
