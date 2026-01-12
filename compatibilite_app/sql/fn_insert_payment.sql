-- ============================================================
-- FIX: SECURITY DEFINER function for payments INSERT
-- This bypasses RLS and ensures payments are always recorded
-- ============================================================

-- 1. Create the function that inserts payment with elevated privileges
CREATE OR REPLACE FUNCTION public.fn_insert_payment(
  p_user_id uuid,
  p_session_id uuid DEFAULT NULL,
  p_transaction_id text DEFAULT NULL,
  p_amount_fcfa int DEFAULT 0,
  p_payment_method text DEFAULT NULL,
  p_status text DEFAULT 'success',
  p_plan_type text DEFAULT 'consultation'
) RETURNS jsonb
LANGUAGE plpgsql 
SECURITY DEFINER 
SET search_path = public
AS $$
DECLARE
  v_id uuid;
  v_result jsonb;
BEGIN
  -- Generate a new UUID for the payment
  v_id := gen_random_uuid();
  
  -- Insert the payment record
  INSERT INTO payments (
    id, 
    user_id, 
    session_id, 
    transaction_id, 
    amount_fcfa, 
    payment_method, 
    status, 
    plan_type
  )
  VALUES (
    v_id, 
    p_user_id, 
    p_session_id, 
    p_transaction_id, 
    p_amount_fcfa, 
    p_payment_method, 
    p_status, 
    p_plan_type
  );
  
  -- Return the inserted record as JSON
  SELECT jsonb_build_object(
    'id', v_id,
    'user_id', p_user_id,
    'session_id', p_session_id,
    'transaction_id', p_transaction_id,
    'amount_fcfa', p_amount_fcfa,
    'payment_method', p_payment_method,
    'status', p_status,
    'plan_type', p_plan_type,
    'created_at', now()
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- 2. Grant execution to authenticated users
GRANT EXECUTE ON FUNCTION public.fn_insert_payment TO authenticated;

-- 3. Add a comment for documentation
COMMENT ON FUNCTION public.fn_insert_payment IS 
'Inserts a payment record bypassing RLS. Used by the mobile app after successful payment callback.';
