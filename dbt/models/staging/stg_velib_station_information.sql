with source as (

    select ingested_at, payload
    from {{ source('velib_raw', 'station_information') }}

),

-- Une ligne par appel API devient une ligne par station
stations as (

    select
        source.ingested_at,
        station
    from source,
        unnest(json_query_array(source.payload, '$.data.stations')) as station

)

select
    ingested_at,
    cast(json_value(station, '$.station_id') as int64) as station_id,
    json_value(station, '$.stationCode')               as station_code,
    json_value(station, '$.name')                      as station_name,
    cast(json_value(station, '$.lat') as float64)      as latitude,
    cast(json_value(station, '$.lon') as float64)      as longitude,
    cast(json_value(station, '$.capacity') as int64)   as capacity
from stations