-- Update one kaizen item's decision (open / approved / done / declined / delegated), result, and rank (result / rank null = keep)
-- mode: write
UPDATE kaizen_items SET decision = :decision, result = coalesce(:result, result), rank = coalesce(:rank, rank),
       updated_at = strftime('%Y-%m-%dT%H:%M:%S','now','localtime')
WHERE item_id = :item_id
RETURNING item_id, decision, rank, result;
