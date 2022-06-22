# postGISSchweiz
>Learning important functions from postGIS and the integration between QGIS and Postgres

**Important:** have QGIS installed in your machine, just like Postgres, I used pgAdmin to write the servers againt Postgres.

- [X] Installation of softwares
- [ ] Upload of Schweiz.gpkg inside of QGIS for Data Visualization
- [ ] Import tables of geodata information to database inside postgres
- [ ] Query away...

**Get through all of the steps above and you should have the data ready in SQL to learn the postgis querying functions**

## Now let's answer some questions about Switzerland and practice the deutsch

**1**. Was ist die Distanz zwischen Bern und Zürich…?
**2**. Schreiben Sie eine Query, die alle Gemeinden selektiert, die an die Gemeinde Rapperswil-Jona angrenzen.
Beachten Sie, dass Sie dazu eine Attribut- und eine räumliche Abfrage kombinieren müssen.
Ausgabe der Gemeinde-Namen.
**3**. Schreiben Sie eine Query, die alle Orte (Namen) im Umkreis von 10 km
um die HSR (Landeskoordinaten (CH1903): 704472/231216) selektiert.
**4**. Schreiben Sie eine Query, die alle Orte (Namen) selektiert,
die in einer Pufferzone von 2 km um den Fluss Emme liegen.
**5**. Schreiben Sie eine Query, die alle Gemeinden selektiert,
durch die der Fluss Emme fliesst.
Ausgabe der Gemeinde-Namen.

##### 1
```
select 
st_distance(
	(select geom from orte where "name" = 'Bern' and "type" = 'Medium City'),
	(select geom from orte where "name" = 'Zürich' and "type" = 'Medium City')
)/1000 
	as distance_in_km
```
  
>**ST_DISTANCE** returns the distance between two geometries, so the arguments have to be casted as geometries and not as WKT.
>Inside were used a couple of sub-queries to select single rows of each geometry. The output is the distance between Bern and Zürich.

---

##### 2
```
select "name"
  from gemeinden g
    where st_touches(g.geom, (select geom from gemeinden where "name" like 'Rappers%ona'))
  order by "name" asc
```
  
>**ST_TOUCHES** returns True if the borders of two areas intersect without their interiors intersecting. We are locating with this
>the neighbouring cities of Rapperswil-Jona.

---

##### 3
```
select name, geom 
from orte
where st_dwithin(geom, ST_GeomFromText('POINT(704472 231216)', 21781),10000)
order by name ASC
```
  
>**ST_DWITHIN** returns the True if distance between two geometries are less or equal a given distance, the third argument.
>We locate with this query the cities closer than 10km to the university HSR.

---

##### 4
```
select distinct name 
from orte
where st_within(
 geom,
 (select st_buffer(geom, 2000) FROM fluesse WHERE name = 'Emme')
)
order by name ASC

```
  
>**ST_BUFFER** returns all points as a polygon within a distance from a geometry.
>**ST_WITHIN** returns True if the geometry is inside another.

---

##### 5
```
select g.name 
from gemeinden g
where ST_Intersects(geom, (SELECT geom FROM fluesse WHERE name = 'Emme'))
order by 1
```
  
>**ST_INTERSECTS** returns True if geometries have at least one point in common.
>Sub-query to select geometry from Emme river.


  
