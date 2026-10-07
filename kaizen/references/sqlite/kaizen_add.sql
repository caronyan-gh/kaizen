-- Record the items of one kaizen run; all or nothing: if one item breaks a rule, the whole report is rolled back
-- mode: write
-- param owner: role that ran kaizen (designer / reviewer / implementer ...)
-- param items json: [{step, rank, item, reason, decision?, result?}]; step 1 own friction, 2 problem, 3 database, 4 automation; decision defaults to open; rank Z is always stored as declined, with result = reason when result is empty
INSERT INTO kaizen_items(owner, step, rank, item, reason, decision, result)
  SELECT :owner, json_extract(value, '$.step'), json_extract(value, '$.rank'), json_extract(value, '$.item'),
         coalesce(json_extract(value, '$.reason'), ''),
         CASE WHEN json_extract(value, '$.rank') = 'Z' THEN 'declined'
              ELSE coalesce(json_extract(value, '$.decision'), 'open') END,
         CASE WHEN json_extract(value, '$.rank') = 'Z' AND coalesce(json_extract(value, '$.result'), '') = ''
              THEN coalesce(json_extract(value, '$.reason'), '')
              ELSE coalesce(json_extract(value, '$.result'), '') END
  FROM json_each(:items);
SELECT count(*) AS items FROM kaizen_items WHERE owner = :owner;
