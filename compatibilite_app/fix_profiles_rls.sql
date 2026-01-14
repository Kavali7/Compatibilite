-- Enable RLS just in case
ALTER TABLE public.couple_profiles ENABLE ROW LEVEL SECURITY;

-- Allow users to insert their own profile
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.couple_profiles;
CREATE POLICY "Users can insert their own profile"
ON public.couple_profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own profile
DROP POLICY IF EXISTS "Users can update their own profile" ON public.couple_profiles;
CREATE POLICY "Users can update their own profile"
ON public.couple_profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Allow users to view their own profile
DROP POLICY IF EXISTS "Users can view their own profile" ON public.couple_profiles;
CREATE POLICY "Users can view their own profile"
ON public.couple_profiles
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Allow service role full access (just in case)
DROP POLICY IF EXISTS "Service role full access on profiles" ON public.couple_profiles;
CREATE POLICY "Service role full access on profiles"
ON public.couple_profiles
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
