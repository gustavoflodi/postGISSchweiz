--- 1
select 
st_distance(
	(select geom from orte where "name" = 'Bern' and "type" = 'Medium City'),
	(select geom from orte where "name" = 'Zürich' and "type" = 'Medium City')
)/1000 
	as distance_in_km

---

--- 2

select "name"
  from gemeinden g
    where st_touches(g.geom, (select geom from gemeinden where "name" like 'Rappers%ona'))
  order by "name" asc

---

--- 3

select name, geom 
from orte
where st_dwithin(geom, ST_GeomFromText('POINT(704472 231216)', 21781),10000)
order by name ASC

---

--- 4

select distinct name 
from orte
where st_within(
 geom,
 (select st_buffer(geom, 2000) FROM fluesse WHERE name = 'Emme')
)
order by name ASC

---

--- 5

select g.name 
from gemeinden g
where ST_Intersects(geom, (SELECT geom FROM fluesse WHERE name = 'Emme'))
order by 1

---
