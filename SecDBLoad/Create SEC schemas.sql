CREATE TABLE public.num (
	adsh varchar(20) NOT NULL,
	tag varchar(256) NOT NULL,
	"version" varchar(20) NOT NULL,
	coreg varchar NULL,
	ddate date NOT NULL,
	qtrs numeric NOT NULL,
	uom varchar(20) NOT NULL,
	value numeric NULL,
	footnote varchar(512) NULL
)
WITH (
	OIDS=FALSE
) ;
select * from sub

drop table sub

CREATE TABLE public.sub (
adsh  varchar(20) NOT NULL,
cik  numeric NOT NULL,
name  varchar(150) NOT NULL,
sic  numeric NULL,
countryba  varchar(2) NULL,
stprba  varchar(2) NULL,
cityba  varchar(30) NULL,
zipba  varchar(10) NULL,
bas1  varchar(40) NULL,
bas2  varchar(40) NULL,
baph  varchar(24) NULL,
countryma  varchar(2) NULL,
stprma  varchar(2) NULL,
cityma  varchar(30) NULL,
zipma  varchar(10) NULL,
mas1  varchar(40) NULL,
mas2  varchar(40) NULL,
countryinc  varchar(3) NULL,
stprinc  varchar(2) NULL,
ein  numeric NULL,
former  varchar(150) NULL,
changed  varchar(8) NULL,
afs  varchar(5) NULL,
wksi  bool NOT NULL,
fye  varchar(4) NULL,
form  varchar(10) NOT NULL,
period  date NOT NULL,
fy  varchar(4) NULL,
fp  varchar(2) NULL,
filed  date NOT NULL,
accepted timestamp NOT NULL,
prevrpt  bool NOT NULL,
detail  bool NOT NULL,
instance  varchar(32) NOT NULL,
nciks  numeric NOT NULL,
aciks  varchar(120) NULL
);

COPY sub FROM 'C:\Users\Trevor\Desktop\subnohead.txt' with null as '';

select * from sub

drop table tag

CREATE TABLE public.tag (
tag varchar(256) NOT NULL,
version varchar(20) NOT NULL,
custom bool NOT NULL,
abstract bool NOT NULL,
datatype varchar(20) NULL,
iord varchar(1) NULL,
crdr varchar(1) NULL,
tlabel varchar(512) NULL,
doc varchar(2048) NULL
);

COPY tag FROM 'C:\Users\Trevor\Desktop\tagfixed.txt' with null as '';

select * from tag


drop table pre

CREATE TABLE public.pre (
adsh varchar(20) NOT NULL,
report numeric NOT NULL,
line numeric NOT NULL,
stmt varchar(2) NOT NULL,
inpth bool NOT NULL,
rfile varchar(1) NOT NULL,
tag varchar(256) NOT NULL,
version varchar(20) NOT NULL,
plabel varchar(512) Null,
negating bool NOT NULL
);

TRUNCATE TABLE tag;
select count(*) from tag
COPY tag FROM 'C:\Users\Trevor\Desktop\Fixed\tagnoheadiconv.txt' with null as '';

TRUNCATE table sub;
TRUNCATE TABLE pre;
TRUNCATE TABLE tag;
TRUNCATE TABLE num;
select * from pre;
TRUNCATE TABLE pre;
select count(*) from pre
COPY pre FROM 'C:\Users\Trevor\Desktop\Fixed\prefixed.txt' with null as '';

COPY pre FROM 'C:\Users\Trevor\Desktop\prefixed.txt' with null as '';

COPY num FROM 'C:\Users\Trevor\Desktop\numfixed.txt' with null as '';

TRUNCATE table num;

COPY num FROM 'C:\Users\Trevor\Desktop\secdb\2017q1\numfixed.txt' with null as '';

COPY sub FROM 'C:\Users\Trevor\Desktop\subnohead.txt' with null as '';

select * from num

select * from sub

select count(*) from sub

select * from sub 
where name like '%MICROSOFT%'

CREATE INDEX numidx on num(adsh);
CREATE INDEX preidx on pre(adsh);

analyze num

explain analyze select q.* from (
select * from num
where adsh = '0001564590-17-007547' 
) q where tag = 'CashAndCashEquivalentsAtCarryingValue'

select * from pre
where adsh = '0001564590-17-007547'
and stmt = 'BS' and report = 5
order by line

select * from num

select p.tag, p.plabel,p.line,n.value
from 
(select * from pre where adsh = '0001564590-17-007547'
and stmt = 'BS' and report = 5) as p
left join 
(select * from num where adsh = '0001564590-17-007547' and ddate = '2017-03-31')
as n on p.tag = n.tag
order by p.line

select p.tag, p.plabel,p.line
from 
pre as p
where p.adsh = '0001564590-17-007547'
and p.stmt = 'BS' and p.report = 5
order by p.line
SELECT reltuples AS approximate_row_count FROM pg_class WHERE relname = 'num';
SHOW maintenance_work_mem
select * from tag where tag in (
select tag from pre
where adsh = '0001564590-17-007547'
and stmt = 'BS' and report = 5
order by line)
select count(*) from num;
select count(*) from tag; q1
select count(*) from sub;q2
select count(*) from pre; q1
select count(*) from num; q2