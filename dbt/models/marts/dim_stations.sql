-- On garde la dernière version connue de chaque station
select
    station_id,
    station_code,
    station_name,
    latitude,
    longitude,
    capacity,
    ingested_at as last_seen_at
from {{ ref('stg_velib_station_information') }}
qualify row_number() over (partition by station_id order by ingested_at desc) = 1