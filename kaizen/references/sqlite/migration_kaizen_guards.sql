-- Kaizen guards: enforce two recording rules the instructions alone did not keep (in real use, 8 Z items ended up
-- "done" and 3 items were declined with no reason). Applies to new writes only; existing rows are left as they are.
-- Copy into db/migrations/ with the next free number; works on new and existing kaizen_items tables (no rebuild).
CREATE TRIGGER IF NOT EXISTS kaizen_items_guard_insert BEFORE INSERT ON kaizen_items
BEGIN
  SELECT RAISE(ABORT, 'kaizen: a rank Z item means "do not do it"; record it as declined with the reason, not done')
  WHERE NEW.rank = 'Z' AND NEW.decision = 'done';
  SELECT RAISE(ABORT, 'kaizen: a declined item needs a one-line reason in result')
  WHERE NEW.decision = 'declined' AND trim(NEW.result) = '';
END;
CREATE TRIGGER IF NOT EXISTS kaizen_items_guard_update BEFORE UPDATE ON kaizen_items
BEGIN
  SELECT RAISE(ABORT, 'kaizen: a rank Z item means "do not do it"; record it as declined with the reason, not done')
  WHERE NEW.rank = 'Z' AND NEW.decision = 'done';
  SELECT RAISE(ABORT, 'kaizen: a declined item needs a one-line reason in result')
  WHERE NEW.decision = 'declined' AND trim(NEW.result) = '';
END;
