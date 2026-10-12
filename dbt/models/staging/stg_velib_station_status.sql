with source as (

    select ingested_at, payload
    from {{ source('velib_raw', 'station_status') }}

),

stations as (

    select
        source.ingested_at,
        station
    from source,
        unnest(json_query_array(source.payload, '$.data.stations')) as station

)

select
    ingested_at,
    cast(json_value(station, '$.station_id') as int64)          as station_id,
    cast(json_value(station, '$.num_bikes_available') as int64) as bikes_available,

    -- num_bikes_available_types ressemble à [{"mechanical": 3}, {"ebike": 1}].
    -- On cherche chaque clé dans toute la liste plutôt que de compter sur l'ordre des éléments.
    (
        select sum(cast(json_value(bike_type, '$.mechanical') as int64))
        from unnest(json_query_array(station, '$.num_bikes_available_types')) as bike_type
    ) as mechanical_bikes_available,
    (
        select sum(cast(json_value(bike_type, '$.ebike') as int64))
        from unnest(json_query_array(station, '$.num_bikes_available_types')) as bike_type
    ) as ebikes_available,

    cast(json_value(station, '$.num_docks_available') as int64) as docks_available,
    json_value(station, '$.is_installed') = '1'                 as is_installed,
    json_value(station, '$.is_renting') = '1'                   as is_renting,
    json_value(station, '$.is_returning') = '1'                 as is_returning,
    timestamp_seconds(cast(json_value(station, '$.last_reported') as int64)) as last_reported_at
from stations