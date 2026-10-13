-- Par défaut, dbt préfixe le schéma personnalisé par celui du profil (staging_marts).
-- On utilise directement le schéma personnalisé quand il est défini.
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}