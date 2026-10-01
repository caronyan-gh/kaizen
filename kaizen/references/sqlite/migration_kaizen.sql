-- Kaizen skill records: every item a kaizen run reported, its rank, and what the user decided.
-- The next run reads open/declined items first so nothing is rediscovered or re-proposed.
CREATE TABLE kaizen_items (
  item_id    INTEGER PRIMARY KEY,
  owner      TEXT NOT NULL CHECK (length(trim(owner)) > 0),          -- role that ran kaizen (designer / reviewer / ...)
  step       INTEGER NOT NULL CHECK (step IN (1, 2, 3, 4)),           -- 1 own friction, 2 problem, 3 database, 4 automation
  rank       TEXT NOT NULL CHECK (rank IN ('A', 'B', 'C', 'Z')),
  item       TEXT NOT NULL CHECK (length(trim(item)) > 0),
  reason     TEXT NOT NULL DEFAULT '',
  decision   TEXT NOT NULL DEFAULT 'open' CHECK (decision IN ('open', 'approved', 'done', 'declined', 'delegated')),
  result     TEXT NOT NULL DEFAULT '',                               -- what was done, commit, or why declined
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime')),
  updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime'))
);
