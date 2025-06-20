/*
  # Enhanced Trade Data Fields and Chat Messages

  1. New Columns for trades table (NULLABLE for backward compatibility)
    - `symbol` (text) - Trading symbol/pair
    - `volume_lot` (numeric) - Volume in lots
    - `open_price` (numeric) - Entry price
    - `close_price` (numeric) - Exit price
    - `tp` (numeric) - Take profit level
    - `sl` (numeric) - Stop loss level
    - `position` (text) - Open/Closed status
    - `open_time` (timestamptz) - Position open time
    - `close_time` (timestamptz) - Position close time
    - `reason` (text) - Close reason (TP/SL/Early Close/Other)

  2. New Tables
    - `chat_messages` - AI chat history storage

  3. Security
    - Enable RLS on new table
    - Add policies for authenticated users
*/

-- Add new columns to existing trades table (NULLABLE for backward compatibility)
DO $$
BEGIN
  -- Add symbol column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'symbol'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN symbol text NULL;
  END IF;

  -- Add volume_lot column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'volume_lot'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN volume_lot numeric NULL;
  END IF;

  -- Add open_price column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'open_price'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN open_price numeric NULL;
  END IF;

  -- Add close_price column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'close_price'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN close_price numeric NULL;
  END IF;

  -- Add tp column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'tp'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN tp numeric NULL;
  END IF;

  -- Add sl column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'sl'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN sl numeric NULL;
  END IF;

  -- Add position column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'position'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN position text NULL;
  END IF;

  -- Add open_time column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'open_time'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN open_time timestamp with time zone NULL;
  END IF;

  -- Add close_time column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'close_time'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN close_time timestamp with time zone NULL;
  END IF;

  -- Add reason column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'trades' AND column_name = 'reason'
  ) THEN
    ALTER TABLE public.trades ADD COLUMN reason text NULL;
  END IF;
END $$;

-- Create chat_messages table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id serial PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message text NOT NULL,
  response text,
  message_type text NOT NULL CHECK (message_type IN ('user', 'ai')),
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS on chat_messages
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- Create policies for chat_messages
CREATE POLICY "Users can read own chat messages"
  ON public.chat_messages
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own chat messages"
  ON public.chat_messages
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own chat messages"
  ON public.chat_messages
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own chat messages"
  ON public.chat_messages
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS chat_messages_user_id_idx ON public.chat_messages(user_id);
CREATE INDEX IF NOT EXISTS chat_messages_created_at_idx ON public.chat_messages(created_at);
CREATE INDEX IF NOT EXISTS trades_symbol_idx ON public.trades(symbol);
CREATE INDEX IF NOT EXISTS trades_position_idx ON public.trades(position);
CREATE INDEX IF NOT EXISTS trades_open_time_idx ON public.trades(open_time);
CREATE INDEX IF NOT EXISTS trades_close_time_idx ON public.trades(close_time);