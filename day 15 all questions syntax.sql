-- 1.-- Join patients, staff, and staff_schedule to show patient service and staff availability.
use hospital;
SELECT
    p.patient_id,
    p.name AS patient_name,
    p.service,
    p.arrival_date,
    p.departure_date,
    s.staff_id,
    s.staff_name,
    s.role,
    ss.week,
    ss.present AS staff_present 
FROM
    patients p
JOIN
    staff_schedule ss ON p.service = ss.service
JOIN
    staff s ON ss.staff_id = s.staff_id
ORDER BY
    p.patient_id,
    ss.week,
    s.role;
    
    
   -- 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
   SELECT
    sw.week,
    sw.month,
    sw.service,
    sw.available_beds,
    sw.patients_admitted,
    sw.patient_satisfaction,
    sw.staff_morale,
    sw.event,
    ss.staff_id,
    s.staff_name,
    s.role,
    ss.present AS staff_present 
FROM
    services_weekly sw
JOIN
    staff_schedule ss ON sw.service = ss.service
                     AND sw.week = ss.week
JOIN
    staff s ON ss.staff_id = s.staff_id
ORDER BY
    sw.week,
    sw.service,
    s.role;
    
    
    -- 3.Create a multi-table report showing patient admissions with staff information.
    SELECT
    p.patient_id,
    p.name AS patient_name,
    p.arrival_date,
    p.departure_date,
    p.service AS service_admitted,
    p.satisfaction,
    s.staff_id,
    s.staff_name,
    s.role
FROM
    patients p
JOIN
    staff s ON p.service = s.service
ORDER BY
    p.arrival_date DESC, 
    p.patient_id,
    s.role;
    -- ### Daily Challenge:

-- **Question:** Create a comprehensive service analysis report for week 20 showing: 
-- service name, total patients admitted that week, total patients refused, average
-- patient satisfaction, count of staff assigned to service, and count of staff present
--  that week. Order by patients admitted descending.
WITH StaffCounts AS (
    SELECT
        service,
        COUNT(DISTINCT staff_id) AS total_staff_assigned, 
        SUM(present) AS staff_present_count          
    FROM
        staff_schedule
    WHERE
        week = 20
    GROUP BY
        service
)

SELECT
    sw.service,
    sw.patients_admitted,
    sw.patients_refused,
    sw.patient_satisfaction AS average_patient_satisfaction,
    sc.total_staff_assigned,
    sc.staff_present_count
FROM
    services_weekly sw
INNER JOIN
    StaffCounts sc ON sw.service = sc.service
WHERE
    sw.week = 20
ORDER BY
    sw.patients_admitted DESC;