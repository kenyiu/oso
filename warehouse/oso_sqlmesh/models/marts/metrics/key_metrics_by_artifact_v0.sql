MODEL (
  name oso.key_metrics_by_artifact_v0,
  kind FULL,
  partitioned_by bucket(artifact_id, 256),
  tags (
    'export',
    'model_type=full',
    'model_category=metrics',
    'model_stage=mart',
    'index={"idx_artifact_id": ["artifact_id"]}',
    'order_by=["artifact_id"]'
  ),
  audits (
    has_at_least_n_rows(threshold := 0)
  ),
  description 'Each row represents a specific metric value for an artifact at a recent date, capturing the metric type, the associated artifact, the measured amount, and its unit. This data can be used to analyze trends and performance indicators across different artifacts for business insights such as growth, engagement, or risk. Business questions that can be answered include: Which artifacts currently have the most activity? How many contributors are currently involved in the artifact?',
  column_descriptions (
    metric_id = 'The unique identifier for the metric, generated by OSO.',
    artifact_id = 'The unique identifier for the artifact, as generated by OSO.',
    sample_date = 'The date when the metric was sampled, truncated to the day. This is typically a recent date.',
    amount = 'The value of the metric for the artifact on the sample date.',
    unit = 'The unit of measurement for the metric, if applicable.'
  ),
  physical_properties (
    parquet_bloom_filter_columns = ['artifact_id'],
    sorted_by = ['artifact_id']
  )
);

WITH key_metrics_by_artifact_v0_no_casting AS (
  SELECT
    @oso_id('OSO', 'oso', metric) AS metric_id,
    to_artifact_id AS artifact_id,
    metrics_sample_date AS sample_date,
    amount,
    metric,
    NULL AS unit
  FROM oso.key_metrics_to_artifact
)
SELECT
  metric_id::TEXT,
  artifact_id::TEXT,
  sample_date::DATE,
  amount::DOUBLE,
  unit::TEXT
FROM key_metrics_by_artifact_v0_no_casting