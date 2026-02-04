-- ================================================================
-- Migration: Create stored_reports table
-- Purpose: Store frozen report data at purchase time
-- ================================================================

-- Create stored_reports table
CREATE TABLE IF NOT EXISTS public.stored_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  payment_id UUID REFERENCES payments(id) ON DELETE SET NULL,
  service_type TEXT NOT NULL,
  service_label TEXT NOT NULL,
  report_data JSONB NOT NULL DEFAULT '{}'::jsonb,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_stored_reports_user_id ON public.stored_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_stored_reports_payment_id ON public.stored_reports(payment_id);
CREATE INDEX IF NOT EXISTS idx_stored_reports_service_type ON public.stored_reports(service_type);
CREATE INDEX IF NOT EXISTS idx_stored_reports_created_at ON public.stored_reports(created_at DESC);

-- Enable RLS
ALTER TABLE public.stored_reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Select: Users can only view their own stored reports
CREATE POLICY stored_reports_select_own ON public.stored_reports
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- Insert: Service role only (via RPC)
CREATE POLICY stored_reports_insert_service ON public.stored_reports
  FOR INSERT TO service_role
  WITH CHECK (true);

-- ================================================================
-- RPC Function: Store a report
-- ================================================================
CREATE OR REPLACE FUNCTION fn_store_report(
  p_user_id UUID,
  p_payment_id UUID DEFAULT NULL,
  p_service_type TEXT DEFAULT '',
  p_service_label TEXT DEFAULT '',
  p_report_data JSONB DEFAULT '{}'::jsonb,
  p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_report_id UUID;
BEGIN
  INSERT INTO stored_reports (
    user_id,
    payment_id,
    service_type,
    service_label,
    report_data,
    metadata
  ) VALUES (
    p_user_id,
    p_payment_id,
    p_service_type,
    p_service_label,
    p_report_data,
    p_metadata
  )
  RETURNING id INTO v_report_id;
  
  RETURN v_report_id;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION fn_store_report TO authenticated;

-- ================================================================
-- RPC Function: Get user's stored reports
-- ================================================================
CREATE OR REPLACE FUNCTION fn_get_user_stored_reports(p_user_id UUID)
RETURNS TABLE (
  id UUID,
  service_type TEXT,
  service_label TEXT,
  report_data JSONB,
  metadata JSONB,
  payment_id UUID,
  created_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    sr.id,
    sr.service_type,
    sr.service_label,
    sr.report_data,
    sr.metadata,
    sr.payment_id,
    sr.created_at
  FROM stored_reports sr
  WHERE sr.user_id = p_user_id
  ORDER BY sr.created_at DESC;
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION fn_get_user_stored_reports TO authenticated;

-- ================================================================
-- RPC Function: Get a single stored report by ID
-- ================================================================
CREATE OR REPLACE FUNCTION fn_get_stored_report(p_report_id UUID)
RETURNS TABLE (
  id UUID,
  user_id UUID,
  service_type TEXT,
  service_label TEXT,
  report_data JSONB,
  metadata JSONB,
  payment_id UUID,
  created_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    sr.id,
    sr.user_id,
    sr.service_type,
    sr.service_label,
    sr.report_data,
    sr.metadata,
    sr.payment_id,
    sr.created_at
  FROM stored_reports sr
  WHERE sr.id = p_report_id
    AND sr.user_id = auth.uid(); -- Ensure user owns the report
END;
$$;

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION fn_get_stored_report TO authenticated;

-- Comments
COMMENT ON TABLE public.stored_reports IS 'Stores frozen report data at purchase time to ensure users see the content they paid for';
COMMENT ON COLUMN public.stored_reports.service_type IS 'Type of service: portrait_ame, cycle_personnel, cycle_business, cycle_sante, guide_horaire, eclairage_decision, phases_vie, timing_lunaire, compatibility, temporal';
COMMENT ON COLUMN public.stored_reports.service_label IS 'Human-readable label for the service';
COMMENT ON COLUMN public.stored_reports.report_data IS 'Complete frozen report data as JSON';
COMMENT ON COLUMN public.stored_reports.metadata IS 'Additional metadata: user inputs, dates, preferences, etc.';
