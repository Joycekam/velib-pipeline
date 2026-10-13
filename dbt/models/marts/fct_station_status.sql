{{
    config(
        partition_by={'field': 'ingested_at', 'data_type': 'timestamp', 'granularity': 'day'},
        cluster_by=['station_id']
    )
}}

select
    ingested_at,
    station_id,
    bikes_available,
    mechanical_bikes_available,
    ebikes_available,
    docks_available,

    -- Basé sur les bornes réellement utilisables plutôt que sur la capacité théorique,
    -- qui peut être dépassée (voir le test assert_station_not_over_capacity)
    safe_divide(bikes_available, bikes_available + docks_available) as occupancy_rate,

    bikes_available = 0 as is_empty,
    docks_available = 0 as is_full,
    is_installed,
    is_renting,
    is_returning,
    last_reported_at
from {{ ref('stg_velib_station_status') }}