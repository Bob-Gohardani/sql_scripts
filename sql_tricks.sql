---- First ----

select * from emp;
-- explicit naming of rows is better than using *, as its more readable
select empno, ename, job, sal, mgr, hiredate, comm, deptno from emp;

select * 
from emp
where deptno = 10
    or comm is not null -- any employee who earns a commission
    or (sal <= 2000 and deptno=20); -- these two conditions are Together

-- aliasing
select sal as salary, comm as commission 
from emp;

-- this is needed because where clasue is executed before select
select *
from (
    select sal as salary, comm as commission from emp
) x   -- inline view aliased as x
where salary < 5000;

select ename||' works as a '||job as msg
from emp
where deptno=10   -- CLARK works as a MANAGER


select ename, sal,
       case when sal <= 2000 then 'underpaid'
            when sal >= 4000 then 'overpaid'
            else 'ok'
       end as status  -- name of new column alias is status
from emp;

select * from emp limit 5;

-- random set of records


select ename, job from emp order by random() limit 5;

select * from emp where comm is null;

select coalesce(comm, 0) from emp; -- replaces null with 0

select ename, job from emp
where deptno in (10, 20)
and (ename like '%I%' or job like '%ER');


---- Second ----

select name, job, sal
from emp where deptno = 10
order by sal asc;  -- asc is the oder by default

select ename, job, sal
from emp
where deptno = 10
order by 3 desc;  -- 3 is the third column in select statement

select empno, deptno, sal, ename, job
from emp
order by deptno, sal desc;  -- deptno will order asc, since it was not mentioned

select ename, job from emp
order by substr(job,length(job)-1)  -- sort by last two characters of job

create view V as
select ename||' '||deptno as data from emp;
select * from V;

-- order by deptno (numerical)
select data from V order by
replace(data, 
        replace(
                translate(data, '0123456789', '##########'), '#', ''), '');

-- order by ename (character)
select data from V order by
replace(translate(data, '0123456789', '##########'), '#', '')

-- null values are smaller than 0 so they will be last here (no sorting for them)
select ename, sal, comm, from emp order by 3;

-- non null comm sorted asc, all nulls last
select ename, sal, comm 
from (
    select ename, sal, comm,
    case when comm is null then 0 else 1 end as is_null from emp
) x
order by is_null desc, comm

