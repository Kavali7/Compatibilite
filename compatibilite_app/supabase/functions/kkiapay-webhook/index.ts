import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-kkiapay-signature',
}

interface KkiapayWebhookPayload {
  transactionId: string
  status: string
  amount: number
  phone?: string
  email?: string
  reason?: string
  data?: {
    transactionId?: string
    amount?: number
    phone?: string
    email?: string
    reason?: string
  }
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Only accept POST requests
    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Validate webhook secret
    const webhookSecret = Deno.env.get('KKIAPAY_WEBHOOK_SECRET')
    const receivedSignature = req.headers.get('x-kkiapay-signature')

    if (webhookSecret && receivedSignature !== webhookSecret) {
      console.error('Invalid webhook signature')
      return new Response(
        JSON.stringify({ error: 'Invalid signature' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Parse the webhook payload
    const payload: KkiapayWebhookPayload = await req.json()
    console.log('Kkiapay webhook received:', JSON.stringify(payload))

    // Extract transaction details
    const transactionId = payload.transactionId || payload.data?.transactionId
    const status = payload.status
    const amount = payload.amount || payload.data?.amount
    const reason = payload.reason || payload.data?.reason

    if (!transactionId) {
      console.error('No transactionId in payload')
      return new Response(
        JSON.stringify({ error: 'Missing transactionId' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Initialize Supabase client with service role key
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Determine payment status
    let paymentStatus: string
    if (status === 'SUCCESS' || status === 'PAYMENT_SUCCESS') {
      paymentStatus = 'success'
    } else if (status === 'FAILED' || status === 'PAYMENT_FAILED') {
      paymentStatus = 'failed'
    } else if (status === 'CANCELLED' || status === 'PAYMENT_CANCELLED') {
      paymentStatus = 'cancelled'
    } else {
      paymentStatus = 'pending'
    }

    console.log(`Processing payment: ${transactionId} with status: ${paymentStatus}`)

    // Update the payment record in the payments table
    const { data: paymentData, error: paymentError } = await supabase
      .from('payments')
      .update({
        status: paymentStatus,
        updated_at: new Date().toISOString(),
      })
      .eq('transaction_id', transactionId)
      .select()

    if (paymentError) {
      console.error('Error updating payment:', paymentError)
      // Don't fail - the payment might not exist yet in our DB
    } else {
      console.log('Payment updated:', paymentData)
    }

    // Also update sessions_compatibilite if transaction matches reference_paiement
    if (paymentStatus === 'success') {
      const { data: sessionData, error: sessionError } = await supabase
        .from('sessions_compatibilite')
        .update({
          statut_paiement: 'paid',
          paye_le: new Date().toISOString(),
          fournisseur_paiement: 'kkiapay',
        })
        .eq('reference_paiement', transactionId)
        .select()

      if (sessionError) {
        console.error('Error updating session:', sessionError)
      } else if (sessionData && sessionData.length > 0) {
        console.log('Session updated:', sessionData)
      }
    }

    // Log the webhook event for debugging
    const { error: logError } = await supabase
      .from('webhook_logs')
      .insert({
        provider: 'kkiapay',
        event_type: status,
        transaction_id: transactionId,
        payload: payload,
        processed_at: new Date().toISOString(),
      })

    if (logError) {
      // Table might not exist, that's okay
      console.log('Could not log webhook (table may not exist):', logError.message)
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Webhook processed',
        transactionId,
        status: paymentStatus
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Webhook error:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error', details: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
