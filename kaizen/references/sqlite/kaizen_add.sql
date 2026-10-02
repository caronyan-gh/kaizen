-- Record the items of one kaizen run; items = JSON array of {step, rank, item, reason, decision?, result?}
-- mode: write
-- param owner: role that ran kaizen (designer / reviewer / implementer ...)
-- param items json: [{step, rank, item, reason, decision?, result?}]; step 1 own friction, 2 problem, 3 database, 4 automation
INSERT INTO kaizen_items(owner, step, rank, item, reason, decision, result)
  SELECT :owner, json_extract(value, '$.step'), json_extract(value, '$.rank'), json_extract(value, '$.item'),
         coalesce(json_extract(value, '$.reason'), ''), coalesce(json_extract(value, '$.decision'), 'open'),
         coalesce(json_extract(value, '$.result'), '')
  FROM json_each(:items);
SELECT count(*) AS items FROM kaizen_items WHERE owner = :owner;
