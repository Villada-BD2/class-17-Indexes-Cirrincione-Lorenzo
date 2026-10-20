-- LORENZO CIRRINCIONE BO
use sakila;
-- 1
select *
from address
where postal_code in ('48291', '73905', '12684');

select *
from address
where postal_code not in ('35200', '17886');

select a.address, a.postal_code, c.city, co.country
from address a
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where a.postal_code in ('67428', '19385', '85602');

-- creo indice
create index idx_postal_code on address(postal_code);

-- repito consultas con indice

select *
from address
where postal_code in ('48291', '73905', '12684');

select *
from address
where postal_code not in ('35200', '17886');

select a.address, a.postal_code, c.city, co.country
from address a
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where a.postal_code in ('67428', '19385', '85602');

-- explicacion:
-- agreuge un indice en postal_code para facilitar las
-- busquedas que utilizan esa columna.
-- en las consultas con in, mysql puede buscar directamente
-- los valores indicados. En cambio, con not in se descartan
-- algunos valores y se siguen revisando muchos registros.
-- la diferencia de tiempo puede ser muy pequeña porque
-- address no contiene una cantidad grande de datos.


-- 2

-- busco por nombre
select *
from actor
where first_name = 'ED';

-- busco por apellido
select *
from actor
where last_name = 'NICK';

-- vemos los indices existentes
show index from actor;

-- explicacion:
-- las dos consultas buscan actores, pero no trabajan
-- de la misma forma. Last_name ya tiene un indice creado,
-- por lo que mysql puede usarlo para encontrar coincidencias.
-- First_name no tiene ese indice y normalmente necesita
-- recorrer los registros de la tabla.
-- esto puede generar diferencias en los tiempos de busqueda.


-- 3

-- busqueda utilizando like
select film_id, title, description
from film
where description like '%action%';

-- creamos el indice fulltext
create fulltext index index_description_
on film_text(description);

-- busqueda utilizando match against
select film_id, title, description
from film_text
where match(description) against('action');

-- explicacion:
-- en la primera consulta usamos like para encontrar
-- descripciones que contengan el texto action.
-- en la segunda utilizamos match against, que aprovecha
-- un indice fulltext para buscar palabras dentro del texto.
-- la diferencia es que like busca una coincidencia de
-- caracteres, mientras que fulltext trabaja con palabras
-- y tiene en cuenta su relevancia.
-- por eso no siempre devuelven exactamente los mismos
-- resultados. Ademas, fulltext puede funcionar mejor
-- cuando hay muchos registros.
