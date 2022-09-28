use houseutiltyprovider
Go
EXEC spInsertworkareas 1,'Plumbing'
GO 
EXEC spInsertworkareas 2,'Pipe fitting'
GO
EXEC spInsertworkareas 3,'Electrical work'
Go
EXEC spInsertworkareas 4,'insect control'
GO
EXEC spInsertworkareas 5,'General labor'
GO
SELECT * FROM workareas
GO
--- table 2 ---
EXEC spInsertworkers 101,'MD.Mahidol','01620151533',900.00
GO 
EXEC spInsertworkers 102,'Raisul islam','01829415557',850.00
GO
EXEC spInsertworkers 103,'Sakib khan','01811695986',700.00
GO
EXEC spInsertworkers 104,'MD.Abdullah','01687032087',650.00
GO
EXEC spInsertworkers 105,'Tuhin sarker','01742405277',950.00
GO
EXEC spInsertworkers 106,'Sifat hasan','01708355205',700.00
GO
EXEC spInsertworkers 107,'MD.Akash','01571282593',600.00
GO
Select* from workers

---- table 03----
EXEC spInsertworkerareas 101,1
GO 
EXEC spInsertworkerareas 101,2
GO 
EXEC spInsertworkerareas 102,3
GO 
EXEC spInsertworkerareas 103,4
GO 
EXEC spInsertworkerareas 103,5
GO 
EXEC spInsertworkerareas 104,4
GO 
EXEC spInsertworkerareas 105,3
GO 
EXEC spInsertworkerareas 106,2
GO 
EXEC spInsertworkerareas 107,1
GO 
EXEC spInsertworkerareas 105,5
GO 
Select* from workerareas

--- table 04--- 

EXEC spInsertworks 501,'MD.Jony','12, Gulshan-1',1,
'Swage pipe replacement ','2020-01-01','2020-8-04'
GO 
EXEC spInsertworks 502,'MD.Jowel','15, Bonani-3',2,
'Garage electric wiring ','2020-01-06','2020-5-04'
GO 
EXEC spInsertworks 503,'MD.shajib','44,Dhanmondi-1',3,
'House cleaning ','2020-02-05','2020-9-04'
GO 
EXEC spInsertworks 504,'MD.Faruk','33,Rajarbag-4',4,
'Garden water line replace ','2020-03-01','2020-7-04'
GO 
EXEC spInsertworks 505,'MD.shahin','15, Arambag-4',5,
'New Electic line','2020-04-01','2020-06-04'
GO 
EXEC spInsertworks 506,'MD.Jamir','15, Arambag-5',5,
'Electrical Repair','2020-04-01',NULL
GO 
select* from works
Go
select* from workerDetails
-------- table 05 -
DECLARE @h1 INT , @h2 INT
SET @h1 =DATEDIFF (hour, '2020-01-01','2020-08-04')
SET @h2 = DATEDIFF (HOUR, '2020-01-01','2020-08-04')*900
EXEC spInsertworkerpayments  501, 101,@h1 ,@h2
EXEC spInsertworkerpayments  502, 102,@h1 ,@h2
EXEC spInsertworkerpayments  503, 102,@h1 ,@h2
EXEC spInsertworkerpayments  504, 103,@h1 ,@h2
EXEC spInsertworkerpayments  505, 104,@h1 ,@h2
GO 
SELECT * from vdetails
go
select * from workerDetails
go
select * from worksDetails
go
select * from fnWorkerList(1)
go
/*
 ***********************************************************************
 * --Queries added
 ***********************************************************************
 **/
--1 Join Inner 
-------------------------------------------------------------------------
SELECT        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
FROM            workareas woa
INNER JOIN
                         workerareas wa ON woa.workareaid = wa.areaid 
INNER JOIN
                         workerpayments wp ON wa.workerid = wp.workerid 
INNER JOIN
                         workers wo ON wa.workerid = wo.workerid AND wp.workerid = wo.workerid 
INNER JOIN
                         works w ON wa.areaid = w.workareaid AND wp.workid = w.workid
GO
--2 Specific work
-----------------------------------------------
SELECT        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
FROM            workareas woa
INNER JOIN
                         workerareas wa ON woa.workareaid = wa.areaid 
INNER JOIN
                         workerpayments wp ON wa.workerid = wp.workerid 
INNER JOIN
                         workers wo ON wa.workerid = wo.workerid AND wp.workerid = wo.workerid 
INNER JOIN
                         works w ON wa.areaid = w.workareaid AND wp.workid = w.workid
WHERE woa.skill = 'Plumbing'
-- 3 specific worker
--------------------------------------------------------------------
SELECT        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
FROM            workareas woa
INNER JOIN
                         workerareas wa ON woa.workareaid = wa.areaid 
INNER JOIN
                         workerpayments wp ON wa.workerid = wp.workerid 
INNER JOIN
                         workers wo ON wa.workerid = wo.workerid AND wp.workerid = wo.workerid 
INNER JOIN
                         works w ON wa.areaid = w.workareaid AND wp.workid = w.workid
WHERE wo.workername = 'MD.Mahidol'
GO
--4 outer 
-----------------------------------------------------------------------------------------------------------
SELECT        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
FROM            workers wo
INNER JOIN
                         workerareas woa ON wo.workerid = woa.workerid 
INNER JOIN
                         workareas wa ON woa.areaid = wa.workareaid 
LEFT OUTER JOIN
                         workerpayments wp ON wo.workerid = wp.workerid 
LEFT OUTER JOIN
                         works w ON wp.workid = w.workid AND wa.workareaid = w.workareaid
--5 same with CTE
------------------------------------
WITH cte AS
(

SELECT        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, woa.areaid, wa.workareaid
                       
FROM            workers wo
INNER JOIN
                         workerareas woa ON wo.workerid = woa.workerid 
INNER JOIN
                         workareas wa ON woa.areaid = wa.workareaid 
)
SELECT cte.workername, cte.phone, cte.payrate, cte.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
FROM cte 
LEFT OUTER JOIN
                         workerpayments wp ON cte.workerid = wp.workerid 
LEFT OUTER JOIN
                         works w ON wp.workid = w.workid AND cte.workareaid = w.workareaid
--6 not matched for left join
-----------------------------------------------------------------------------------------------------------
SELECT        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
FROM            workers wo
INNER JOIN
                         workerareas woa ON wo.workerid = woa.workerid 
INNER JOIN
                         workareas wa ON woa.areaid = wa.workareaid 
LEFT OUTER JOIN
                         workerpayments wp ON wo.workerid = wp.workerid 
LEFT OUTER JOIN
                         works w ON wp.workid = w.workid AND wa.workareaid = w.workareaid
WHERE w.customename IS NULL AND wp.workid IS NULL
GO
--7 same with subquery
-----------------------------------------------------------------------------------------------------------
SELECT        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
FROM            workers wo
INNER JOIN
                         workerareas woa ON wo.workerid = woa.workerid 
INNER JOIN
                         workareas wa ON woa.areaid = wa.workareaid 
LEFT OUTER JOIN
                         workerpayments wp ON wo.workerid = wp.workerid 
LEFT OUTER JOIN
                         works w ON wp.workid = w.workid AND wa.workareaid = w.workareaid
WHERE wo.workerid NOT IN (SELECT workerid FROM workerpayments)
--8 aggregate
-----------------------------------------------------------------------------------------------------------
SELECT        wo.workername, SUM(wp.totalworkhour) 'totalhour', SUM(wp.totalpayment) 'totalpayment'
FROM            workareas woa
INNER JOIN
                         workerareas wa ON woa.workareaid = wa.areaid 
INNER JOIN
                         workerpayments wp ON wa.workerid = wp.workerid 
INNER JOIN
                         workers wo ON wa.workerid = wo.workerid AND wp.workerid = wo.workerid 
INNER JOIN
                         works w ON wa.areaid = w.workareaid AND wp.workid = w.workid
GROUP BY wo.workername
--9 aggregate and having
------------------------------------------------------------------------------
SELECT        wo.workername, SUM(wp.totalworkhour) 'totalhour', SUM(wp.totalpayment) 'totalpayment'
FROM            workareas woa
INNER JOIN
                         workerareas wa ON woa.workareaid = wa.areaid 
INNER JOIN
                         workerpayments wp ON wa.workerid = wp.workerid 
INNER JOIN
                         workers wo ON wa.workerid = wo.workerid AND wp.workerid = wo.workerid 
INNER JOIN
                         works w ON wa.areaid = w.workareaid AND wp.workid = w.workid
GROUP BY wo.workername
HAVING wo.workername='Sakib khan'
GO
--10 windowing
---------------------------------------------------------------------------------------------
SELECT        wo.workername, 
SUM(wp.totalworkhour) OVER(ORDER BY wo.workerid) 'totalhour', 
SUM(wp.totalpayment) OVER(ORDER BY wo.workerid) 'totalpayment',
ROW_NUMBER()  OVER(ORDER BY wo.workerid) 'rownum',
RANK()  OVER(ORDER BY wo.workerid) 'rank',
DENSE_RANK()  OVER(ORDER BY wo.workerid) 'denserank',
NTILE(2)  OVER(ORDER BY wo.workerid) 'ntile (2)'
FROM            workareas woa
INNER JOIN
                         workerareas wa ON woa.workareaid = wa.areaid 
INNER JOIN
                         workerpayments wp ON wa.workerid = wp.workerid 
INNER JOIN
                         workers wo ON wa.workerid = wo.workerid AND wp.workerid = wo.workerid 
INNER JOIN
                         works w ON wa.areaid = w.workareaid AND wp.workid = w.workid
GO
--11 -select case
--------------------------------------------------------------------
SELECT customename, customeraddress, workdescription, startdate,
CASE
	WHEN endtime IS NULL THEN 'running'
	ELSE CAST(endtime AS VARCHAR)
END endtime
FROM works