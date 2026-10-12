-- Les vélos mécaniques et électriques doivent former le total des vélos disponibles
select
    ingested_at,
    station_id,
    bikes_available,
    mechanical_bikes_available,
    ebikes_available
from {{ ref('stg_velib_station_status') }}
where coalesce(mechanical_bikes_available, 0) + coalesce(ebikes_available, 0) != bikes_available