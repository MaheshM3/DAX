WITH JobStatuses AS (
    SELECT
        BusinessDate,
        LISTAGG(
            CASE 
                WHEN j.JobName = 'job1' AND j.LatestStatus = 'Failed' THEN 
                    'job1 (No Location) - Failed, '
                ELSE
                    j.JobName || ' (' || NVL(j.Location, 'No Location') || ') - ' || 
                    CASE 
                        WHEN EXISTS (SELECT 1 FROM JobsTable WHERE JobName = 'job1' AND LatestStatus = 'Failed') THEN
                            CASE 
                                WHEN j.LatestStatus != 'Failed' THEN 'Not Started due to dependency'
                                ELSE 'Failed'
                            END
                        ELSE 
                            NVL(j.LatestStatus, 'No status')
                    END
            END, ', ') 
            WITHIN GROUP (ORDER BY j.JobName) AS DetailedJobStatuses
    FROM 
        JobsTable j
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
    j.FailedCount,
    -- FinalStatus Calculation considering FailedCount
    CASE
        WHEN SUM(j.FailedCount) OVER (PARTITION BY j.BusinessDate) > 0 THEN 'Failed'
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
