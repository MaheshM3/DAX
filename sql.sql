WITH JobStatuses AS (
    SELECT
        BusinessDate,
        LISTAGG(JobName || ' (' || NVL(Location, 'No Location') || ') - ' || NVL(LatestStatus, 'No status'), ', ') 
            WITHIN GROUP (ORDER BY JobName) AS DetailedJobStatuses
    FROM 
        JobsTable
    GROUP BY 
        BusinessDate
)

SELECT 
    j.JobName,
    j.Location,
    j.BusinessDate,
    j.startedat,
    j.endedat,
    j.LatestStatus,
    -- FinalStatus Calculation
    CASE
        WHEN SUM(CASE WHEN j.LatestStatus = 'Failed' THEN 1 ELSE 0 END) OVER (PARTITION BY j.BusinessDate) > 0 THEN 'Failed'
        WHEN SUM(CASE WHEN j.LatestStatus = 'In Progress' THEN 1 ELSE 0 END) OVER (PARTITION BY j.BusinessDate) > 0 THEN 'In Progress'
        WHEN SUM(CASE WHEN j.LatestStatus = 'Complete' THEN 1 ELSE 0 END) OVER (PARTITION BY j.BusinessDate) = COUNT(*) OVER (PARTITION BY j.BusinessDate) THEN 'Complete'
        ELSE 'Unknown'
    END AS FinalStatus,
    -- Detailed StatusMessage
    NVL(s.DetailedJobStatuses, 'No jobs found for this date.') AS StatusMessage
FROM 
    JobsTable j
LEFT JOIN 
    JobStatuses s ON j.BusinessDate = s.BusinessDate;
