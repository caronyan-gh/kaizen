-- Kaizen step 0: every owner's items, newest first; open / approved / delegated always, done and declined from the last 30 days
-- mode: read
SELECT item_id, owner, step, rank, decision, item, reason, result, updated_at
FROM kaizen_items
WHERE decision IN ('open', 'approved', 'delegated')
   OR updated_at >= strftime('%Y-%m-%dT%H:%M:%S', 'now', 'localtime', '-30 days')
ORDER BY updated_at DESC, item_id DESC;
