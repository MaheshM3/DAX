SELECT 
    JobName,
    Location,
    BusinessDate,
    startedat,
    endedat,
    LatestStatus,
    CASE
        WHEN SUM(CASE WHEN LatestStatus = 'Failed' THEN 1 ELSE 0 END) OVER (PARTITION BY BusinessDate) > 0 THEN 'Failed'
        WHEN SUM(CASE WHEN LatestStatus = 'In Progress' THEN 1 ELSE 0 END) OVER (PARTITION BY BusinessDate) > 0 THEN 'In Progress'
        WHEN SUM(CASE WHEN LatestStatus = 'Complete' THEN 1 ELSE 0 END) OVER (PARTITION BY BusinessDate) = COUNT(*) OVER (PARTITION BY BusinessDate) THEN 'Complete'
        ELSE 'Unknown'
    END AS FinalStatus
FROM 
    JobsTable; -- Replace with your actual table name
