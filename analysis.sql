WITH paired AS (
    SELECT a.economy, a.iso, a.value AS baseline, b.value AS comparison
    FROM observations AS a
    JOIN observations AS b ON b.iso = a.iso AND b.indicator = a.indicator AND b.year = 2023
    WHERE a.indicator = 'SP.DYN.LE00.IN' AND a.year = 2019
      AND a.value IS NOT NULL AND b.value IS NOT NULL
      AND EXISTS (
          SELECT 1 FROM observations AS dip
          WHERE dip.iso = a.iso AND dip.indicator = a.indicator
            AND dip.year BETWEEN 2020 AND 2022 AND dip.value < a.value
      )
)
SELECT economy, iso, baseline, comparison, comparison - baseline AS metric
FROM paired ORDER BY metric DESC, iso;
