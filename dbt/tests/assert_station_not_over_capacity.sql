{{ config(severity='warn') }}

-- Vélos et bornes libres ne devraient pas dépasser la capacité de la station.
-- En warn : Vélib permet de garer des vélos en surnombre dans certaines stations,
-- donc un dépassement n'est pas forcément une erreur de données.
select
    status.ingested_at,
    status.station_id,
    status.bikes_available,
    status.docks_available,
    info.capacity
from {{ ref('stg_velib_station_status') }} as status
inner join {{ ref('stg_velib_station_information') }} as info
    on status.station_id = info.station_id
    and status.ingested_at = info.ingested_at
where status.bikes_available + status.docks_available > info.capacity